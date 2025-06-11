module ForwardingUnit (
    input  logic [4:0] rs [1:0],
    input  logic [4:0] ex_rd [1:0],
    input  logic       ex_we [1:0],
    input  logic [4:0] wb_rd [1:0],
    input  logic       wb_we [1:0],
    output logic [1:0][1:0] fwd_sel // fwd_sel[slot][op] 00:regfile, 01:EX, 10:WB
);
    always_comb begin
        for (int s = 0; s < 2; s++) begin
            for (int op = 0; op < 2; op++) begin
                fwd_sel[s][op] = 2'b00; // Default: regfile
                if (ex_we[0] && ex_rd[0] == rs[op])
                    fwd_sel[s][op] = 2'b01;
                else if (wb_we[0] && wb_rd[0] == rs[op])
                    fwd_sel[s][op] = 2'b10;
            end
        end
    end
endmodule
