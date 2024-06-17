module TopDMRS #(
    parameter WIDTH = 9
    )(
	input clk,
	input reset,
	input [3:0] N_slot_frame,
	input [9:0] N_cell_ID,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	output wire signed [8:0] DMRS_r,
	output wire signed [8:0] DMRS_i,
	output wire DMRS_valid,
	output wire DMRS_finished
);

wire [30:0] pseudo_sequence;
wire [14:0] phase;
wire signed [8:0] sin_value, cos_value;
wire [9:0] Mzc;
wire [9:0] counter;
wire [4:0] u;
wire v;
wire [9:0] Nzc;
wire [29:0] Nzc_rec;
wire [1:0] phi1_value;
wire [1:0] phi2_value;
wire [1:0] phi3_value;
wire [1:0] phi4_value;

// Reference Signal Generator
RefSignalGen #(.WIDTH(WIDTH)) Dmrs_Generator (clk, reset, Mzc, u, v, Nzc, Nzc_rec, phi1_value, phi2_value, phi3_value,
							 phi4_value, sin_value, cos_value, counter, phase, DMRS_r, DMRS_i, DMRS_valid, DMRS_finished);

// Paramters Generator
ParamGen Dmrs_ParamGenerator (N_slot_frame, N_cell_ID, N_rb, En_hopping, pseudo_sequence, Mzc, u, v);

// PRS Generator
PRS_Generator PRS_Block ( N_cell_ID, En_hopping, pseudo_sequence);

// Sine LUT
SinLUT Dmrs_LookupTable (phase, sin_value, cos_value);

// Nzc
N_zc table_prime (Mzc, Nzc, Nzc_rec);

// phi1
phi1 table_1 (u, counter, phi1_value);

// phi2
phi2 table_2 (u, counter, phi2_value);

// phi3
phi3 table_3 (u, counter, phi3_value);

// phi4
phi4 table_4 (u, counter, phi4_value);

endmodule