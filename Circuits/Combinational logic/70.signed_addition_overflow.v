module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); //
 
    assign s = a + b;
    assign overflow = (~(a[7] ^ b[7])) & (s[7] != a[7]);

endmodule


module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); //

    assign s = a+b;
    assign overflow = a[7] & b[7] & ~s[7] || ~a[7] & ~b[7] & s[7];
   // 负数相减（补码相加）产生正数，判断溢出。
  
    //正数相加产生一个负数，判断溢出。

endmodule
