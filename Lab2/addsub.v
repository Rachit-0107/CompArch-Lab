module FULLADDER(Sum, Carry, A, B, C);
  input A, B, C;
  wire a;
  output  Sum, Carry;
  reg Sum, Carry;
  
  always@(A or B or C)
  {Carry, Sum} = A + B + C;
endmodule 

module ADDSUB(Sum, Carry, V, A, B, M);
  input [3:0] A, B;
  input M;
  output  [3:0]Sum;
  output  Carry, V;
  wire  [3:0]C;
  wire  c1, c2, c3;
  
  xor g1(C[0], B[0], M);
  xor g2(C[1], B[1], M);
  xor g3(C[2], B[2], M);
  xor g4(C[3], B[3], M);
  
  FULLADDER f1(Sum[0], c1, A[0], C[0], M);
  FULLADDER f2(Sum[1], c2, A[1], C[1], c1);
  FULLADDER f3(Sum[2], c3, A[2], C[2], c2);
  FULLADDER f4(Sum[3], Carry, A[3], C[3], c3);
  
  xor g5(V, Carry, c3);
endmodule 

module testbench_AS;
  reg [3:0]A, B;
  reg Select;
  wire [3:0]Sum;
  wire Carry, Overflow;
  ADDSUB mod(Sum, Carry, Overflow, A, B, Select);
  initial
    begin
      $monitor($time, " A=%4b, B=%4b, Select=%b, Carry=%b, Sum=%4b, Overflow=%b.", A, B, Select, Carry, Sum, Overflow);
      #0  A=4'b0000; B=4'b0000; Select=1'b0;
      #10 A=4'b1000; B=4'b0101; Select=1'b1;
      #10 A=4'b1111; B=4'b1000; Select=1'b1;
      #10 $finish;
    end
endmodule
