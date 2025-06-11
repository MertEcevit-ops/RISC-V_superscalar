module CommitUnit (
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic         valid_ex0_i,
    input  logic         valid_ex1_i,
    input  logic         complete_ex0_i,
    input  logic         complete_ex1_i,
    output logic         commit0_o,
    output logic         commit1_o
);
    always_comb begin
        commit0_o = valid_ex0_i & complete_ex0_i;
        commit1_o = valid_ex1_i & complete_ex1_i & commit0_o;
    end
endmodule
