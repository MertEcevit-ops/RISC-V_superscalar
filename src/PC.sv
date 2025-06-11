////////////////////////////////////////////////////////////////////////////////
// PC.sv
// Program Counter with stall and branch support
////////////////////////////////////////////////////////////////////////////////
module PC (
    input  logic         clk,
    input  logic         reset,
    input  logic         stall,
    input  logic         branch_en,
    input  logic [31:0]  branch_target,
    output logic [31:0]  pc
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h0;
        else if (branch_en)
            pc <= branch_target;
        else if (!stall)
            pc <= pc + 8;  // two instructions per fetch
    end
endmodule