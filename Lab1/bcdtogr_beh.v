// Beh Level Comparator 

module bcdToGray(Out, In);
  integer i;
  input [3:0]In;
  wire [3:0]In;
  output [3:0]Out;
  reg [3:0]Out;
  always@(In)
  begin
    Out[3] = In[3];
    for(i = 3; i > -1; i=i-1)
      Out[i-1] = In[i] ^ In[i-1];
  end
endmodule 

module testbench03;
  reg [3:0]In;
  wire [3:0]Out;
  bcdToGray mod(Out, In);
  initial
  begin
    $monitor($time, " In=%4b, Out=%4b.", In, Out);
    #0  In = 4'b0000;
      repeat(9)
    #10 In = In + 4'b0001;
  end
endmodule
