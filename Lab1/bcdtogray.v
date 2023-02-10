// Gate level BCD to gray code convertor

module bcdToGray(Out, In);
  input [3:0]In;
  output [3:0]Out;
  
  buf g0(Out[3], In[3]);
  xor g1(Out[2], In[3], In[2]);
  xor g2(Out[1], In[2], In[1]);
  xor g3(Out[0], In[1], In[0]);
endmodule 

module tb_bcdtogr;
  reg [3:0]In;
  wire [3:0]Out;
  bcdToGray_gate mod(Out, In);
  initial
  begin
    $monitor($time, " In=%4b, Out=%4b.", In, Out);
    #0  In = 4'b0000;
      repeat(9)
    #10 In = In + 4'b0001;
  end
endmodule
