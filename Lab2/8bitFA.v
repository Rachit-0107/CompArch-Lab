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

module FADDER(sum, carry, x, y, z);
  input x, y, z;
  output  sum, carry;
  wire  [0:7]d;
  
  DECODER dec(d, x, y, z);
  assign  sum = d[1] | d[2] | d[4] | d[7],
          carry = d[3] | d[5] | d[6] | d[7];
endmodule 

module FADDER8(sum, carry, A, B, CarryIn);
  input [7:0] A, B;
  input CarryIn;
  output  [7:0]sum;
  output  carry;
  wire  c1, c2, c3, c4, c5, c6, c7;
  
  FADDER  mod1(sum[0], c1, A[0], B[0], CarryIn);
  FADDER  mod2(sum[1], c2, A[1], B[1], c1);
  FADDER  mod3(sum[2], c3, A[2], B[2], c2);
  FADDER  mod4(sum[3], c4, A[3], B[3], c3);
  FADDER  mod5(sum[4], c5, A[4], B[4], c4);
  FADDER  mod6(sum[5], c6, A[5], B[5], c5);
  FADDER  mod7(sum[6], c7, A[6], B[6], c6);
  FADDER  mod8(sum[7], carry, A[7], B[7], c7);
endmodule 

module testbench_8BFA;
  reg [7:0] A, B;
  reg CarryIn;
  wire  [7:0]Sum;
  wire  Carry;
  integer i, j;
  FADDER8 mod(Sum, Carry, A, B, CarryIn);
  
  initial
    begin
      $monitor($time," A = %b, B = %b, Carry In = %b, Carry = %b, Sum = %b.", A, B, CarryIn, Carry, Sum);
      #0  A=8'b00000000;  B=8'b00000000;  CarryIn=1'b0;
      for(i=0; i<256; i=i+1)
        begin
          for(j=0; j<256; j=j+1)
            begin
              #3  CarryIn=1'b0;
              #3  CarryIn = CarryIn+1'b1;
              B=B+8'b00000001;
            end
            A=A+8'b00000001;
        end
    end
endmodule
