module PUSCH_Top (
	input clk,
	input reset,
	input enable,

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
	input [15:0] N_Rnti,
	input [9:0] N_cell_ID,
	input Config,

	// Inputs for Reference Signal
	input [3:0] N_slot_frame,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	
	// Inputs for Resource Element Mapper
	input [3:0] N_symbol,
	input [10:0] N_sc_start, // subcarrier starting point
	input [3:0] Sym_Start_REM ,
    input [3:0] Sym_End_REM , 
	
	output signed [WIDTH_IFFT-1:0] Data_r,
	output signed [WIDTH_IFFT-1:0] Data_i,
	output Data_valid
	);

// Internal wires in the system
// Valids of each block
wire CRC_valid, LDPC_valid, HARQ_valid, Interleaver_valid, Scrambler_valid,
	 Modulator_valid, DMRS_valid, FFT_valid, Re_Mapper_valid, IFFT_valid, Ping_valid;

// Parameters for each block
// CRC parameters
 parameter SEED = 16'h0000;

parameter WIDTH_FFT = 18, WIDTH_IFFT = 26;
parameter WIDTH_DMRS = 9;

// Mapper parameters
parameter LUT_WIDTH = 18, OUT_WIDTH = 36 ;

// Mapper FFT Memory
parameter MEM_DEPTH_FFT = 1200;


// REM parameters
parameter MEM_DEPTH_IFFT = 2048,
parameter WRITE_ADDR_SHIFT = 424; // Address shift for zero padding
parameter DATA_WIDTH = 36;


////////////////// Wires connecting between each two blocks //////////////////
// Between CRC and LDPC
wire [19:0] Data_CRC_LDPC;

// Between LDPC and HARQ
wire [127:0] Data_LDPC_HARQ;

// Between HARQ and Interleaver
wire data_HARQ_Interleaver;
wire data_not_repeated;

// Between Interleaver and Scrambler
wire data_Interleaver_Scrambler;

// Between Scrambler and Modulator
wire data_Scrambler_Modulator;

// Between Modulator and FFT
wire signed [WIDTH_FFT-1:0] Data_Mod_FFT_i, Data_Mod_FFT_r;
wire signed [WIDTH_FFT-1:0] Data_Mod_Mem_i, Data_Mod_Mem_r;
wire Mod_done;
wire PINGPONG_SWITCH;
wire [10:0] Wr_addr_Mod;
wire wrt_enable_Mod;

// Between DMRS and Resource Mapper
wire signed [8:0] DMRS_i, DMRS_r, DMRS_i_mem, DMRS_r_mem;
wire DMRS_finished;
wire [9:0] DMRS_ptr;

// Between FFT and Resource Mapper
wire signed [WIDTH_FFT-1:0] Data_FFT_REM_i, Data_FFT_REM_r;
wire [10:0] Write_addr_FFT;
wire FFT_done;

// Between Resource Mapper and IFFT
wire signed [WIDTH_IFFT-1:0] Data_REM_IFFT_i, Data_REM_IFFT_r;
wire [10:0] Write_addr_IFFT;
wire Sym_Done_REM ,RE_Done_REM;

// Between Resource Mapper and PinPong Memory
wire signed [WIDTH_IFFT-1:0] Data_REM_Mem_i, Data_REM_Mem_r;


// Between IFFT and Cyclic Prefix
wire signed [WIDTH_IFFT-1:0] Data_IFFT_CP_i, Data_IFFT_CP_r;


//////////////////////// Blocks Instantiations ////////////////////////
// CRC
CRC #(.SEED(SEED)) ( 
   .CLK(clk) ,          
   .RST(reset) ,          
   .DATA(Data_in) ,         
   .ACTIVE(enable) ,       
   .data_out(Data_CRC_LDPC),          
   .Valid(CRC_valid)         
  );


