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
					 STOP    = 3'b100;

	reg [2:0] state, next;
	reg [3:0] i;
	reg [7:0] out;

	always @(*) begin
		case(state)
			IDLE  : next = (in) ? IDLE : START;
			START : next = RECEIVE;
			RECEIVE : begin
				if (i == 8) begin
					if (in) next = STOP;
					else next = WAIT;
				end 
				else next = RECEIVE;			
			end
			WAIT : next = (in) ? IDLE : WAIT;
			STOP : next = (in) ? IDLE : START;
		endcase
	end

	always @(posedge clk) begin
		if(reset) state <= IDLE;
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			i <= 0;
		end
		else begin
			case(next) 
				RECEIVE : begin
					done <= 0;
					i = i + 1;
				end
				STOP : begin
					done <= 1;
					i <= 0;
				end
				default : begin
					done <= 0;
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

    assign out_byte = (done) ? out : 8'b0;

endmodule

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
    reg[2:0] state, next_state;
    reg[3:0] data_cnt;
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
                if(data_cnt == 8)
                    if(in)
                        next_state <= STOP;
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
    // New: Datapath to latch input bits.
    always @(posedge clk) begin
        if(reset)
            out_byte <= 0;
        else if(state == START && data_cnt < 8)
            out_byte[data_cnt] <= in;
        else
            out_byte <= out_byte;
    end
endmodule


