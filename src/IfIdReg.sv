////////////////////////////////////////////////////////////////////////////////
// IfIdReg.sv
// IF→ID pipeline register, holds PC and two fetched instructions
////////////////////////////////////////////////////////////////////////////////
module IfIdReg (
    input  logic         clk,
    input  logic         reset,
    input  logic         stall,
    input  logic [31:0]  pc_in,
    input  logic [31:0]  instr0_in,
    input  logic [31:0]  instr1_in,
    output logic [31:0]  pc_out,
    output logic [31:0]  instr0_out,
    output logic [31:0]  instr1_out
);
    // default NOP: ADDI x0,x0,0 = 32'h00000013
    localparam NOP = 32'h00000013;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out     <= 32'h0;
            instr0_out <= NOP;
            instr1_out <= NOP;
        end else if (!stall) begin
            pc_out     <= pc_in;
            instr0_out <= instr0_in;
            instr1_out <= instr1_in;
        end
    end
endmodule