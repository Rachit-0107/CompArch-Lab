// Data Flow Full adder

module fullAdder(S, C, x, y, z);
  input x, y, z;
  output S, C;
  assign  {C, S} = x + y + z;
endmodule

module tb;
  reg x, y, z;
  wire S, C;
  fullAdder mod(S, C, x, y, z);
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
