module TopDMRS (
	input clk,
	input reset,
	input enable,
	input [9:0] n_ID,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	input [7:0] c,
	output wire signed [8:0] DMRS_r,
	output wire signed [8:0] DMRS_i,
	output wire DMRS_valid
);

wire [12:0] phase;
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
RefSignalGen Dmrs_Generator (clk, reset, enable, Mzc, u, v, Nzc, Nzc_rec, phi1_value, phi2_value, phi3_value,
							 phi4_value, sin_value, cos_value, counter, phase, DMRS_r, DMRS_i, DMRS_valid);

// Paramters Generator
ParamGen Dmrs_ParamGenerator (n_ID, N_rb, En_hopping, c, Mzc, u, v);

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