OBJS = CPU
B_OBJS = CPU
SRCS = *.v
#SRCS = CPU.v ALU.v ALU_Ctrl.v Adder.v Decoder.v Instr_Memory.v MUX_2to1.v ProgramCounter.v Reg_File.v Shift_Left_Two_32.v Sign_Extend.v Test_Bench.v
#B_SRCS = CPU.v ALU.v ALU_Ctrl.v Adder.v Decoder.v Instr_Memory.v MUX_2to1.v ProgramCounter.v Reg_File.v Shift_Left_Two_32.v Sign_Extend.v Test_Bench.v Unsign_Extend.v
CC   = iverilog

all: $(OBJS)

$(OBJS): $(SRCS)
	$(CC) -o $(OBJS) $(SRCS)
	@echo "\n*** File: CPU had been created ***"

bonus: $(B_SRCS)
	$(CC) -o $(B_OBJS) $(B_SRCS)
	@echo "\n*** File: Bonus_CPU had been created ***"

clean:
	rm -rf CPU wave.vcd CO_P2_Result.txt Bonus_CPU
	@echo "\n*** All temporary files have been cleaned!! ***"