// LDPC
LDPC LDPC_Block (
    .CLK(clk),
    .RST(reset),
    .DATA(Data_CRC_LDPC),
    .ACTIVE(CRC_valid),
    .data_out(Data_LDPC_HARQ),          
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
    .op_RV_bit(data_HARQ_Interleaver), 
    .valid_out(HARQ_valid)  // Output rate-matched data
);


// Bit Interleaver
interleaver interleaver_Block (
    .clk(clk),
	.reset(reset),
    .Active(HARQ_valid),
    .E(available_coded_bits),
    .Qm(modulation_order),
    .data_in(data_HARQ_Interleaver), // fix the size
    .data_out(data_Interleaver_Scrambler), 
    .valid_out(Interleaver_valid), 
    .data_not_repeated(data_not_repeated)
);


// Scrambler
SC_TOP Scrambler_Block ( 
    .CLK_TOP(clk) , 
    .RST_TOP(reset) , 
    EN_TOP , 
    Shift_TOP , 
    .Config_TOP(Config) , // Higher Layer Parameter is Configured --> 1 else --> 0 
    .N_cellID_TOP(N_cell_ID),
    .N_Rapid_TOP(N_Rapid) , 
    .N_Rnti_TOP(N_Rnti) , 
    .TOP_IN(data_Interleaver_Scrambler) , 
    .TOP_BUSY_IN(data_not_repeated) , 
    .TOP_Valid_IN(Interleaver_valid) ,

    .SC_OUT(data_Scrambler_Modulator) , 
    .SC_Valid_OUT(Scrambler_valid)
);


// Modulation Mapper
Mapper_TOP#(.LUT_WIDTH(LUT_WIDTH), .OUT_WIDTH(OUT_WIDTH)) Mapper_Block (  
    .Serial_IN(data_Scrambler_Modulator) , // ex
    .CLK_Mod(clk) , 
    .RST_Mod(reset) , 
    EN_Mod , 
    .Valid_Mod_IN(Scrambler_valid) , 
    .Order_Mod(modulation_order) ,

    .Mod_Valid_OUT(Modulator_valid) , 
    .Mod_OUT_I(Data_Mod_Mem_r),
    .Mod_OUT_Q(Data_Mod_Mem_i),

    .MOD_DONE(Mod_done) , 
    .Wr_addr(Wr_addr_Mod) ,
    .write_enable(wrt_enable_Mod) ,
    .PINGPONG_SWITCH(PINGPONG_SWITCH) 
);


// Real part Memory Between Mapper and FFT
PingPongMem_MOD #(.MEM_DEPTH(MEM_DEPTH_FFT), .DATA_WIDTH(WIDTH_FFT)) Mod_FFT_Mem_r_Block (
    .CLK(clk),
    .RST(reset),
    EN,

    .data_in(Data_Mod_Mem_r),
    read_enable,
    .write_enable(wrt_enable_Mod),
    Mod_Valid_OUT ,
    .PINGPONG_SWITCH(PINGPONG_SWITCH) ,  
    .MOD_DONE(Mod_done) , 
    .write_addr(Wr_addr_Mod),  // External write address input
    read_addr,   // External read address input
    .data_out(Data_Mod_FFT_r)  // Output data
);


// Imaginary part Memory Between Mapper and FFT
PingPongMem_MOD #(.MEM_DEPTH(MEM_DEPTH_FFT), .DATA_WIDTH(WIDTH_FFT)) Mod_FFT_Mem_i_Block (
    .CLK(clk),
    .RST(reset),
    EN,

    .data_in(Data_Mod_Mem_i),
    read_enable,
    .write_enable(wrt_enable_Mod),
    Mod_Valid_OUT ,
    .PINGPONG_SWITCH(PINGPONG_SWITCH) ,
    .MOD_DONE(Mod_done) , 
    .write_addr(Wr_addr_Mod),  // External write address input
    read_addr,   // External read address input
    .data_out(Data_Mod_FFT_i)  // Output data
);


