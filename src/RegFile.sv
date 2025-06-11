////////////////////////////////////////////////////////////////////////////////
// RegFile.sv
// 32×32b register file, 2 read ports + 2 write ports
////////////////////////////////////////////////////////////////////////////////
module RegFile (
    input  logic         clk,
    input  logic         we0,
    input  logic         we1,
    input  logic [4:0]   waddr0,
    input  logic [4:0]   waddr1,
    input  logic [31:0]  wdata0,
    input  logic [31:0]  wdata1,
    input  logic [4:0]   raddr0,
    input  logic [4:0]   raddr1,
    output logic [31:0]  rdata0,
    output logic [31:0]  rdata1
);
    logic [31:0] regs [0:31];
    integer i;

    // initialize registers to zero
    initial for (i = 0; i < 32; i++) regs[i] = 32'h0;

    // write ports (waddr0 has priority)
    always_ff @(posedge clk) begin
        if (we0 && waddr0 != 5'd0)
            regs[waddr0] <= wdata0;
        if (we1 && waddr1 != 5'd0)
            regs[waddr1] <= wdata1;
    end

    // read ports (x0 always reads as zero)
    always_comb begin
        rdata0 = (raddr0 == 5'd0) ? 32'h0 : regs[raddr0];
        rdata1 = (raddr1 == 5'd0) ? 32'h0 : regs[raddr1];
    end
endmodule