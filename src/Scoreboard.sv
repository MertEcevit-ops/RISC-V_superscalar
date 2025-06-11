module Scoreboard (
    input  logic        clk,
    input  logic        reset,
    input  logic        writeback_en [1:0],
    input  logic [4:0]  writeback_rd [1:0],
    input  logic        issue_valid [1:0],
    input  logic [4:0]  issue_rs1 [1:0],
    input  logic [4:0]  issue_rs2 [1:0],
    input  logic [4:0]  issue_rd  [1:0],
    output logic        hazard_detected [1:0]
);
    logic [31:0] busy;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            busy <= 0;
        else begin
            for (int i = 0; i < 2; i++) begin
                if (writeback_en[i])
                    busy[writeback_rd[i]] <= 1'b0;
                if (issue_valid[i] && issue_rd[i] != 0)
                    busy[issue_rd[i]] <= 1'b1;
            end
        end
    end

    always_comb begin
        for (int i = 0; i < 2; i++) begin
            hazard_detected[i] = 1'b0;
            if (busy[issue_rs1[i]] || busy[issue_rs2[i]])
                hazard_detected[i] = 1'b1;
        end
    end
endmodule
