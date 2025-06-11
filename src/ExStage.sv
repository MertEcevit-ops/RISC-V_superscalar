////////////////////////////////////////////////////////////////////////////////
// ExStage.sv
// EX stage: routes to ALU or LSU depending on instruction type
////////////////////////////////////////////////////////////////////////////////
module ExStage (
    input  logic [31:0] pc,
    input  logic [31:0] rs1_val,
    input  logic [31:0] rs2_val,
    input  logic [31:0] imm,
    input  logic [3:0]  alu_op,
    input  logic        is_mem,
    input  logic        is_store,
    output logic [31:0] alu_result,
    output logic [31:0] store_data,
    output logic [31:0] mem_addr
);
    logic [31:0] alu_out;

    // ALU result
    ALU alu0 (
        .op(alu_op),
        .a(rs1_val),
        .b(imm),
        .y(alu_out)
    );

    assign alu_result = alu_out;
    assign mem_addr   = alu_out;
    assign store_data = rs2_val;
endmodule