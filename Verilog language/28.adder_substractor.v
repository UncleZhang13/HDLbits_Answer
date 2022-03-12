module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire cout1;
    wire [15:0] sum1;
    wire [15:0] sum2;
    wire [31:0] b_s;
    
    assign b_s = b ^ {32{sub}};
    
    add16 instance1 ( a[15:0], b_s[15:0], sub, sum1[15:0], cout1 );
    add16 instance2 ( a[31:16], b_s[31:16], cout1, sum2[15:0] );
    
    assign sum = {sum2, sum1};
 
endmodule
