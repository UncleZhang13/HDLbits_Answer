module top_module( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );
	
	assign out_both = in[98:0] & in[99:1];
	assign out_any = in[98:0] | in[99:1];
	assign out_different = {(in[99] ^ in[0]), in[98:0] ^ in[99:1]};
endmodule


module top_module( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );
    
    integer i;
    always @(*)
        begin
            out_different[99] = in[99] ^ in[0];
            for(i=0; i<99; i++)
                begin
                    out_both[i] = in[i] & in[i+1];
                    out_any[i+1] = in[i] | in[i+1];
                    out_different[i] = in[i] ^ in[i+1];
                end
        end
    
endmodule