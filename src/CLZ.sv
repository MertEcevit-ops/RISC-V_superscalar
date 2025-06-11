module CLZ (
    input logic [31:0] A,
    output logic [31:0] CLZ
);
    integer i;

    always_comb begin 
        CLZ = 0;
        for (i = 32; i>0; i--) begin
            if(A[i] == 0) begin
                CLZ = CLZ + 1;
            end else begin
                i = 0; // Break the loop when the first 1 is found
                break;
            end
        end
        
    end

endmodule
