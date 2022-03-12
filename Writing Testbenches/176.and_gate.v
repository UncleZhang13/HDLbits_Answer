`timescale 1ps / 1ps
module top_module();
    reg [1:0] in;
    wire out;
    
    initial begin
        in = 2'b00;
        #10;
        in = 2'b01;
        #10;
        in = 2'b10;
        #10;
        in = 2'b11;
    end
    andgate u_andgate(
        .in(in),
        .out(out)
    );

endmodule

`timescale 1ps / 1ps 
module top_module();
    reg [1:0] in;
    wire out;
    andgate a1(in[1:0], out);
    
    initial begin
        in[1] = 0; in[0] = 0;
        #10; in[1] = 0; in[0] = 1;
        #10; in[1] = 1; in[0] = 0;
        #10; in[1] = 1; in[0] = 1;
    end

endmodule
