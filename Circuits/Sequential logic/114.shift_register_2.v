module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    
    MUXDFF ins0(SW[3], KEY[0], KEY[1], KEY[2], KEY[3], LEDR[3]);
    MUXDFF ins1(SW[2], KEY[0], KEY[1], KEY[2], LEDR[3], LEDR[2]);
    MUXDFF ins2(SW[1], KEY[0], KEY[1], KEY[2], LEDR[2], LEDR[1]);
    MUXDFF ins3(SW[0], KEY[0], KEY[1], KEY[2], LEDR[1], LEDR[0]);

endmodule

module MUXDFF (
    input R,
    input clk,
    input E,
    input L,
    input w,
    output out
);
    wire [1:0] temp;
    assign temp[0] = E ? w : out;
    assign temp[1] = L ? R : temp[0];
    
    always @(posedge clk) begin
        out <= temp[1];
    end

endmodule

module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    MUXDFF inst1(KEY[0], LEDR[1], SW[0], KEY[1], KEY[2], LEDR[0]);
    MUXDFF inst2(KEY[0], LEDR[2], SW[1], KEY[1], KEY[2], LEDR[1]);
    MUXDFF inst3(KEY[0], LEDR[3], SW[2], KEY[1], KEY[2], LEDR[2]);
    MUXDFF inst4(KEY[0], KEY[3], SW[3], KEY[1], KEY[2], LEDR[3]);
endmodule

module MUXDFF (
	input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);
    always @(posedge clk)
        begin
            if(L)
                Q <= R;
            else
                begin
                    if(E)
                        Q <= w;
                    else
                        Q <= Q;
                end
        end
endmodule
