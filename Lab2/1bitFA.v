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

module testbench_1BFA;
  reg x,y,z;
  wire  s,c;
  FADDER  fl(s,c,x,y,z);
  initial
    begin
      $monitor($time," x = %b, y = %b, z = %b, carry = %b, sum = %b.", x, y, z, c, s);
      #0 x=1'b0; y=1'b0; z=1'b0;
      #4 x=1'b0; y=1'b0; z=1'b1;
      #4 x=1'b0; y=1'b1; z=1'b0;
      #4 x=1'b0; y=1'b1; z=1'b1;
      #4 x=1'b1; y=1'b0; z=1'b0;
      #4 x=1'b1; y=1'b0; z=1'b1;
      #4 x=1'b1; y=1'b1; z=1'b0;
      #4 x=1'b1; y=1'b1; z=1'b1;
    end
endmodule
