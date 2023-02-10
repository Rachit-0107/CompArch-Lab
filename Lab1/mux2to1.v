// 2:1 mux using Gate Level Modelling

module mux2to1(Out, A, B, select);
  input A, B, select;
  output Out;
  wire c, d, e;
  
  not g1(e, select);
  and g2(c, A, select);
  and g3(d, B, e);
  or g4(Out, c, d);
endmodule 

module tb_2to1;
  reg a, b, sel;
  wire out;
  mux2to1 mod(out, a, b, sel);
  initial
    begin
      $monitor($time, " a=%b, b=%b, sel=%b, out=%b", a, b, sel, out);
      #0 a=1'b0; b=1'b1;
      #2 sel=1'b1;
      #5 sel=1'b0;
      #10 a=1'b1; b=1'b0;
      #15 sel=1'b1;
      #20 sel=1'b0;
      #100 $finish;
    end
  endmodule
