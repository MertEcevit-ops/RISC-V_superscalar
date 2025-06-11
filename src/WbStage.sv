////////////////////////////////////////////////////////////////////////////////
// WbStage.sv
// WB stage: write results back to register file
////////////////////////////////////////////////////////////////////////////////
module WbStage (
    input  logic         clk,
    input  logic         we0,
    input  logic         we1,
    input  logic [4:0]   rd0,
    input  logic [4:0]   rd1,
    input  logic [31:0]  res0,
    input  logic [31:0]  res1,
    output logic         rf_we0,
    output logic         rf_we1,
    output logic [4:0]   rf_waddr0,
    output logic [4:0]   rf_waddr1,
    output logic [31:0]  rf_wdata0,
    output logic [31:0]  rf_wdata1
);
    assign rf_we0    = we0;
    assign rf_we1    = we1;
    assign rf_waddr0 = rd0;
    assign rf_waddr1 = rd1;
    assign rf_wdata0 = res0;
    assign rf_wdata1 = res1;
endmodule