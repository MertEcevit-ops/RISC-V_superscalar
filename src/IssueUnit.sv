module IssueUnit (
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic         fetch0_valid_i,
    input  logic         fetch1_valid_i,
    input  logic [31:0]  fetch0_instr_i,
    input  logic [31:0]  fetch1_instr_i,
    input  logic [31:0]  fetch0_pc_i,
    input  logic [31:0]  fetch1_pc_i,
    output logic         issue0_valid_o,
    output logic         issue1_valid_o
    // ... other signals for op type, rd, rs1, rs2, etc.
);

    biriscv_issue issue_core (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .fetch0_valid_i(fetch0_valid_i),
        .fetch0_instr_i(fetch0_instr_i),
        .fetch0_pc_i(fetch0_pc_i),
        .fetch1_valid_i(fetch1_valid_i),
        .fetch1_instr_i(fetch1_instr_i),
        .fetch1_pc_i(fetch1_pc_i),
        // map all other signals
        .issue0_valid_o(issue0_valid_o),
        .issue1_valid_o(issue1_valid_o)
    );

endmodule
