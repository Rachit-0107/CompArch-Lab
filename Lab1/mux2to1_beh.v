// Behavioural Modelling 2:1 Mux

module mux2to1(Out, A, B, select);
  input A, B, select;
  output Out;
  reg Out;
  always@(A or B or select)
  if(select==1)
    Out = A;
  else
    Out = B;
endmodule

module tb;
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
