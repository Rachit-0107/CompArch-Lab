module Instruction_Memory(Inst, PC, clock);
	input[31:0] PC;
	input clock;
	output[31:0] Inst;
	reg [31:0] memory [0:31];
	reg [31:0] Inst;
  integer addr;
  initial begin
    memory[0] = 32'b00000000000000000000000000000000;  // nop
    memory[1] = 32'b00000000000000000000000000000000;  // nop
    memory[2] = 32'b00000000000000000000000000000000;  // nop
    memory[3] = 32'b10001100000100010000000000001000;  // lw  $s1($17), 8($0)
    memory[4] = 32'b10001100000100100000000000000100;  // lw  $s2($18), 4($0)
    memory[5] = 32'b00000010001100100100000000100000;  // add $t0($8), $s1($17), $s2($18)
    memory[6] = 32'b00000000000000000000000000000000;  // nop
    memory[7] = 32'b00000000000000000000000000000000;  // nop
    memory[8] = 32'b00000000000000000000000000000000;  // nop
    memory[9] = 32'b00000000000000000000000000000000;  // nop
    memory[10]= 32'b00000000000000000000000000000000;  // nop
    memory[11]= 32'b00000000000000000000000000000000;  // nop
    memory[12]= 32'b00000000000000000000000000000000;  // nop
    memory[13]= 32'b00000000000000000000000000000000;  // nop
    memory[14]= 32'b00000000000000000000000000000000;  // nop
    memory[15]= 32'b00000000000000000000000000000000;  // nop
    memory[16]= 32'b00000000000000000000000000000000;  // nop
    memory[17]= 32'b00000000000000000000000000000000;  // nop
    memory[18]= 32'b00000000000000000000000000000000;  // nop 
    memory[19]= 32'b00000000000000000000000000000000;  // nop
    memory[20]= 32'b00000000000000000000000000000000;  // nop
    memory[21]= 32'b00000000000000000000000000000000;  // nop
    memory[22]= 32'b00000000000000000000000000000000;  // nop
    memory[23]= 32'b00000000000000000000000000000000;  // nop
    memory[24]= 32'b00000000000000000000000000000000;  // nop
    memory[25]= 32'b00000000000000000000000000000000;  // nop
    memory[26]= 32'b00000000000000000000000000000000;  // nop
    memory[27]= 32'b00000000000000000000000000000000;  // nop
    memory[28]= 32'b00000000000000000000000000000000;  // nop 
    memory[29]= 32'b00000000000000000000000000000000;  // nop
    memory[30]= 32'b00000000000000000000000000000000;  // nop
    memory[31]= 32'b00000000000000000000000000000000;  // nop
  end
  always @(posedge clock) begin
    addr = PC[31:0];
    Inst = memory[addr/4];
	end
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

module Sign_Extender(out, in);
	input [15:0] in;
	output [31:0] out;
	assign out = { {16{in[15]}}, in};	
endmodule 

module Shift_Left(out, in);
	input [31:0] in;
	output [31:0] out;
	assign out = {in[29:0],1'b0,1'b0};
endmodule 

module concatJuPC(out, J, PC);
  input [31:0] J, PC;
  output [31:0] out;
  assign {out} = {{PC[31:28]}, {J[27:0]}};
endmodule 

