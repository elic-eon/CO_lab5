//Subject:     CO project 3 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0116055 Huang Szuyi
//----------------------------------------------
//Date:        12.02.13
//----------------------------------------------
//Description: CPU
//--------------------------------------------------------------------------------
module CPU(
    clk_i,
		rst_i
		);

//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] next_instr;
wire [32-1:0] pc_out;
wire [32-1:0] instr_addr_4;
wire [32-1:0] instr;
wire [28-1:0] Jump_Addr_28;


wire  [2-1:0] RegDst_control;
wire          SignedCtrl;
wire          RegWrite_control;
wire          ALUSrc_control;
wire  [3-1:0] ALU_op_control;
wire          MemWrite_control;
wire          MemRead_control;
wire          Jump_control;
wire  [2-1:0] MemToReg_control;
wire          Branch_control;
wire  [2-1:0] BranchType_control;

wire  [5-1:0] RDaddr;
wire [32-1:0] WriteData;
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;

wire [32-1:0] Extend;
wire  [4-1:0] ALU_ctrl;
wire [32-1:0] Shift_2_32_bit;
wire [32-1:0] instr_addr_branch;
wire [32-1:0] ALU_src2;
wire          ALU_zero;
wire [32-1:0] ALU_result;
wire          not_ALU_zero;
wire          not_ALU_result;
wire          nor_zero_result;
wire          BranchType;
wire          ALU_jr;

wire          Branch;
wire [32-1:0] instr_addr_w;
wire [32-1:0] DataMem;



//Greate componentes
PC PC(
      .clk_i(clk_i),
	    .rst_i (rst_i),
	    .pc_in_i(next_instr),
	    .pc_out_o(pc_out)
	    );

Adder NextInstr(
      .src1_i(pc_out),
	    .src2_i(32'd4),
	    .sum_o(instr_addr_4)
	    );

Instruction_Memory IM(
      .addr_i(pc_out),
	    .instr_o(instr)
	    );

//Stage 1 end
Shift_Left_Two_26_to_28 jump26(
      .data_i(instr[25:0]),
      .data_o(Jump_Addr_28)
);

Decoder Controller(
      .instr_op_i(instr[31:26]),
	    .RegDst_o(RegDst_control),
      .SignedCtrl_o(SignedCtrl),
	    .RegWrite_o(RegWrite_control),
	    .ALUSrc_o(ALUSrc_control),
	    .ALU_op_o(ALU_op_control),
      .MemWrite_o(MemWrite_control),
      .MemRead_o(MemRead_control),
      .Jump_o(Jump_control),
      .MemToReg_o(MemToReg_control),
  		.Branch_o(Branch_control),
      .BranchType_o(BranchType_control)
	    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
      .data0_i(instr[20:16]),
      .data1_i(instr[15:11]),
      .data2_i(5'd31),
      .select_i(RegDst_control),
      .data_o(RDaddr)
      );

Reg_File Registers(
      .clk_i(clk_i),
	    .rst_i(rst_i),
      .RSaddr_i(instr[25:21]),
      .RTaddr_i(instr[20:16]),
      .RDaddr_i(RDaddr),
      .RDdata_i(WriteData),
      .RegWrite_i(RegWrite_control),
      .RSdata_o(RSdata),
      .RTdata_o(RTdata)
      );

Extend Extender(
      .data_i(instr[15:0]),
      .SignedCtrl_i(SignedCtrl),
      .data_o(Extend)
      );

ALU_Ctrl AC(
      .funct_i(instr[5:0]),
      .ALUOp_i(ALU_op_control),
      .jr_o(ALU_jr),
      .ALUCtrl_o(ALU_ctrl)
      );

// Stage 2 end

Shift_Left_Two_32 Shifter(
      .data_i(Extend),
      .data_o(Shift_2_32_bit)
      );

Adder BranchAddress(
      .src1_i(instr_addr_4),
      .src2_i(Shift_2_32_bit),
      .sum_o(instr_addr_branch)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
      .data0_i(RTdata),
      .data1_i(Extend),
      .select_i(ALUSrc_control),
      .data_o(ALU_src2)
      );

ALU ALU(
      .src1_i(RSdata),
	    .src2_i(ALU_src2),
	    .ctrl_i(ALU_ctrl),
	    .result_o(ALU_result),
  		.zero_o(ALU_zero)
	    );

// stage 3 end

not(not_ALU_zero, ALU_zero);
not(not_ALU_result, ALU_result[31]);
nor(nor_zero_result, ALU_zero, ALU_result[31]);

MUX_4to1 #(.size(1)) MUX_BranchType(
      .data0_i(ALU_zero),
      .data1_i(nor_zero_result),
      .data2_i(not_ALU_result),
      .data3_i(not_ALU_zero),
      .select_i(BranchType_control),
      .data_o(BranchType)
);

and(Branch, BranchType, Branch_control);

MUX_2to1 #(.size(32)) BranchSel(
      .data0_i(instr_addr_4),
      .data1_i(instr_addr_branch),
      .select_i(Branch),
      .data_o(instr_addr_w)
);

MUX_3to1 #(.size(32)) JumpSel(
      .data0_i(instr_addr_w),
      .data1_i({instr_addr_4[31:28], Jump_Addr_28[27:0]}),
      .data2_i(RSdata),
      .select_i({ALU_jr, Jump_control}),
      .data_o(next_instr)
);

Data_Memory DM(
      .clk_i(clk_i),
      .addr_i(ALU_result),
      .data_i(RTdata),
      .MemWrite_i(MemWrite_control),
      .MemRead_i(MemRead_control),
      .data_o(DataMem)
);

MUX_4to1 #(.size(32)) MUX_WriteData(
      .data0_i(ALU_result),
      .data1_i(DataMem),
      .data2_i(Extend),
      .data3_i(instr_addr_4),
      .select_i(MemToReg_control),
      .data_o(WriteData)
);

endmodule



