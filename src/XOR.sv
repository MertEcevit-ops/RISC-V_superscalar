module XOR (
    input logic [31:0] A,B,
    output logic [31:0] Result
);

genvar i;
generate
    for (i = 0; i<32; i++) begin
        assign Result[i] = A[i] ^ B[i];
    end
endgenerate
    
endmodule
