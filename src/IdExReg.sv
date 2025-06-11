module IdExReg (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] pc_in [1:0],
    input  logic [31:0] rs1_in [1:0],
    input  logic [31:0] rs2_in [1:0],
    input  logic [31:0] imm_in [1:0],
    input  logic [4:0]  rd_in  [1:0],
    input  logic [3:0]  alu_op_in [1:0],
    input  logic        is_mem_in [1:0],
    input  logic        is_store_in [1:0],
    output logic [31:0] pc_out [1:0],
    output logic [31:0] rs1_out [1:0],
    output logic [31:0] rs2_out [1:0],
    output logic [31:0] imm_out [1:0],
    output logic [4:0]  rd_out  [1:0],
    output logic [3:0]  alu_op_out [1:0],
    output logic        is_mem_out [1:0],
    output logic        is_store_out [1:0]
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            foreach (pc_out[i]) begin
                pc_out[i]       <= 32'b0;
                rs1_out[i]      <= 32'b0;
                rs2_out[i]      <= 32'b0;
                imm_out[i]      <= 32'b0;
                rd_out[i]       <= 5'b0;
                alu_op_out[i]   <= 4'b0;
                is_mem_out[i]   <= 1'b0;
                is_store_out[i] <= 1'b0;
            end
        end else if (!stall) begin
            foreach (pc_out[i]) begin
                pc_out[i]       <= pc_in[i];
                rs1_out[i]      <= rs1_in[i];
                rs2_out[i]      <= rs2_in[i];
                imm_out[i]      <= imm_in[i];
                rd_out[i]       <= rd_in[i];
                alu_op_out[i]   <= alu_op_in[i];
                is_mem_out[i]   <= is_mem_in[i];
                is_store_out[i] <= is_store_in[i];
            end
        end
    end
endmodule
