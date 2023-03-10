// Data Flow bcd to gray 

module bcdToGray(Out, In);
  input [3:0]In;
  output [3:0]Out;
  assign  Out[3] = In[3],
          Out[2:0] = In[3:1] ^ In[2:0];
endmodule 

module tb;
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
