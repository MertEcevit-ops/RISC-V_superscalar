module SuperscalarController (
    input  logic        clk,
    input  logic        reset,

    input  logic [6:0]  op0,
    input  logic [2:0]  funct3_0,
    input  logic        funct7b5_0,
    input  logic        zero0, cout0, overflow0, sign0,

    input  logic [6:0]  op1,
    input  logic [2:0]  funct3_1,
    input  logic        funct7b5_1,
    input  logic        zero1, cout1, overflow1, sign1,

    output logic [2:0]  imm_src0,
    output logic [1:0]  alu_src_a0, alu_src_b0,
    output logic [1:0]  result_src0,
    output logic        adr_src0,
    output logic [3:0]  alu_control0,
    output logic        ir_write0, pc_write0,
    output logic        reg_write0, mem_write0,

    output logic [2:0]  imm_src1,
    output logic [1:0]  alu_src_a1, alu_src_b1,
    output logic [1:0]  result_src1,
    output logic        adr_src1,
    output logic [3:0]  alu_control1,
    output logic        ir_write1, pc_write1,
    output logic        reg_write1, mem_write1
);

    // === Lane 0 ===
    controller lane0_ctrl (
        .clk(clk), .reset(reset),
        .op(op0), .funct3(funct3_0), .funct7b5(funct7b5_0),
        .zero(zero0), .cout(cout0), .overflow(overflow0), .sign(sign0),
        .imm_src(imm_src0),
        .alu_src_a(alu_src_a0), .alu_src_b(alu_src_b0),
        .result_src(result_src0), .adr_src(adr_src0),
        .alu_control(alu_control0),
        .ir_write(ir_write0), .pc_write(pc_write0),
        .reg_write(reg_write0), .mem_write(mem_write0)
    );

    // === Lane 1 ===
    controller lane1_ctrl (
        .clk(clk), .reset(reset),
        .op(op1), .funct3(funct3_1), .funct7b5(funct7b5_1),
        .zero(zero1), .cout(cout1), .overflow(overflow1), .sign(sign1),
        .imm_src(imm_src1),
        .alu_src_a(alu_src_a1), .alu_src_b(alu_src_b1),
        .result_src(result_src1), .adr_src(adr_src1),
        .alu_control(alu_control1),
        .ir_write(ir_write1), .pc_write(pc_write1),
        .reg_write(reg_write1), .mem_write(mem_write1)
    );

endmodule
