module PipeCtrl (
    input  logic branch_mispredict_i,
    input  logic trap_valid_i,
    input  logic load_hazard_i,
    output logic flush_if_o,
    output logic flush_id_o,
    output logic stall_if_o,
    output logic stall_id_o
);
    assign flush_if_o = branch_mispredict_i || trap_valid_i;
    assign flush_id_o = branch_mispredict_i || trap_valid_i;
    assign stall_if_o = load_hazard_i;
    assign stall_id_o = load_hazard_i;
endmodule
