module  AND32Bit(out, in1, in2);
  input [31:0]  in1, in2;
  output  [31:0]  out;
  assign  {out} = in1 & in2;
endmodule

module  OR32Bit(out, in1, in2);
  input [31:0]  in1, in2;
  output  [31:0]  out;
  assign  {out} = in1 | in2;
endmodule

module Mux2To1(out, select, in1, in2);
  input in1, in2, select;
  output  out;
  wire  not_select, a1, a2;
  not g1(not_select, select);
  and g2(a1, in1, not_select);
  and g3(a2, in2, select);
  or  g4(out, a1, a2);
endmodule 

module  Mux8Bit_2To1_generate(out, select, in1, in2);
  input [7:0] in1, in2;
  input select;
  output  [7:0] out;
  genvar  j;
  generate  for(j = 0; j < 8; j = j + 1)  
    begin:  mux_loop
      Mux2To1 Mux(out[j], select, in1[j], in2[j]);
    end
  endgenerate
endmodule

module  Mux32Bit_2To1(out, select, in1, in2);
  input [31:0] in1, in2;
  input select;
  output  [31:0] out;
  Mux8Bit_2To1_generate Mux1(out[7:0], select, in1[7:0], in2[7:0]);
  Mux8Bit_2To1_generate Mux2(out[15:8], select, in1[15:8], in2[15:8]);
  Mux8Bit_2To1_generate Mux3(out[23:16], select, in1[23:16], in2[23:16]);
  Mux8Bit_2To1_generate Mux4(out[31:24], select, in1[31:24], in2[31:24]);
endmodule 

module  Mux32Bit_4To1(out, select, in1, in2, in3, in4);
  input [31:0]  in1, in2, in3, in4;
  input [1:0] select;
  output  [31:0]  out;
  wire  [31:0]  w1, w2;
  Mux32Bit_2To1 Mux0(w1[31:0], select[0], in1[31:0], in2[31:0]);
  Mux32Bit_2To1 Mux1(w2[31:0], select[0], in3[31:0], in4[31:0]);
  Mux32Bit_2To1 Mux2(out[31:0], select[1], w1[31:0], w2[31:0]);
endmodule 

module DECODER(out, x, y, z);
  input x, y, z;
  output  [0:7]out;
  wire  x0, y0, z0;
  not g1(x0, x);
  not g2(y0, y);
  not g3(z0, z);
  and g4(out[0], x0, y0, z0);
  and g5(out[1], x0, y0, z);
  and g6(out[2], x0, y, z0);
  and g7(out[3], x0, y, z);
  and g8(out[4], x, y0, z0);
  and g9(out[5], x, y0, z);
  and g10(out[6], x, y, z0);
  and g11(out[7], x, y, z);
endmodule

module  FADDER(carry, sum, x, y, z);
  input x, y, z;
  output  sum, carry;
  wire  [0:7] d; 
  DECODER dec(d, x, y, z);
  assign  sum = d[1] | d[2] | d[4] | d[7],
          carry = d[3] | d[5] | d[6] | d[7];
endmodule

module FADDER8(carry, sum, A, B, CarryIn);
  input [7:0] A, B;
  input CarryIn;
  output  [7:0]sum;
  output  carry;
  wire  c1, c2, c3, c4, c5, c6, c7;
  FADDER  mod1(c1, sum[0], A[0], B[0], CarryIn);
  FADDER  mod2(c2, sum[1], A[1], B[1], c1);
  FADDER  mod3(c3, sum[2], A[2], B[2], c2);
  FADDER  mod4(c4, sum[3], A[3], B[3], c3);
  FADDER  mod5(c5, sum[4], A[4], B[4], c4);
  FADDER  mod6(c6, sum[5], A[5], B[5], c5);
  FADDER  mod7(c7, sum[6], A[6], B[6], c6);
  FADDER  mod8(carry, sum[7], A[7], B[7], c7);
endmodule

module FADDER32(carry, sum, A, B, CarryIn);
  input [31:0] A, B;
  input CarryIn;
  output  [31:0]sum;
  output  carry;
  wire  c1, c2, c3; 
  FADDER8  mod1(c1, sum[7:0], A[7:0], B[7:0], CarryIn);
  FADDER8  mod2(c2, sum[15:8], A[15:8], B[15:8], c1);
  FADDER8  mod3(c3, sum[23:16], A[23:16], B[23:16], c2);
  FADDER8  mod4(carry, sum[31:24], A[31:24], B[31:24], c3);
endmodule

module  ALU32Bit(CarryOut, Result, A, B, Op, BiInvert);
  output  [31:0]  Result;
  output  CarryOut;
  input [31:0]  A, B;
  input [1:0] Op;
  input BiInvert;
  wire  [31:0]  wAnd, wOr, wAdd, wMux, notB;
  assign  {notB} = ~B;
  AND32Bit  And(wAnd, A, B);
  OR32Bit Or(wOr, A, B);
  Mux32Bit_2To1 Mux1(wMux, BiInvert, B, notB);
  FADDER32  Add(CarryOut, wAdd, A, wMux, BiInvert);
  Mux32Bit_4To1 Mux2(Result, Op, wAnd, wOr, wAdd, 32'h00000000);
endmodule

module  ALUTestBench;
  reg BiInvert;
  reg [1:0] Op;
  reg [31:0] A,B;
  wire  [31:0] Result;
  wire  CarryOut;
  ALU32Bit  ALU(CarryOut, Result, A, B, Op, BiInvert);
  initial begin
    $monitor($time, " :A = %b,\n\t B = %b,\n\t Operartion = %b,\n\t BiInvert = %b,\n\t Result = %b,\n\t Carry Out = %b.", A, B, Op, BiInvert, Result, CarryOut);
    #0  A = 32'ha5a5a5a5; B = 32'h5a5a5a5a; Op = 2'b00; BiInvert = 1'b0; //must perform AND resulting in zero
    #100  Op = 2'b01;       //OR
    #100  Op = 2'b10;       //ADD
    #100  BiInvert = 1'b1;  //SUB
    #200  $finish;
  end
endmodule
