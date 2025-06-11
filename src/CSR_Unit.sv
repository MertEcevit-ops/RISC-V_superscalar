module CSR_Unit (
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic         csr_valid_i,
    input  logic [11:0]  csr_addr_i,
    input  logic [31:0]  csr_wdata_i,
    input  logic [2:0]   csr_cmd_i,   // CSRRS/CSRRW/CSRRC
    output logic [31:0]  csr_rdata_o
);
    // Internal wires
    logic [31:0] csr_rdata;

    biriscv_csr_regfile csr_regfile (
        .clk_i     (clk_i),
        .rst_i     (rst_i),
        .csr_we_i  (csr_valid_i),
        .csr_addr_i(csr_addr_i),
        .csr_wdata_i(csr_wdata_i),
        .csr_cmd_i (csr_cmd_i),
        .csr_rdata_o(csr_rdata)
    );

    assign csr_rdata_o = csr_rdata;
endmodule
