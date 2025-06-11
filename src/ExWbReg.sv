////////////////////////////////////////////////////////////////////////////////
// ExWbReg.sv
// EX→WB pipeline register
////////////////////////////////////////////////////////////////////////////////
module ExWbReg (
    input  logic         clk,
    input  logic         reset,
    input  logic         stall,
    input  logic [4:0]   rd0_in,
    input  logic [4:0]   rd1_in,
    input  logic [31:0]  res0_in,
    input  logic [31:0]  res1_in,
    output logic [4:0]   rd0_out,
    output logic [4:0]   rd1_out,
    output logic [31:0]  res0_out,
    output logic [31:0]  res1_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rd0_out <= 0; rd1_out <= 0;
            res0_out <= 0; res1_out <= 0;
        end else if (!stall) begin
            rd0_out <= rd0_in;
            rd1_out <= rd1_in;
            res0_out <= res0_in;
            res1_out <= res1_in;
        end
    end
endmodule