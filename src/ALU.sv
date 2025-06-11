module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  alu_control,
    input  logic        add_sub_mode,   // 0: add, 1: sub
    output logic [31:0] alu_result,
    output logic        zero,
    output logic        greater,
    output logic        less,
    output logic        u_greater,
    output logic        u_less
);

    logic [31:0] addersub_result, and_result, or_result, xor_result;
    logic [31:0] sll_result, srl_result, sra_result;
    logic [31:0] CTZ_result, CLZ_result, CPOP_result;

    // Arithmetic and logic operations
    addersub addsub_inst (
        .A(A), .B(B),
        .Mode(add_sub_mode),
        .Result(addersub_result),
        .Cout()
    );

    AND and_gate (.A(A), .B(B), .Result(and_result));
    OR  or_gate  (.A(A), .B(B), .Result(or_result));
    XOR xor_gate (.A(A), .B(B), .Result(xor_result));

    logical_left  sll_gate (.A(A), .B(B), .Result(sll_result));
    logical_right srl_gate (.A(A), .B(B), .Result(srl_result));
    arithmetic_right sra_gate (.A(A), .B(B), .Result(sra_result));

    // Comparisons
    equal eq_gate (
        .A(A), .B(B),
        .branch_equal(zero)
    );

    comp comp_gate (
        .A(A), .B(B),
        .branch_less(u_less),
        .branch_greater(u_greater)
    );

    comp_sign comp_signed_gate (
        .A(A), .B(B),
        .branch_less(less),
        .branch_greater(greater)
    );

    // Bit population and counting
    CTZ ctz_gate (.A(A), .CTZ(CTZ_result));
    CLZ clz_gate (.A(A), .CLZ(CLZ_result));
    CPOP cpop_gate (.A(A), .CPOP(CPOP_result));

    // ALU operation select
    always_comb begin
        unique case (alu_control)
            4'b0000: alu_result = addersub_result; // ADD
            4'b0001: alu_result = addersub_result; // SUB
            4'b0010: alu_result = and_result;      // AND
            4'b0011: alu_result = or_result;       // OR
            4'b0100: alu_result = xor_result;      // XOR
            4'b0101: alu_result = sll_result;      // SLL
            4'b0110: alu_result = srl_result;      // SRL
            4'b0111: alu_result = sra_result;      // SRA
            4'b1010: alu_result = CTZ_result;      // CTZ (Count Trailing Zeros)
            4'b1011: alu_result = CLZ_result;      // CLZ (Count Leading Zeros)
            4'b1100: alu_result = CPOP_result;     // CPOP (Popcount)
            default: alu_result = 32'h00000000;
        endcase
    end

endmodule
