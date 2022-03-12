module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
	
    wire L;
    wire clk;
    wire [2:0] R;
    reg [2:0] Q;
    assign R = SW;
    assign clk = KEY[0];
    assign L = KEY[1];
        
    always @(posedge clk) begin
        if(L) Q <= R;
        else Q <= {Q[2]^Q[1], Q[0], Q[2]};
    end
    
    assign LEDR = Q;
    

endmodule


module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
    Trigger inst1(KEY[0], KEY[1], SW[0], LEDR[2], LEDR[0]);
    Trigger inst2(KEY[0], KEY[1], SW[1], LEDR[0], LEDR[1]);
    Trigger inst3(KEY[0], KEY[1], SW[2], LEDR[1]^LEDR[2], LEDR[2]);
endmodule

module Trigger (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);
    always @(posedge clk)
        begin
            if(L)
                Q <= r_in;
            else
                Q <= q_in;
        end
endmodule

