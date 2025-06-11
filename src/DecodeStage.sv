////////////////////////////////////////////////////////////////////////////////
// DecodeStage.sv
// Decodes two instructions: splits fields and generates immediates + control
////////////////////////////////////////////////////////////////////////////////
module DecodeStage (
    input  logic [31:0]  instr0,
    input  logic [31:0]  instr1,
    input  logic [31:0]  pc_in,

    // decoded outputs for slot 0
    output logic [4:0]   rd0,
    output logic [4:0]   rs10,
    output logic [4:0]   rs20,
    output logic [31:0]  imm0,
    output logic         is_load0,
    output logic         is_store0,
    output logic         is_branch0,
    output logic         is_jal0,
    output logic         is_jalr0,
    output logic [3:0]   alu_op0,

    // decoded outputs for slot 1
    output logic [4:0]   rd1,
    output logic [4:0]   rs11,
    output logic [4:0]   rs21,
    output logic [31:0]  imm1,
    output logic         is_load1,
    output logic         is_store1,
    output logic         is_branch1,
    output logic         is_jal1,
    output logic         is_jalr1,
    output logic [3:0]   alu_op1
);
    // split fields
    logic [6:0] opcode0, opcode1;
    logic [2:0] funct3_0, funct3_1;
    logic [6:0] funct7_0, funct7_1;

    assign opcode0  = instr0[6:0];
    assign opcode1  = instr1[6:0];
    assign funct3_0 = instr0[14:12];
    assign funct3_1 = instr1[14:12];
    assign funct7_0 = instr0[31:25];
    assign funct7_1 = instr1[31:25];

    assign rd0   = instr0[11:7];
    assign rd1   = instr1[11:7];
    assign rs10  = instr0[19:15];
    assign rs11  = instr1[19:15];
    assign rs20  = instr0[24:20];
    assign rs21  = instr1[24:20];

    // default control
    always_comb begin
        is_load0   = 0; is_store0  = 0; is_branch0 = 0;
        is_jal0    = 0; is_jalr0   = 0;
        alu_op0    = 4'd0;
        imm0       = 32'd0;

        unique case (opcode0)
            7'b0000011: begin // LOAD
                is_load0 = 1;
                imm0 = $signed(instr0[31:20]);
            end
            7'b0100011: begin // STORE
                is_store0 = 1;
                imm0 = $signed({instr0[31:25], instr0[11:7]});
            end
            7'b0010011: begin // ALU-IMM
                alu_op0 = funct3_0;
                imm0    = $signed(instr0[31:20]);
            end
            7'b0110011: begin // ALU-REG
                alu_op0 = {funct7_0[5], funct3_0};
            end
            7'b1100011: begin // BRANCH
                is_branch0 = 1;
                imm0 = $signed({instr0[31], instr0[7], instr0[30:25], instr0[11:8], 1'b0});
            end
            7'b1101111: begin // JAL
                is_jal0 = 1;
                imm0 = $signed({instr0[31], instr0[19:12], instr0[20], instr0[30:21], 1'b0});
            end
            7'b1100111: begin // JALR
                is_jalr0 = 1;
                alu_op0 = funct3_0;
                imm0 = $signed(instr0[31:20]);
            end
            default: ;
        endcase
    end

    // slot 1 decode (similar to slot 0)
    always_comb begin
        is_load1   = 0; is_store1  = 0; is_branch1 = 0;
        is_jal1    = 0; is_jalr1   = 0;
        alu_op1    = 4'd0;
        imm1       = 32'd0;

        unique case (opcode1)
            7'b0000011: begin is_load1 = 1; imm1 = $signed(instr1[31:20]); end
            7'b0100011: begin is_store1=1; imm1 = $signed({instr1[31:25], instr1[11:7]}); end
            7'b0010011: begin alu_op1 = funct3_1; imm1 = $signed(instr1[31:20]); end
            7'b0110011: begin alu_op1 = {funct7_1[5], funct3_1}; end
            7'b1100011: begin is_branch1=1; imm1 = $signed({instr1[31], instr1[7], instr1[30:25], instr1[11:8], 1'b0}); end
            7'b1101111: begin is_jal1  = 1; imm1 = $signed({instr1[31], instr1[19:12], instr1[20], instr1[30:21], 1'b0}); end
            7'b1100111: begin is_jalr1=1; alu_op1=funct3_1; imm1 = $signed(instr1[31:20]); end
            default: ;
        endcase
    end
endmodule
