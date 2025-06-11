////////////////////////////////////////////////////////////////////////////////
// DataMemory.sv
// Byte-addressable data memory (load/store unit)
////////////////////////////////////////////////////////////////////////////////
module DataMemory #(
    parameter MEM_SIZE  = 4096,
    parameter INIT_FILE = "data_mem.hex"
)(
    input  logic         clk,
    input  logic [31:0]  addr,
    input  logic [31:0]  write_data,
    input  logic         mem_read,
    input  logic         mem_write,
    output logic [31:0]  read_data
);
    // byte-addressable memory
    logic [7:0] mem [0:MEM_SIZE*4-1];

    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, mem);
    end

    // write port (byte-wise)
    always_ff @(posedge clk) begin
        if (mem_write) begin
            mem[addr]     <= write_data[7:0];
            mem[addr+1]   <= write_data[15:8];
            mem[addr+2]   <= write_data[23:16];
            mem[addr+3]   <= write_data[31:24];
        end
    end

    // read port (combinational)
    always_comb begin
        if (mem_read)
            read_data = { mem[addr+3], mem[addr+2], mem[addr+1], mem[addr] };
        else
            read_data = '0;
    end
endmodule