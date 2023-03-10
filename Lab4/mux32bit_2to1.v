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

module  TestBench_Mux32Bit;
  reg [31:0] in1, in2;
  reg select;
  wire  [31:0] out;
  Mux32Bit_2To1  Mux(out, select, in1, in2);
  initial begin
    $monitor($time, " Input1 = %b, Input2 = %b, Select = %b, Output = %b.", in1, in2, select, out);
    #0  in1 = 32'b10101010101010101010101010101010;  in2 = 32'b01010101010101010101010101010101;  select = 1'b0;
    #100  select  = 1'b1;
    #200  $finish;
  end
endmodule
