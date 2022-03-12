module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    
    reg [2:0] Q;
    
    always @(posedge clk) begin
        if(resetn) begin
            Q[0] <= in;
            Q[1] <= Q[0];
            Q[2] <= Q[1];
            out <= Q[2];
        end
        else begin
            Q <= 3'b0;
            out <= 1'b0;
        end
    end

endmodule


module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    wire Q0, Q1, Q2;
    Trigger inst1(clk, resetn, in, Q0);
    Trigger inst2(clk, resetn, Q0, Q1);
    Trigger inst3(clk, resetn, Q1, Q2);
    Trigger inst4(clk, resetn, Q2, out);
endmodule

module Trigger(
    input clk,
    input resetn,
    input in,
    output reg out );
    always @(posedge clk)
        begin
            if(!resetn)
                out <= 1'b0;
            else
                out <= in;
        end
endmodule
    
