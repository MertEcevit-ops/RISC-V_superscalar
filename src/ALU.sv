////////////////////////////////////////////////////////////////////////////////
// ALU.sv (stub) — detailed version should be your existing uploaded ALU
////////////////////////////////////////////////////////////////////////////////
module ALU (
    input  logic [3:0]  op,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);
    always_comb begin
        case (op)
            4'b0000: y = a + b;
            4'b0001: y = a - b;
            4'b0010: y = a & b;
            4'b0011: y = a | b;
            4'b0100: y = a ^ b;
            4'b0101: y = a << b[4:0];
            4'b0110: y = a >> b[4:0];
            4'b0111: y = $signed(a) >>> b[4:0];
            default: y = 32'hdeadbeef;
        endcase
    end
endmodule