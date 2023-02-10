//Data Flow 4 bit full adder, adder subtractor on control input

module fullAdder(S, C, x, y, z);
  input x, y, z;
  output S, C;
  assign  {C, S} = x + y + z;
endmodule

module _4bit_Adder(S, Cout, A, B, Cin);
  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  assign {Cout, S} = A + B + Cin;
endmodule

module _4bit_Adder_Sub(Sum, Carry, A, B, Select);
  input [3:0] A, B;
  input Select;
  output [3:0] Sum;
  output Carry;
  assign  {Carry, Sum} = A + (B^Select) + Select;
endmodule


module tb;
  reg [3:0]A, B;
  reg Select;
  wire [3:0]Sum;
  wire Carry;
  _4bit_Adder_Sub mod(Sum, Carry, A, B, Select);
  initial
    begin
      $monitor($time, " A=%4b, B=%4b, Select=%b, Carry=%b, Sum=%4b.", A, B, Select, Carry, Sum);
      #0  A=4'b0000; B=4'b0000; Select=1'b0;
      #10 A=4'b1000; B=4'b0101; Select=1'b1;
      #10 A=4'b1111; B=4'b1000; Select=1'b1;
      #10 $finish;
    end
endmodule
