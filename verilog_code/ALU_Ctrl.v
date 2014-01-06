//Subject:     CO project 3 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     2
//--------------------------------------------------------------------------------
//Writer:      0116055 Huang Szuyi
//----------------------------------------------
//Date:        12.01.13
//----------------------------------------------
//Description: ALU_Controler
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          jr_o,
          ALUCtrl_o
          );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
output             jr_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg                jr_o;

//Parameter
parameter  R_type   = 3'b010;
parameter  BEQ      = 3'b001;
parameter  ADDi     = 3'b100;
parameter  SLTi     = 3'b101;
parameter  LWSW     = 3'b000;
parameter  BEZ      = 3'b110;

parameter  ADD      = 6'b100000;
parameter  SUB      = 6'b100010;
parameter  AND      = 6'b100100;
parameter  OR       = 6'b100101;
parameter  SLT      = 6'b101010;
parameter  MUL      = 6'b011000;
parameter  JR       = 6'b001000;

parameter  ALU_AND  = 4'b0000;
parameter  ALU_OR   = 4'b0001;
parameter  ALU_ADD  = 4'b0010;
parameter  ALU_SUB  = 4'b0110;
parameter  ALU_MUL  = 4'b0011;
parameter  ALU_NOR  = 4'b1100;
parameter  ALU_NAND = 4'b1101;
parameter  ALU_SLT  = 4'b0111;
parameter  ALU_LI   = 4'b0100;

//Select exact operation

always @(funct_i, ALUOp_i) begin
  case (ALUOp_i)
    BEQ:      ALUCtrl_o = ALU_SUB;
    ADDi:     ALUCtrl_o = ALU_ADD;
    SLTi:     ALUCtrl_o = ALU_SLT;
    LWSW:     ALUCtrl_o = ALU_ADD;
    BEZ:      ALUCtrl_o = ALU_LI;
    R_type: begin
      case (funct_i)
        ADD:  ALUCtrl_o = ALU_ADD;
        SUB:  ALUCtrl_o = ALU_SUB;
        AND:  ALUCtrl_o = ALU_AND;
        OR:   ALUCtrl_o = ALU_OR;
        SLT:  ALUCtrl_o = ALU_SLT;
        MUL:  ALUCtrl_o = ALU_MUL;
        JR:   ALUCtrl_o = ALU_AND;
        default: ALUCtrl_o = 4'bxxxx;
      endcase
    end
    default:  ALUCtrl_o = 4'bxxxx;
  endcase
end

always @(*) begin
  if (funct_i == JR && ALUOp_i == R_type)
    jr_o = 1;
  else
    jr_o = 0;
end

endmodule
