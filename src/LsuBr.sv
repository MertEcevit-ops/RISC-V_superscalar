////////////////////////////////////////////////////////////////////////////////
// LsuBr.sv — Load/Store + Branch Handling
////////////////////////////////////////////////////////////////////////////////
module LsuBr (
    input  logic [31:0] addr,
    input  logic [31:0] write_data,
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic        branch_en,
    input  logic [31:0] branch_pc,
    input  logic [31:0] rs1,
    input  logic [31:0] rs2,
    output logic        take_branch,
    output logic [31:0] read_data,
    output logic [31:0] mem_addr
);
    assign take_branch = branch_en && (rs1 == rs2); // Simple BEQ
    assign mem_addr = addr;
    // Memory access handled outside (with DataMemory)
    assign read_data = 32'd0;
endmodule