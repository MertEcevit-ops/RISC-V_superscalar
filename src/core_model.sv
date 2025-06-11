module core_model
  import riscv_pkg::*;
#(
    parameter string DMemInitFile  = "dmem.mem",
    parameter string IMemInitFile  = "imem.mem",
    parameter string TableFile     = "table.log",
    parameter int    IssueWidth    = 2
)(
    input  logic             clk_i,
    input  logic             rstn_i,
    input  logic  [XLEN-1:0] addr_i,
    output logic  [XLEN-1:0] data_o,
    output logic             update_o    [IssueWidth],
    output logic  [XLEN-1:0] pc_o        [IssueWidth],
    output logic  [XLEN-1:0] instr_o     [IssueWidth],
    output logic  [4:0]      reg_addr_o  [IssueWidth],
    output logic  [XLEN-1:0] reg_data_o  [IssueWidth],
    output logic  [XLEN-1:0] mem_addr_o  [IssueWidth],
    output logic  [XLEN-1:0] mem_data_o  [IssueWidth],
    output logic             mem_wrt_o   [IssueWidth]
);

  // === Internal wires ===
  logic [XLEN-1:0] pc_if;
  logic [XLEN-1:0] instr_if   [IssueWidth];
  logic [XLEN-1:0] pc_id      [IssueWidth];
  logic [XLEN-1:0] instr_id   [IssueWidth];

  logic [4:0]      rd_wb      [IssueWidth];
  logic [XLEN-1:0] data_wb    [IssueWidth];
  logic            rf_we      [IssueWidth];

  logic [XLEN-1:0] dmem_rdata;
  logic [XLEN-1:0] dmem_addr  [IssueWidth];
  logic [XLEN-1:0] dmem_wdata [IssueWidth];
  logic            dmem_wen   [IssueWidth];

  // === Instruction Memory ===
  InstMemory #(
    .INIT_FILE(IMemInitFile)
  ) imem (
    .addr(pc_if),
    .instr0(instr_if[0]),
    .instr1(instr_if[1])
  );

  // === Data Memory ===
  DataMemory #(
    .INIT_FILE(DMemInitFile)
  ) dmem (
    .clk(clk_i),
    .addr0(dmem_addr[0]), .wdata0(dmem_wdata[0]), .wen0(dmem_wen[0]),
    .addr1(dmem_addr[1]), .wdata1(dmem_wdata[1]), .wen1(dmem_wen[1]),
    .rdata(dmem_rdata)
  );

  // === Program Counter ===
  PC pc_module (
    .clk(clk_i),
    .rstn(rstn_i),
    .pc_out(pc_if)
  );

  // === Register File ===
  RegFile regfile (
    .clk(clk_i),
    .we0(rf_we[0]),
    .we1(rf_we[1]),
    .waddr0(rd_wb[0]),
    .waddr1(rd_wb[1]),
    .wdata0(data_wb[0]),
    .wdata1(data_wb[1]),
    .raddr(addr_i),
    .rdata(data_o)
  );

  // === Fetch Stage ===
  FetchStage fetch_stage (
    .clk(clk_i),
    .reset(~rstn_i),
    .pc_in(pc_if),
    .instr0_out(instr_id[0]),
    .instr1_out(instr_id[1]),
    .pc0_out(pc_id[0]),
    .pc1_out(pc_id[1])
  );

  // === ID, EX, WB and other stages ===
  // You would instantiate:
  // - DecodeStage
  // - IdExReg
  // - ExStage (ALU + LSU + Branch)
  // - ExWbReg
  // - WbStage
  // - Scoreboard
  // - ForwardingUnit
  // - ControlUnit / IssueUnit

  // === Retirement Outputs ===
  assign pc_o[0]        = pc_id[0];
  assign instr_o[0]     = instr_id[0];
  assign reg_addr_o[0]  = rd_wb[0];
  assign reg_data_o[0]  = data_wb[0];
  assign mem_addr_o[0]  = dmem_addr[0];
  assign mem_data_o[0]  = dmem_wdata[0];
  assign mem_wrt_o[0]   = dmem_wen[0];
  assign update_o[0]    = rf_we[0];

  assign pc_o[1]        = pc_id[1];
  assign instr_o[1]     = instr_id[1];
  assign reg_addr_o[1]  = rd_wb[1];
  assign reg_data_o[1]  = data_wb[1];
  assign mem_addr_o[1]  = dmem_addr[1];
  assign mem_data_o[1]  = dmem_wdata[1];
  assign mem_wrt_o[1]   = dmem_wen[1];
  assign update_o[1]    = rf_we[1];

endmodule
