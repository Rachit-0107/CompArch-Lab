// Gate level 4 bit adder, 4 bit adder subractor using control input

module halfAdder(S, C, x, y);
  input x, y;
  output S, C;
  xor g1(S, x, y);
  and g2(C, x, y);
endmodule

module fullAdder(S, C, x, y, z);
  input x, y, z;
  output S, C;
  wire S1, D1, D2;
  halfAdder  HA1(S1, D1, x, y),
                  HA2(S, D2, S1, z);
  or g1(C, D1, D2);
endmodule

module _4bit_Adder(S, C4, A, B, C0);
  input [3:0] A, B;
  input C0;
  output [3:0] S;
  output C4;
  wire C1, C2, C3;
  fullAdder_gate  FA1(S[0], C1, A[0], B[0], C0),
                  FA2(S[1], C2, A[1], B[1], C1),
                  FA3(S[2], C3, A[2], B[2], C2),
                  FA4(S[3], C4, A[3], B[3], C3);
endmodule

module _4bit_Adder_Sub(Sum, Carry, Overflow, A, B, Select);
  input [3:0] A, B;
  input Select;
  output [3:0] Sum;
  output Carry, Overflow;
  wire C1, C2, C3;
  wire [3:0] D;
  xor 
      g1(D[0], B[0], Select),
      g2(D[1], B[1], Select),
      g3(D[2], B[2], Select),
      g4(D[3], B[3], Select);
  fullAdder_gate  FA1(Sum[0], C1, A[0], D[0], Select),
                  FA2(Sum[1], C2, A[1], D[1], C1),
                  FA3(Sum[2], C3, A[2], D[2], C2),
                  FA4(Sum[3], Carry, A[3], D[3], C3);
  xor g5(Overflow, Carry, C3);
endmodule 

module tb_addsub;
  reg [3:0]A, B;
  reg Select;
  wire [3:0]Sum;
  wire Carry, Overflow;
  _4bit_Adder_Sub mod(Sum, Carry, Overflow, A, B, Select);
  initial
    begin
      $monitor($time, " A=%4b, B=%4b, Select=%b, Carry=%b, Sum=%4b, Overflow=%b.", A, B, Select, Carry, Sum, Overflow);
      #0  A=4'b0000; B=4'b0000; Select=1'b0;
      #10 A=4'b1000; B=4'b0101; Select=1'b1;
      #10 A=4'b1111; B=4'b1000; Select=1'b1;
      #10 $finish;
    end
endmodule
