module PUSCH_Top (
	input clk,
	input reset,
	input enable,
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
	// Inputs for CRC
	input Data_in,

	// Inputs for LDPC
	input [1:0] base_graph,

	// Inputs for Rate Matching & HARQ
	input [1:0] rv_number,
	input [3:0] process_number,
	input [16:0] available_coded_bits,

	// Inputs for Interleaver
	input [2:0] modulation_order,

	// Inputs for Scrambler
	input [5:0] N_Rapid,
	input [15:0] n_RNTI,
	input [9:0] N_cell_ID,

	// Inputs for Reference Signal
	input [3:0] N_slot_frame,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	
	// Inputs for Resource Element Mapper
	input [3:0] N_symbol,
	input [10:0] N_sc,
	
	output wire signed [14:0] Data_r,
	output wire signed [14:0] Data_i,
	output wire Data_valid
	);

// Internal wires in the system
// Valids of each block
wire CRC_valid, LDPC_valid, HARQ_valid, Interleaver_valid, Scrambler_valid,
	 Modulator_valid, DMRS_valid, FFT_valid, Re_Mapper_valid, IFFT_valid;

// Parameters for each block
parameter WIDTH_FFT = 18, WIDTH_IFFT = 26;

////////////////// Wires connecting between each two blocks //////////////////
// Between CRC and LDPC


// Between LDPC and HARQ
wire [127:0] data_LDPC_HARQ;

// Between HARQ and Interleaver

// Between Interleaver and Scrambler

// Between Scrambler and Modulator

// Between Modulator and FFT
wire signed [WIDTH_FFT-1:0] Data_Mod_FFT_i, Data_Mod_FFT_r;

// Between DMRS and Resource Mapper
wire signed [8:0] DMRS_i, DMRS_r, DMRS_i_mem, DMRS_r_mem;
wire DMRS_finished;

// Between FFT and Resource Mapper
wire signed [WIDTH_FFT-1:0] Data_FFT_REM_i, Data_FFT_REM_r;

// Between Resource Mapper and IFFT
wire signed [WIDTH_IFFT-1:0] Data_REM_IFFT_i, Data_REM_IFFT_r;

//////////////////////// Blocks Instantiations ////////////////////////
// CRC


// LDPC
LDPC LDPC_Block (
    .CLK(clk),
    .RST(reset),
    .DATA,
    .ACTIVE,
    .enable,
    .data_out(data_LDPC_HARQ),          
    .Valid(LDPC_valid)   
);

// Rate Matching & HARQ
RateMatching_and_HARQ RateMatching_and_HARQ_Block (
    .clk(clk),
	.rst(reset),
    .Active(LDPC_valid),
    .base_graph(base_graph),     // Base graph selection (1 or 2)
    Z,              // lifting factor
    .data_in(data_LDPC_HARQ),      // Input data stream
    .RV(rv_number),             // Redundancy Version (0, 1, 2, or 3)
    .PN(process_number),             // process number (0, 1, 2, or 3)
    data_size,             // total size of the ip data given from the LDPC
    .G(available_coded_bits),             // size of the op Rv given from the base station 
    op_RV_bit, 
    .valid_out(HARQ_valid)  // Output rate-matched data
);

// Bit Interleaver
interleaver interleaver_Block (
    .clk(clk),
	.reset(reset),
    .Active(HARQ_valid),
    .E(available_coded_bits),
    .Qm(modulation_order),
    data_in, // fix the size
    data_out, 
    valid_out, 
    data_not_repeated
);

// Scrambler


// Modulation Mapper


// Reference Signal
TopDMRS DMRS_Block (
	.clk(clk),
	.reset(reset),
	enable,
	.N_slot_frame(N_slot_frame),
	.n_ID(N_cell_ID),
	.N_rb(N_rb),
	.En_hopping(En_hopping),
	c,
	.DMRS_r(DMRS_r),
	.DMRS_i(DMRS_i),
	.DMRS_valid(DMRS_valid),
	.DMRS_finished(DMRS_finished)
);

// Memory Between DMRS and Resource element Mapper
DMRS_Mem DMRS_Mem_Block (
    .clk(clk),
	.reset(reset),
    .DMRS_valid(DMRS_valid),
    Re_start,
    .DMRS_r_in(DMRS_r),
    .DMRS_i_in(DMRS_i),
    .DMRS_r_out(DMRS_r_mem),
    .DMRS_i_out(DMRS_i_mem)
);

// FFT
Top #(.WIDTH(WIDTH_FFT)) FFT_Block
(
    .clk(clk),
	.rst(reset),
    .di_re(Data_Mod_FFT_r),
    .di_im(Data_Mod_FFT_i),
    Flag,
    done,
    .do_re(Data_FFT_REM_r),
    .do_im(Data_FFT_REM_i),
    do_en,
    address
    );

// Recource Element Mapper


// IFFT
SDF2_TOP #(.WIDTH(WIDTH_IFFT)) IFFT_Block
(
	.clk(clk),
	.rst(reset),
	.data_in1_r(Data_REM_IFFT_r),
	.data_in1_i(Data_REM_IFFT_i),
	VALID,
	READy_out,
	.data_out1_r(Data_IFFT_r),
	.data_out1_i(Data_IFFT_i)
);

// Cyclic Prefix





endmodule
