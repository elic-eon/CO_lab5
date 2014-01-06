//Subject:     CO project 3 - extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0116055 Huang Szuyi
//----------------------------------------------
//Date:        12.01.13
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module Extend(
    data_i,
    SignedCtrl_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
input            SignedCtrl_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(*) begin
  if (data_i[15] == 0 || SignedCtrl_i == 0) begin
    data_o [31:16] <= 16'b0000000000000000;
    data_o  [15:0] <= data_i;
  end
  else begin
    data_o [31:16] <= 16'b1111111111111111;
    data_o  [15:0] <= data_i;
  end
end

endmodule

