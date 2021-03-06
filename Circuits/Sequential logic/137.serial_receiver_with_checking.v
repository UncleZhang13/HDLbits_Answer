module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); 
	
    // Use FSM from Fsm_serial
    localparam [2:0] IDLE 	 = 3'b000,
					 START 	 = 3'b001,
					 RECEIVE = 3'b010,
					 WAIT	 = 3'b011,
					 STOP    = 3'b100,
					 CHECK   = 3'b101;

	reg [2:0] state, next;
	reg [3:0] i;
	reg [7:0] out;
	reg odd_reset;
	reg odd_reg;
	//We can't use a reg-type variable in the instance module,
	//so we need to declare a wire-type to be used in the instance module.
	wire odd;	
	

	always @(*) begin
		case(state)
			IDLE  	: next = (in) ? IDLE : START;
			START 	: next = RECEIVE;
			RECEIVE : next = (i == 8) ? CHECK : RECEIVE;
			CHECK 	: next = (in) ? STOP : WAIT;
			WAIT 	: next = (in) ? IDLE : WAIT;
			STOP 	: next = (in) ? IDLE : START;
		endcase
	end

	always @(posedge clk) begin
		if(reset) state <= IDLE;
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) begin
			i <= 0;
		end
		else begin
			case(next) 
				RECEIVE : begin
					i = i + 1;
				end
				STOP : begin
					i <= 0;
				end
				default : begin
					i <= 0;
				end
			endcase
		end
	end

    // New: Datapath to latch input bits.
    always @(posedge clk) begin
    	if (reset) out <= 0;
    	else if (next == RECEIVE)
    		out[i] <= in;
    end

    // New: Add parity checking.
    parity u_parity(
        .clk(clk),
        .reset(reset | odd_reset),
        .in(in),
        .odd(odd));  

    always @(posedge clk) begin
    	if(reset) odd_reg <= 0;
    	else odd_reg <= odd; 
    end

    //Only the IDLE-state and STOP-state are likely to enter the RECEIVE-state, 
    //so we need to reset the bits to avoid the previous result's affection.
    always @(posedge clk) begin
		case(next)
			IDLE : odd_reset <= 1;	
			STOP : odd_reset <= 1;
			default : odd_reset <= 0;
		endcase
    end

    assign done = ((state == STOP) && odd_reg);
    assign out_byte = (done) ? out : 8'b0;


endmodule
—————————————————————————————————
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //
    reg[2:0] state, next_state;
    reg[3:0] data_cnt;
    reg odd;
    parameter IDLE = 0,
    		  START = 1,
    		  STOP = 2,
    		  WAIT = 3;
    
    always @(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(posedge clk) begin
        if(reset)
            data_cnt <= 4'b0;
        else begin
            if(state == START)
                data_cnt <= data_cnt + 1'b1;
            else if(state == WAIT)
                data_cnt <= data_cnt;
            else
                data_cnt <= 4'b0;
    	end
    end
    
    always @(*) begin
        case(state)
            IDLE: next_state <= (in)? IDLE : START;
            START: begin
                if(data_cnt == 9)
                    if(in) begin
                      		   if(odd)		//如果有奇数个1 那么就输出done，否则不输出
                                    next_state <= STOP;
                                else
                                    next_state <= IDLE;
                            end
                	else
                        next_state <= WAIT;
                else
                    next_state <= state;
            end
            STOP: next_state <= (in)? IDLE : START;
            WAIT: next_state <= (in)? IDLE : WAIT;
        endcase
    end
    
    assign done = (state == STOP);

    // New: Add parity checking.
    always @(posedge clk) begin
        if(reset)
            out_byte <= 0;
        else if(state == START && data_cnt < 8)
            out_byte[data_cnt] <= in;
        else
            out_byte <= out_byte;
    end
    
    parity inst1(clk, (state != START), in, odd);
endmodule


