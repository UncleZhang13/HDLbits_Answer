module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

	localparam A = 0,
			   B = 1;

	reg state, next;
	reg [2:0] cnt;
	reg [2:0] w_record;

	always @(*) begin
		case(state)
			A : next = (s) ? B : A;
			B : next = B;
		endcase
	end

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
		end
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) w_record <= 0;
		else if (state == B) 
			w_record <= {w_record[1:0], w}; //update the record of w.
	end

	always @(posedge clk) begin
		if (reset) cnt <= 0;
		else if (next == B) begin
			if (cnt == 3) 
				cnt <= 1;
			else 
				cnt <= cnt + 1;
		end
	end

	assign z = ((cnt == 1) & ((w_record == 3'b011) | (w_record == 3'b101) | (w_record == 3'b110)));


endmodule

module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    reg[3:0] state, next_state;
    parameter STATE_A = 0,	//判断s
    		  WAIT = 1,	//进入第一个状态
    		  Z = 2,	//0
    		  ZZ = 3,	//00
    		  ZZZ = 4,	//000
    		  O = 5,	//1
    		  OO = 6,	//11
    		  OOO = 7,	//111
    		  ZO = 8,	//01 or 10
    		  ZOO = 9, //011 or 110 or 101	  
    		  OZZ = 10; //100 or 010 or 001
    always @(posedge clk) begin
        if(reset)
            state <= STATE_A;
        else
            state <= next_state;
    end
    
    always @(*) begin
        case(state)
            STATE_A: next_state <= (s)? WAIT : STATE_A;
            WAIT: next_state <= (w)? O : Z;
            O: next_state <= (w)? OO : ZO;
            OO: next_state <= (w)? OOO : ZOO;
            OOO: next_state <= (w)? O : Z;
            Z: next_state <= (w)? ZO : ZZ;
            ZZ: next_state <= (w)? OZZ : ZZZ;
            ZZZ: next_state <= (w)? O : Z;
            ZO: next_state <= (w)? ZOO : OZZ;
            ZOO:  next_state <= (w)? O : Z;
            OZZ: next_state <= (w)? O : Z;
        endcase
    end
    
    assign z = (state == ZOO);

endmodule

