module magComp(ALTB, AGTB, AEQB, A, B);
  input [3:0] A, B;
  output ALTB, AGTB, AEQB;
  reg ALTB, AGTB, AEQB;
  always@(A or B)
    begin
      if(A==B) begin
        ALTB=0;
        AGTB=0;
        AEQB=1;
      end else if(A > B) begin
        ALTB=0;
        AGTB=1;
        AEQB=0;
      end else begin
        ALTB=1;
        AGTB=0;
        AEQB=0;
      end
    end
endmodule 

module tb;
  reg [3:0]A, B;
  wire ALTB, AGTB, AEQB;
  magComp_beh mod(ALTB, AGTB, AEQB, A, B);
  initial
    begin
      $monitor($time, " A=%4b, B=%4b, ALTB=%b, AGTB=%b, AEQB=%b.", A, B, ALTB, AGTB, AEQB);
      #0  A=4'b1010; B=4'b1010;
      #10 A=4'b0101; B=4'b1010;
      #20 A=4'b1111; B=4'b1010;
      #30 $finish;
    end
endmodule