// FFT
Top #(.WIDTH(WIDTH_FFT)) FFT_Block (
    .clk(clk),
	.rst(reset),
    .di_re(Data_Mod_FFT_r),
    .di_im(Data_Mod_FFT_i),
    Flag,
    .done(Mod_done),
    .do_re(Data_FFT_REM_r),
    .do_im(Data_FFT_REM_i),
    .do_en(FFT_valid),
    .address(Write_addr_FFT),
    .Finish(FFT_done)
    );


// Reference Signal
TopDMRS #(.WIDTH(WIDTH_DMRS)) DMRS_Block (
	.clk(clk),
	.reset(reset),
	.N_slot_frame(N_slot_frame),
	.N_cell_ID(N_cell_ID),
	.N_rb(N_rb),
	.En_hopping(En_hopping),
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
    .read_ptr(DMRS_ptr);
    .DMRS_r_in(DMRS_r),
    .DMRS_i_in(DMRS_i),
    .DMRS_r_out(DMRS_r_mem),
    .DMRS_i_out(DMRS_i_mem)
);


// Recource Element Mapper
REM_TOP #(.MEM_DEPTH(MEM_DEPTH_IFFT), .WRITE_ADDR_SHIFT(WRITE_ADDR_SHIFT),
    .DATA_WIDTH(WIDTH_IFFT), .FFT_Len(WIDTH_FFT), .DMRS_Len(WIDTH_DMRS)) REM_Block

   (.CLK_RE_TOP(clk) , 
    .RST_RE_TOP(reset) , 
    .EN_RE_TOP ,

    .N_sc_TOP(N_sc_start) , // subcarrier starting point
    .N_rb_TOP(N_rb) ,     // no. of RBs allocated
    .Sym_Start_TOP(Sym_Start_REM) ,
    .Sym_End_TOP(Sym_End_REM) ,  


    .Dmrs_I_TOP(DMRS_r_mem) , 
    .Dmrs_Q_TOP(DMRS_i_mem) ,
    .DMRS_Valid_In_TOP(DMRS_valid) ,
    .DMRS_Done_TOP(DMRS_finished) ,

    .FFT_I_TOP(Data_FFT_REM_r) , 
    .FFT_Q_TOP(Data_FFT_REM_i) , 
    .FFT_Valid_In_TOP(FFT_valid) ,
    .FFT_Done_TOP(FFT_done) , // flag reports that fft finished writing in memory & all symbols is valid
    .FFT_addr_TOP(Write_addr_FFT) , // fft memory read address ely abli 
    
    
    .RE_Real_TOP(Data_REM_Mem_r) , // to PingPong
    .RE_Imj_TOP(Data_REM_Mem_i) , // to PingPong
    .RE_Valid_OUT_TOP(Re_Mapper_valid) ,
    .Wr_addr_TOP(Write_addr_IFFT) , 
    .DMRS_addr_TOP(DMRS_ptr) , // dmrs memory ely abli 
    .Sym_Done_TOP(Sym_Done_REM) , 
    .RE_Done_TOP(RE_Done_REM) , 

    .PingPongOUT_I_TOP(Data_REM_IFFT_r) , 
    .PingPongOUT_Q_TOP(Data_REM_IFFT_i) , 

    output wire Ping_VALID_I , 
    output wire Ping_VALID_Q
);


// IFFT and Cyclic Prefix
IFFT_CP_TOP #(.WIDTH(WIDTH_IFFT)) IFFT_Block
(
	.clk(clk),
	.rst(reset),
	.data_in1_r(Data_REM_IFFT_r),
	.data_in1_i(Data_REM_IFFT_i),
	.VALID(Ping_valid),
	
	.READy_out(Data_valid),
	.data_out_r(Data_IFFT_CP_r),
	.data_out_i(Data_IFFT_CP_i)
);



endmodule
