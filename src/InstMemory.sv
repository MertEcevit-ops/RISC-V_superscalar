module InstMemory #(
    parameter ADDR_WIDTH = 10,
    parameter MEM_DEPTH  = 1 << ADDR_WIDTH
) (
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [31:0]          instr0,
    output logic [31:0]          instr1
);
    // Instruction memory array
    logic [31:0] mem [0:MEM_DEPTH-1];

    initial begin
        // Initialize from hex file; replace with your file name
        $readmemh("inst_mem.hex", mem);
    end

    // Asynchronous dual-instruction read
    assign instr0 = mem[addr];
    assign instr1 = mem[addr + 1];
endmodule
