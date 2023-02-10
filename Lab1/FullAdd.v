// gate level full adder

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

module tb_fulladder;
  reg x, y, z;
  wire S, C;
  fullAdder_gate mod(S, C, x, y, z);
  initial
    begin
      $monitor($time, " x=%b, y=%b, z=%b, C=%b, S=%b.", x, y, z, C, S);
      #0  x=1'b0; y=1'b0; z=1'b0;
      #10 z=z+1'b1;
      #10 y=y+1'b1; z=z+1'b1;
      #10 z=z+1'b1;
      #10 x=x+1'b1; y=y+1'b1; z=z+1'b1;
      #10 z=z+1'b1;
      #10 y=y+1'b1; z=z+1'b1;
      #10 z=z+1'b1;
      #10 $finish;
    end
endmodule 
