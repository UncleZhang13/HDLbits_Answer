`timescale 1ps / 1ps 
module top_module ( );
    parameter time_period = 10;
    reg clk;
    initial clk = 0;
    always begin
        #(time_period / 2) clk = ~clk;
    end
    
    dut u_dut(
        .clk(clk)
    );

endmodule


`timescale 1ps / 1ps 
module top_module ( );
    reg clk;
    parameter CLK = 10;
    initial begin 
        clk = 0;
		forever 
            #(CLK / 2) clk = ~clk;
    end
        dut u_dut(
        .clk(clk)
    );
endmodule
