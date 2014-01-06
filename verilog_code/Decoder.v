//Subject:     CO project 3 - Decoder
//--------------------------------------------------------------------------------
//Version:     2
//--------------------------------------------------------------------------------
//Writer:      0116055 Huang Szuyi
//----------------------------------------------
//Date:        12.02.13
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module Decoder(
  instr_op_i,
  RegDst_o,
  SignedCtrl_o,
  RegWrite_o,
  ALUSrc_o,
  ALU_op_o,
  MemWrite_o,
  MemRead_o,
  Jump_o,
  MemToReg_o,
  Branch_o,
  BranchType_o
	);

//I/O ports
input  [6-1:0] instr_op_i;

output [2-1:0] RegDst_o;
output         SignedCtrl_o;
output         RegWrite_o;
output         ALUSrc_o;
output [3-1:0] ALU_op_o;
output         MemWrite_o;
output         MemRead_o;
output         Jump_o;
output [2-1:0] MemToReg_o;
output         Branch_o;
output [2-1:0] BranchType_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg    [2-1:0] MemToReg_o;
reg    [2-1:0] BranchType_o;

reg            R_format;
reg            beq;
reg            addi;
reg            slti;
reg            lw;
reg            sw;
reg            jump;
reg            jal;
reg            bgt;
reg            bnez;
reg            bgez;

//Parameter
parameter      R_type      = 6'b000000;
parameter      BEQ         = 6'b000100;
parameter      ADDi        = 6'b001000;
parameter      SLTi        = 6'b001010;
parameter      LW          = 6'b100011;
parameter      SW          = 6'b101011;
parameter      JUMP        = 6'b000010;
parameter      JAL         = 6'b000011;
parameter      BGT         = 6'b000111;
parameter      BNEZ        = 6'b000101;
parameter      BGEZ        = 6'b000001;

//Main function
always @(*) begin
  R_format = (instr_op_i == R_type) ? 1 : 0;
  beq      = (instr_op_i == BEQ)    ? 1 : 0;
  addi     = (instr_op_i == ADDi)   ? 1 : 0;
  slti     = (instr_op_i == SLTi)   ? 1 : 0;
  lw       = (instr_op_i == LW)     ? 1 : 0;
  sw       = (instr_op_i == SW)     ? 1 : 0;
  jump     = (instr_op_i == JUMP)   ? 1 : 0;
  jal      = (instr_op_i == JAL)    ? 1 : 0;
  bgt      = (instr_op_i == BGT)    ? 1 : 0;
  bnez     = (instr_op_i == BNEZ)   ? 1 : 0;
  bgez     = (instr_op_i == BGEZ)   ? 1 : 0;
end

assign RegDst_o[0]   = R_format;
assign RegDst_o[1]   = jal;
assign SignedCtrl_o  = 1'b1;
assign RegWrite_o    = R_format | lw | addi | slti | jal;
assign ALUSrc_o      = lw | sw | addi | slti;
assign MemWrite_o    = sw;
assign MemRead_o     = lw;
assign Jump_o        = jump | jal;
assign Branch_o      = beq | bgt | bnez | bgez;

always @(*) begin
  case(instr_op_i)
    R_type:  ALU_op_o = 3'b010;
    BEQ:     ALU_op_o = 3'b001;
    ADDi:    ALU_op_o = 3'b100;
    SLTi:    ALU_op_o = 3'b101;
    LW:      ALU_op_o = 3'b000;
    SW:      ALU_op_o = 3'b000;
    BGT:     ALU_op_o = 3'b001;
    BNEZ:    ALU_op_o = 3'b110;
    BGEZ:    ALU_op_o = 3'b110;
    default: ALU_op_o = 3'bxxx;
  endcase
end

always @(*) begin
  case(instr_op_i)
    R_type:  MemToReg_o = 2'b00;
    ADDi:    MemToReg_o = 2'b00;
    SLTi:    MemToReg_o = 2'b00;
    LW:      MemToReg_o = 2'b01;
    JAL:     MemToReg_o = 2'b11;
    default: MemToReg_o = 2'bxx;
  endcase
end

always @(*) begin
  case(instr_op_i)
    BEQ:     BranchType_o = 2'b00;
    BGT:     BranchType_o = 2'b01;
    BNEZ:    BranchType_o = 2'b11;
    BGEZ:    BranchType_o = 2'b10;
    default: BranchType_o = 2'bxx;
  endcase
end

endmodule
