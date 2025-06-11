module BranchPredictor #(
    parameter SUPPORT_BRANCH_PREDICTION = 1,
    parameter NUM_BTB_ENTRIES  = 32,
    parameter NUM_BTB_ENTRIES_W = 5,
    parameter NUM_BHT_ENTRIES  = 512,
    parameter NUM_BHT_ENTRIES_W = 9,
    parameter RAS_ENABLE       = 1,
    parameter NUM_RAS_ENTRIES  = 8,
    parameter NUM_RAS_ENTRIES_W = 3
)(
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic         invalidate_i,

    // Branch resolution info (EX stage)
    input  logic         branch_request_i,
    input  logic         branch_is_taken_i,
    input  logic         branch_is_not_taken_i,
    input  logic [31:0]  branch_source_i,
    input  logic [31:0]  branch_pc_i,
    input  logic         branch_is_call_i,
    input  logic         branch_is_ret_i,
    input  logic         branch_is_jmp_i,

    // Fetch stage info
    input  logic [31:0]  pc_f_i,
    input  logic         pc_accept_i,

    // Predicted PC and info
    output logic [31:0]  next_pc_o,
    output logic         predicted_taken_o
);

    // === Branch History Table ===
    logic [1:0] bht_table [NUM_BHT_ENTRIES-1:0];
    logic [NUM_BHT_ENTRIES_W-1:0] bht_index;
    assign bht_index = pc_f_i[NUM_BHT_ENTRIES_W+1:2];
    logic [1:0] bht_value;

    always_ff @(posedge clk_i) begin
        if (rst_i || invalidate_i)
            for (int i = 0; i < NUM_BHT_ENTRIES; i++)
                bht_table[i] <= 2'b01; // weakly not taken
        else if (branch_request_i) begin
            if (branch_is_taken_i && bht_table[bht_index] != 2'b11)
                bht_table[bht_index] <= bht_table[bht_index] + 1;
            else if (branch_is_not_taken_i && bht_table[bht_index] != 2'b00)
                bht_table[bht_index] <= bht_table[bht_index] - 1;
        end
    end

    assign bht_value = bht_table[bht_index];
    assign predicted_taken_o = (bht_value[1] == 1'b1);

    // === Simple BTB (optional, direct-mapped) ===
    logic [31:0] btb_target [NUM_BTB_ENTRIES-1:0];
    logic [NUM_BTB_ENTRIES-1:0] btb_valid;
    logic [NUM_BTB_ENTRIES_W-1:0] btb_index;
    assign btb_index = pc_f_i[NUM_BTB_ENTRIES_W+1:2];

    always_ff @(posedge clk_i) begin
        if (rst_i || invalidate_i)
            btb_valid <= '0;
        else if (branch_request_i && branch_is_taken_i) begin
            btb_target[btb_index] <= branch_pc_i;
            btb_valid[btb_index]  <= 1'b1;
        end
    end

    // === RAS (Return Address Stack) ===
    logic [31:0] ras_stack [NUM_RAS_ENTRIES-1:0];
    logic [NUM_RAS_ENTRIES_W-1:0] ras_ptr;
    logic [31:0] ras_top;

    always_ff @(posedge clk_i) begin
        if (rst_i)
            ras_ptr <= 0;
        else if (branch_request_i) begin
            if (branch_is_call_i) begin
                ras_stack[ras_ptr] <= branch_pc_i;
                ras_ptr <= ras_ptr + 1;
            end
            else if (branch_is_ret_i) begin
                ras_ptr <= ras_ptr - 1;
            end
        end
    end

    assign ras_top = ras_stack[ras_ptr - 1];

    // === Final next PC decision ===
    always_comb begin
        if (btb_valid[btb_index]) begin
            if (RAS_ENABLE && branch_is_ret_i)
                next_pc_o = ras_top;
            else
                next_pc_o = btb_target[btb_index];
        end else begin
            next_pc_o = pc_f_i + 4;
        end
    end

endmodule
