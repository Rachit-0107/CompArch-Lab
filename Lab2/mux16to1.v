// Gate Level 16:1 Mux from 4:1 Mux

module mux4To1(out, in, select);
  input [0:3]in;
  input [0:1]select;
  output  out;
  wire  [0:1]nselect;
  wire  a1, a2, a3, a4;
  
  not g1(nselect[0], select[0]);
  not g2(nselect[1], select[1]);
  
  and g3(a1, in[0], nselect[0], nselect[1]);
  and g4(a2, in[1], nselect[0], select[1]);
  and g5(a3, in[2], select[0], nselect[1]);
  and g6(a4, in[3], select[0], select[1]);
  
  or  g7(out, a1, a2, a3, a4);
endmodule 

module mux16To1(out, in, select);
  input [0:15]in;
  input [0:3]select;
  output  out;
  wire  [0:3]w;
  
  mux4To1  mux1(w[0], in[0:3], select[2:3]);
  mux4To1  mux2(w[1], in[4:7], select[2:3]);
  mux4To1  mux3(w[2], in[8:11], select[2:3]);
  mux4To1  mux4(w[3], in[12:15], select[2:3]);
  mux4To1  mux5(out, w[0:3], select[0:1]);
endmodule 

module tb_mux16;
  reg [0:15]in;
  reg [0:3]select;
  wire  out;
  mux16To1_gate mux(out, in, select);
  initial
    begin
      $monitor($time, " Input=%b, Select=%b, Output=%b.", in, select, out);
      #0  in = 16'b1000000000000000;  select = 4'b0000;
      repeat(15)
        begin
          #3  in = in>>1'b1;  select = select + 4'b0001;
        end
    end
endmodule
