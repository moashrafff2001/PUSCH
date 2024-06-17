module REM_TOP#(
    parameter MEM_DEPTH = 2048,
    parameter WRITE_ADDR_SHIFT = 424 , // Address shift for zero padding
    parameter DATA_WIDTH = 26 ,
    parameter FFT_Len = 18 , 
    parameter DMRS_Len = 9 
)(
    // system signals
    input wire CLK_RE_TOP , 
    input wire RST_RE_TOP , 
    input wire EN_RE_TOP ,

    // base station inputs
    input wire [10:0] N_sc_TOP , // subcarrier starting point
    input wire [6:0] N_rb_TOP ,     // no. of RBs allocated
    input wire unsigned [3:0] Sym_Start_TOP ,
    input wire unsigned [3:0] Sym_End_TOP ,  

    // DMRS inputs
    input wire signed [DMRS_Len-1:0]Dmrs_I_TOP , 
    input wire signed [DMRS_Len-1:0]Dmrs_Q_TOP ,
    input wire DMRS_Valid_In_TOP ,
    input wire DMRS_Done_TOP ,

    // FFT inputs
    input wire signed [FFT_Len-1:0] FFT_I_TOP , 
    input wire signed [FFT_Len-1:0] FFT_Q_TOP , 
    input wire FFT_Valid_In_TOP ,
    input wire FFT_Done_TOP , // flag reports that fft finished writing in memory & all symbols is valid
    input wire [10:0] FFT_addr_TOP , // mn mostafa direct
    
    // outputs
    output wire [9:0] DMRS_addr_TOP , // dmrs memory ely abli 

    
    output wire [DATA_WIDTH-1:0] PingPongOUT_I_TOP , 
    output wire [DATA_WIDTH-1:0] PingPongOUT_Q_TOP , 

    output wire Ping_VALID_I , 
    output wire Ping_VALID_Q


); 

wire signed [FFT_Len-1:0] RE_Real_TOP;
wire signed [FFT_Len-1:0] RE_Imj_TOP; 
wire RE_Valid_OUT_TOP;
wire [10:0] Wr_addr_TOP; 
wire Sym_Done_TOP;
wire RE_Done_TOP; 
wire write_enable_TOP; 


REmapper_new DDD0(

.CLK_RE(CLK_RE_TOP) ,
.RST_RE(RST_RE_TOP) , 
.EN_RE(EN_RE_TOP) , 
.N_sc(N_sc_TOP) , 
.N_rb(N_rb_TOP) , 
.Sym_Start(Sym_Start_TOP) , 
.Sym_End(Sym_End_TOP) , 
.Dmrs_I(Dmrs_I_TOP) , 
.Dmrs_Q(Dmrs_Q_TOP) , 
.DMRS_Valid_In(DMRS_Valid_In_TOP) , 
.DMRS_Done(DMRS_Done_TOP),
.FFT_I(FFT_I_TOP) , 
.FFT_Q(FFT_Q_TOP) , 
.FFT_Valid_In(FFT_Valid_In_TOP),
.FFT_Done(FFT_Done_TOP) , 
.RE_Real(RE_Real_TOP) , 
.RE_Imj(RE_Imj_TOP) , 
.RE_Valid_OUT(RE_Valid_OUT_TOP) , 
.Wr_addr(Wr_addr_TOP) , 
.FFT_addr(FFT_addr_TOP) , 
.DMRS_addr(DMRS_addr_TOP) , 
.Sym_Done(Sym_Done_TOP) , 
.RE_Done(RE_Done_TOP) , 
.write_enable(write_enable_TOP)

) ; 

PingPongMemory DDD1(

.CLK(CLK_RE_TOP) , 
.RST(RST_RE_TOP) , 
.data_in(RE_Real_TOP) , 
.write_enable(write_enable_TOP) , 
.Sym_Done(Sym_Done_TOP) , 
.write_addr(Wr_addr_TOP) , 
.data_out(PingPongOUT_I_TOP) , 
.Ping_VALID(Ping_VALID_I) , 
.RE_Done(RE_Done_TOP)

);
PingPongMemory DDD2(

.CLK(CLK_RE_TOP) , 
.RST(RST_RE_TOP) , 
.data_in(RE_Imj_TOP) , 
.write_enable(write_enable_TOP) , 
.Sym_Done(Sym_Done_TOP) , 
.write_addr(Wr_addr_TOP) , 
.data_out(PingPongOUT_Q_TOP) , 
.Ping_VALID(Ping_VALID_Q) , 
.RE_Done(RE_Done_TOP)

);






endmodule
