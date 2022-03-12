module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
); 
    assign out_sop = (c & d) | (~a & ~b & c); //最小项之和
    assign out_pos = (c) & (~a | b) & (d | ~b);  //最大项之积
   
    
endmodule
