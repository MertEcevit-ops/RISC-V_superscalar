////////////////////////////////////////////////////////////////////////////////
// FetchStage.sv
// IF stage: PC update + dual fetch
////////////////////////////////////////////////////////////////////////////////
module FetchStage (
    input  logic         clk,
    input  logic         reset,
    input  logic         stall,
    input  logic         branch_en,
    input  logic [31:0]  branch_target,
    output logic [31:0]  pc_out,
    output logic [31:0]  instr0,
    output logic [31:0]  instr1
);
    logic [31:0] pc_reg;

    // program counter
    PC pc0 (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .branch_en(branch_en),
        .branch_target(branch_target),
        .pc(pc_reg)
    );

    // instruction memory
    InstMemory imem (
        .clk(clk),
        .addr(pc_reg),
        .instr0(instr0),
        .instr1(instr1)
    );

    assign pc_out = pc_reg;
endmodule