module  MainControlUnit(RegDst, Jump, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, Op);
  output  RegDst, Jump, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
  input [5:0] Op;
  wire  RFormat, LW, SW, BEQ, J;
  assign  RFormat = (~Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(~Op[1])&(~Op[0]);
  assign  LW = (Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(Op[1])&(Op[0]);
  assign  SW = (Op[5])&(~Op[4])&(Op[3])&(~Op[2])&(Op[1])&(Op[0]);
  assign  BEQ = (~Op[5])&(~Op[4])&(~Op[3])&(Op[2])&(~Op[1])&(~Op[0]);
  assign  J = (~Op[5])&(~Op[4])&(~Op[3])&(~Op[2])&(Op[1])&(~Op[0]);
  assign  Jump = J;
  assign  RegDst = RFormat;
  assign  ALUSrc = LW | SW;
  assign  MemToReg = LW;
  assign  RegWrite = RFormat | LW;
  assign  MemRead = LW;
  assign  MemWrite = SW;
  assign  Branch = BEQ;
  assign  ALUOp0 = BEQ;
  assign  ALUOp1 = RFormat;
endmodule 

module MUX5Bit_2To1(out, select, q1, q2);
	input  [4:0] q1, q2;
	input select;
	output [4:0] out;
	genvar  j;
  generate  for(j = 0; j < 5; j = j + 1)  
    begin:  mux_loop
      Mux2To1 Mux(out[j], select, q1[j], q2[j]);
    end
  endgenerate
endmodule 

module d_ff(q, d, clock, reset);
  input d, clock, reset;
  output  q;
  reg q;
  always @ (posedge clock or negedge reset)
  if(~reset)
    q = 1'b0;
  else
    q = d;
endmodule

module reg_32bit(q, d, clock, reset);
  input [31:0]  d;
  input clock, reset;
  output  [31:0]  q;
  genvar j;
  generate
    for(j = 0; j < 32; j = j + 1) begin:  d_loop
      d_ff ff(q[j], d[j], clock, reset);
    end
  endgenerate
endmodule 

module mux32_1(Out, Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, Select);
  input [31:0]  Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31;
  input [4:0] Select;
  output  [31:0]  Out;
  reg [31:0]  Out;
  always @ (Data00 or Data01 or Data02 or Data03 or Data04 or Data05 or Data06 or Data07 or Data08 or Data09 or Data10 or Data11 or Data12 or Data13 or Data14 or Data15 or Data16 or Data17 or Data18 or Data19 or Data20 or Data21 or Data22 or Data23 or Data24 or Data25 or Data26 or Data27 or Data28 or Data29 or Data30 or Data31 or Select)
    case  (Select)
      5'b00000:  Out = Data00;
      5'b00001:  Out = Data01;
      5'b00010:  Out = Data02;
      5'b00011:  Out = Data03;
      5'b00100:  Out = Data04;
      5'b00101:  Out = Data05;
      5'b00110:  Out = Data06;
      5'b00111:  Out = Data07;
      5'b01000:  Out = Data08;
      5'b01001:  Out = Data09;
      5'b01010:  Out = Data10;
      5'b01011:  Out = Data11;
      5'b01100:  Out = Data12;
      5'b01101:  Out = Data13;
      5'b01110:  Out = Data14;
      5'b01111:  Out = Data15;
      5'b10000:  Out = Data16;
      5'b10001:  Out = Data17;
      5'b10010:  Out = Data18;
      5'b10011:  Out = Data19;
      5'b10100:  Out = Data20;
      5'b10101:  Out = Data21;
      5'b10110:  Out = Data22;
      5'b10111:  Out = Data23;
      5'b11000:  Out = Data24;
      5'b11001:  Out = Data25;
      5'b11010:  Out = Data26;
      5'b11011:  Out = Data27;
      5'b11100:  Out = Data28;
      5'b11101:  Out = Data29;
      5'b11110:  Out = Data30;
      5'b11111:  Out = Data31;
    endcase
endmodule

module RegFile_32(ReadData1, ReadData2, Clock, Reset, RegWrite, ReadReg1, ReadReg2, WriteRegNo, WriteData);
  input Clock, Reset, RegWrite;
  input [4:0] ReadReg1, ReadReg2, WriteRegNo;
  input [31:0]  WriteData;
  output  [31:0]  ReadData1, ReadData2;
  wire  [31:0]  Data0, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31;
  wire  [31:0] Decode;
  wire  [31:0]c;
  genvar  j;
  decoder5_32 dec(Decode, WriteRegNo);
  generate
    for(j = 0; j < 32; j = j + 1) begin:  and_loop
      and g(c[j], RegWrite, Decode[j], Clock);
    end
  endgenerate
  reg_32bit r0(Data0, WriteData, c[0], Reset);
  reg_32bit r1(Data1, WriteData, c[1], Reset);
  reg_32bit r2(Data2, WriteData, c[2], Reset);
  reg_32bit r3(Data3, WriteData, c[3], Reset);
  reg_32bit r4(Data4, WriteData, c[4], Reset);
  reg_32bit r5(Data5, WriteData, c[5], Reset);
  reg_32bit r6(Data6, WriteData, c[6], Reset);
  reg_32bit r7(Data7, WriteData, c[7], Reset);
  reg_32bit r8(Data8, WriteData, c[8], Reset);
  reg_32bit r9(Data9, WriteData, c[9], Reset);
  reg_32bit r10(Data10, WriteData, c[10], Reset);
  reg_32bit r11(Data11, WriteData, c[11], Reset);
  reg_32bit r12(Data12, WriteData, c[12], Reset);
  reg_32bit r13(Data13, WriteData, c[13], Reset);
  reg_32bit r14(Data14, WriteData, c[14], Reset);
  reg_32bit r15(Data15, WriteData, c[15], Reset);
  reg_32bit r16(Data16, WriteData, c[16], Reset);
  reg_32bit r17(Data17, WriteData, c[17], Reset);
  reg_32bit r18(Data18, WriteData, c[18], Reset);
  reg_32bit r19(Data19, WriteData, c[19], Reset);
  reg_32bit r20(Data20, WriteData, c[20], Reset);
  reg_32bit r21(Data21, WriteData, c[21], Reset);
  reg_32bit r22(Data22, WriteData, c[22], Reset);
  reg_32bit r23(Data23, WriteData, c[23], Reset);
  reg_32bit r24(Data24, WriteData, c[24], Reset);
  reg_32bit r25(Data25, WriteData, c[25], Reset);
  reg_32bit r26(Data26, WriteData, c[26], Reset);
  reg_32bit r27(Data27, WriteData, c[27], Reset);
  reg_32bit r28(Data28, WriteData, c[28], Reset);
  reg_32bit r29(Data29, WriteData, c[29], Reset);
  reg_32bit r30(Data30, WriteData, c[30], Reset);
  reg_32bit r31(Data31, WriteData, c[31], Reset);
  mux32_1 m0(ReadData1, Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, ReadReg1);
  mux32_1 m1(ReadData2, Data00, Data01, Data02, Data03, Data04, Data05, Data06, Data07, Data08, Data09, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30, Data31, ReadReg2);
endmodule

module  ALUControlUnit(Op, Func, ALUOp);
  input [5:0] Func;
  input [1:0] ALUOp;
  output  [2:0] Op;
  assign  Op[0] = ALUOp[1] & (Func[3] | Func[0]);
  assign  Op[1] = (~ALUOp[1]) | (~Func[2]);
  assign  Op[2] = ALUOp[0] | (ALUOp[1] & Func[1]);
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

module  ALU32Bit(Zero, CarryOut, Result, A, B, Op);
  input [2:0] Op;
  input [31:0] A, B;
  output [31:0] Result;
  reg [31:0] Result;
  output CarryOut, Zero;
  reg CarryOut;
  assign Zero = (({Result} == 0)) ? 1 : 0;
  always @ (Op, A, B) begin
    case(Op)
      0:  Result <= A & B;
      1:  Result <= A | B;
      2:  {CarryOut, Result[31:0]} <= A + B;
      6:  {CarryOut, Result[31:0]} <= A - B;
      7:  Result <= A < B ? 1 : 0;
      default: Result <= 0;
    endcase
  end
endmodule

module Data_Memory(Clock, MemRead, ReadAddress, ReadData, MemWrite, WriteAddress, WriteData);
	input MemRead, MemWrite, Clock;
	input [31:0] ReadAddress, WriteAddress;
	input [31:0] WriteData;
	output reg [31:0] ReadData;
	reg [31:0] memory [0:31];
	integer raddr, waddr;
	initial begin
	  memory[0] = 32'b00000000000000000000000000000000;  // nop
    memory[1] = 32'b00000000000000000000000001010100;  // Value of 84
    memory[2] = 32'b00000000000000000000000000001011;  // Value of 11
    memory[3] = 32'b00000000000000000000000000000000;  // nop
    memory[4] = 32'b00000000000000000000000000000000;  // nop
    memory[5] = 32'b00000000000000000000000000000000;  // nop
    memory[6] = 32'b00000000000000000000000000000000;  // nop
    memory[7] = 32'b00000000000000000000000000000000;  // nop
    memory[8] = 32'b00000000000000000000000000000000;  // nop
    memory[9] = 32'b00000000000000000000000000000000;  // nop
    memory[10]= 32'b00000000000000000000000000000000;  // nop
    memory[11]= 32'b00000000000000000000000000000000;  // nop
    memory[12]= 32'b00000000000000000000000000000000;  // nop
    memory[13]= 32'b00000000000000000000000000000000;  // nop
    memory[14]= 32'b00000000000000000000000000000000;  // nop
    memory[15]= 32'b00000000000000000000000000000000;  // nop
    memory[16]= 32'b00000000000000000000000000000000;  // nop
    memory[17]= 32'b00000000000000000000000000000000;  // nop
    memory[18]= 32'b00000000000000000000000000000000;  // nop
    memory[19]= 32'b00000000000000000000000000000000;  // nop
    memory[20]= 32'b00000000000000000000000000000000;  // nop
    memory[21]= 32'b00000000000000000000000000000000;  // nop
    memory[22]= 32'b00000000000000000000000000000000;  // nop
    memory[23]= 32'b00000000000000000000000000000000;  // nop
    memory[24]= 32'b00000000000000000000000000000000;  // nop
    memory[25]= 32'b00000000000000000000000000000000;  // nop
    memory[26]= 32'b00000000000000000000000000000000;  // nop
    memory[27]= 32'b00000000000000000000000000000000;  // nop
    memory[28]= 32'b00000000000000000000000000000000;  // nop
    memory[29]= 32'b00000000000000000000000000000000;  // nop
    memory[30]= 32'b00000000000000000000000000000000;  // nop
    memory[31]= 32'b00000000000000000000000000000000;  // nop  
  end
	always @(posedge Clock) begin
		raddr = ReadAddress;
		waddr = WriteAddress;
		if(MemRead)
			ReadData = memory[raddr/4];
		else if(MemWrite)
			memory[waddr/4] = WriteData;
	end
endmodule

module SCDataPath(ALUOutput, PCCurrent, PC, reset, clock);
  input clock, reset;
  input [31:0]  PC;
  output  [31:0]  ALUOutput, PCCurrent;
  wire  [31:0]  Instruction;
  wire  [31:0]  PCNew1, PCNew2;
  reg [31:0]  PCCurrent;
  wire  RegDst, Jump, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch;
  wire  [1:0] ALUOp;
  wire  [2:0] Op;
  wire  [4:0] MuxRegWriteAddress;
  wire  [31:0]  MuxALU2Src, MuxWriteDataSrc, MuxJumpOut, DataMemOut;
  wire  [31:0]  ReadData1, ReadData2, SignExtend, ShiftLeft, ShiftLeft2, AdderOut, JumpAddress, BranchAddress;
  wire  Zero, BranchDest, CarryOut, Carry1, Carry2;
  
  Instruction_Memory  unit01(Instruction, PC, clock);     //Read the instruction at positive edge of clock
  FADDER32  unit02(Carry1, PCNew1, PC, 32'h4, 0);         //PC = PC + 4
  Sign_Extender unit03(SignExtend, Instruction[15:0]);    //Sign Extend the Branch Offset
  Shift_Left  unit04(ShiftLeft, SignExtend);              //Shift left by 2 bits the Sign Extended Branch Offset
  Shift_Left  unit05(ShiftLeft2, Instruction[25:0]);      //Shift left by 2 bits the Jump Offset
  concatJuPC  unit06(JumpAddress, ShiftLeft2, PCNew1);    //Concat PC and Left Shifted Jump Offset 
  MainControlUnit unit07(RegDst, Jump, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp[0], ALUOp[1], Instruction[31:26]);  //Generate the Control Signals
  MUX5Bit_2To1  unit08(MuxRegWriteAddress, RegDst, Instruction[20:16], Instruction[15:11]);                                             //Selecting the writing register
  RegFile_32  unit09(ReadData1, ReadData2, clock, reset, 1'b0, Instruction[25:21], Instruction[20:16], MuxRegWriteAddress, MuxWriteDataSrc);  //Reading from the register file
  ALUControlUnit  unit10(Op, Instruction[5:0], ALUOp);    //Generating the ALU Control Signals
  Mux32Bit_2To1 unit11(MuxALU2Src, ALUSrc, ReadData2, SignExtend);              //Selecting the second ALU Source
  ALU32Bit  unit12(Zero, CarryOut, ALUOutput, ReadData1, MuxALU2Src, Op);       //Doing the ALU Operation
  FADDER32  unit13(Carry2, PCNew2, PCNew1, ShiftLeft, 0); //Generating the Branch Address
  and unit14(BranchDest, Branch, Zero);                   //Generating the signal whether to branch or not
  Mux32Bit_2To1 unit15(BranchAddress, BranchDest, PCNew1, PCNew2);              //Generating the new address after the branch MUX
  Mux32Bit_2To1 unit16(MuxJumpOut, Jump, BranchAddress, JumpAddress);           //Generating the new address after the Jump MUX
  Data_Memory unit17(clock, MemRead, ALUOutput, DataMemOut, MemWrite, ALUOutput, ReadData2);      //Operating on Data memory
  Mux32Bit_2To1 unit18(MuxWriteDataSrc, MemToReg, ALUOutput, DataMemOut);       //Writing back to register file
  RegFile_32  unit19(ReadData1, ReadData2, clock, reset, RegWrite, Instruction[25:21], Instruction[20:16], MuxRegWriteAddress, MuxWriteDataSrc);  //Writing to the register file
  initial begin
    PCCurrent = PC;
  end
  always @(negedge clock) begin
    PCCurrent = MuxJumpOut;
  end
endmodule

module TBSCDataPath;
  reg clock, reset;
  reg [31:0]  PC;
  wire  [31:0]  ALUOutput, PCCurrent;
  SCDataPath  SCDP(ALUOutput, PCCurrent, PC, reset, clock);
  initial begin
    $monitor($time, " :PC = %b, Reset = %b, Clock = %b, NextPC = %b, ALUOutput = %b.", PC, reset, clock, PCCurrent, ALUOutput);
    #0  clock = 1'b0; PC = 32'd20; reset = 1'b0;
    #15 reset = 1'b1;
    #10 PC = 32'd12;
    #40 PC = PCCurrent;
    #40 PC = PCCurrent;
    #50 $finish;
  end
  always  begin
    #10 clock = ~clock;
  end
endmodule
