module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

	localparam [3:0] NONE = 0,
					 ONE  = 1,
					 TWO  = 2,
					 THREE= 3,
					 FOUR = 4,
					 FIVE = 5,
					 SIX  = 6,
					 DISC = 7,
					 FLAG = 8,
					 ERR  = 9;

	reg [3:0] state, next;

	always @(*) begin
		case (state)
			NONE : next = (in) ? ONE   : NONE;
			ONE	 : next = (in) ? TWO   : NONE;
			TWO	 : next = (in) ? THREE : NONE;
			THREE: next = (in) ? FOUR  : NONE;
			FOUR : next = (in) ? FIVE  : NONE;
			FIVE : next = (in) ? SIX   : DISC;
			SIX	 : next = (in) ? ERR   : FLAG;
			DISC : next = (in) ? ONE   : NONE;
			FLAG : next = (in) ? ONE   : NONE;
			ERR  : next = (in) ? ERR   : NONE;
		endcase
	end 

	always @(posedge clk) begin
		if (reset)
			state <= NONE;
		else 
			state <= next;
	end

	assign disc = (state == DISC);
	assign flag = (state == FLAG);
	assign err = (state == ERR);
endmodule

module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    reg[3:0] state, next_state;
    parameter IDLE = 0,
    		  BYTE1 = 1,
    		  BYTE2 = 2,
    		  BYTE3 = 3,    
    		  BYTE4 = 4,    
    		  BYTE5 = 5,
    		  BYTE6 = 6,
    		  DISC = 7,
    		  FLAG = 8,
    		  ERR = 9;
    
    always @(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
        	state <= next_state;
    end
    
    always @(*) begin
        case(state)
            IDLE: next_state <= (in)? BYTE1 : IDLE;
            BYTE1: next_state <= (in)? BYTE2 : IDLE;
            BYTE2: next_state <= (in)? BYTE3 : IDLE;
            BYTE3: next_state <= (in)? BYTE4 : IDLE;
            BYTE4: next_state <= (in)? BYTE5 : IDLE;
            BYTE5: next_state <= (in)? BYTE6 : DISC;
            BYTE6: next_state <= (in)? ERR : FLAG;
            DISC: next_state <= (in)? BYTE1 : IDLE;
            FLAG: next_state <= (in)? BYTE1 : IDLE;
            ERR: next_state <= (in)? ERR : IDLE;
        endcase
    end
    
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err = (state == ERR);
    
endmodule

