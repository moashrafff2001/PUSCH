module IFFT_CP_TOP # (parameter WIDTH = 26)

(
 input   wire clk,
 input   wire rst,
 input   wire [WIDTH-1:0] data_in_r,
 input   wire [WIDTH-1:0] data_in_i,
 input   wire VALID,

 output wire READy_out,
 output  wire [WIDTH-1:0] data_out_r,
 output  wire [WIDTH-1:0] data_out_i

);

wire [WIDTH-1:0] fft_r,fft_i;                         // IFFT         output real/imaj
wire [WIDTH-1:0] MEM_r,MEM_i;                         // MEMORY       output real/imaj
wire [WIDTH-1:0] cp_r,cp_i;                           // CyclicPrefix output real/imaj

wire  fft_valid,cp_valid,MEM_valid;        // IFFT/CP/MEM output valid signals

wire [10:0] MEM_address;                              // IFFT Memory address
wire [7:0] cp_adrr;


///********************************************************///
//////////////////// IFFT UNIT /////////////////////
///********************************************************///

SDF2_TOP # (.WIDTH(26) ) u0(
    .clk(clk),
    .rst(rst),
    .data_in1_r(data_in_r),
    .data_in1_i(data_in_i),
    .VALID(VALID),    
    .READy_out(fft_valid),
    .IFFT_mem_address(MEM_address),    
    .data_out1_r(fft_r),
    .data_out1_i(fft_i) 
    );


								   
///********************************************************///
//////////////////// IFFT 2048 RAM /////////////////////
///********************************************************///

IFFT_MEM # (.WIDTH(26) ) u1(
    .clk(clk),
    .rst(rst),
    .VALID(fft_valid),
    .counter1(cp_adrr),     
    .serial_in_r(fft_r),          ////
    .serial_in_i(fft_i),          ////   
    .serial_out_r(MEM_r),          ////
    .serial_out_i(MEM_i),          ////
    .address(MEM_address),     
    .OUT_VALID(MEM_valid)     
    );


///********************************************************///
////////////////////// Cyclic Prefix UNIT /////////////////////
///********************************************************///

CyclicPrefix # (.WIDTH(26), .IFFT_SIZE(2048), .N_SYMB(14), .N_SUBFRAME(1), .NCP1(160), .NCP2(144) ) u3(
    .clk(clk),
    .rst(rst),
    .VALID(MEM_valid),
    .valid_in(fft_valid),
    .counter4(cp_adrr),
    .OUT_VALID(READy_out),         
    .data_in_r(MEM_r),          ////
    .data_in_i(MEM_i),          ////
    .data_out_r(cp_r),
    .data_out_i(cp_i) 
    );

endmodule
 