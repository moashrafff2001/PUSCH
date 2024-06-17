module SDF2_TOP # (parameter WIDTH = 26)

(
 input   wire clk,
 input   wire rst,
 input   wire [WIDTH-1:0] data_in1_r,
 input   wire [WIDTH-1:0] data_in1_i,
 input   wire VALID,

 output wire READy_out,
 output wire [10:0] IFFT_mem_address,            // IFFT Memory address
 output  wire [WIDTH-1:0] data_out1_r,
 output  wire [WIDTH-1:0] data_out1_i

);



wire [WIDTH-1:0] twiddle_r1;              // out of Twiddle Real stage 1
wire [WIDTH-1:0] twiddle_i1;              // out of Twiddle Imaj stage 1
wire [WIDTH-1:0] twiddle_r2;              // out of Twiddle Real stage 2
wire [WIDTH-1:0] twiddle_i2;              // out of Twiddle Imaj stage 2
wire [WIDTH-1:0] twiddle_r3;              // out of Twiddle Real stage 3
wire [WIDTH-1:0] twiddle_i3;              // out of Twiddle Imaj stage 3
wire [WIDTH-1:0] twiddle_r4;              // out of Twiddle Real stage 4
wire [WIDTH-1:0] twiddle_i4;              // out of Twiddle Imaj stage 4
wire [WIDTH-1:0] twiddle_r5;              // out of Twiddle Real stage 5
wire [WIDTH-1:0] twiddle_i5;              // out of Twiddle Imaj stage 5
wire [WIDTH-1:0] twiddle_r6;              // out of Twiddle Real stage 5
wire [WIDTH-1:0] twiddle_i6;              // out of Twiddle Imaj stage 5

wire [WIDTH-1:0] in_r1,in_r2,in_r3,in_r4,in_r5,in_r6;                 // out of R2-R4 Real stage 1-6
wire [WIDTH-1:0] in_i1,in_i2,in_i3,in_i4,in_i5,in_i6;                 // out of R2-R4 Imaj stage 1-6

wire [WIDTH-1:0] out_r1,out_r2,out_r3,out_r4,out_r5;                  // out of Comlx_Mult Real stage 1-6
wire [WIDTH-1:0] out_i1,out_i2,out_i3,out_i4,out_i5;                  // out of Comlx_Mult Imaj stage 1-6

wire [11:0]  address1,address2,address3,address4,address5,address6;   // in for twiddle indicies
// wire [10:0]  IFFT_mem_address;                                        // IFFT Memory address

wire valid1,valid2,valid3,valid4,valid5;                              // in for twiddle indicies


///********************************************************///
//////////////////// R2_butterfly Unit Stage 1 /////////////////////
///********************************************************///

R2_butterfly # (.WIDTH(26) , .POINTS(1024)) u0(
    .clk(clk),
    .rst(rst),
    .data_in_r(data_in1_r),
    .data_in_i(data_in1_i),
    .VALID(VALID),    
    .radix_address(address1),
    .OUT_VALID(valid1),
    .data_out_r(in_r1),
    .data_out_i(in_i1) 
    );


								   
///********************************************************///
//////////////////// Twiddle Factor 2048 ROM /////////////////////
///********************************************************///

Twiddle2048 u1(
    .clk(clk),
    .addr(address1),    
    .tw_re(twiddle_r1), 
    .tw_im(twiddle_i1) 
    );


///********************************************************///
////////////////////// Complex Multiplier /////////////////////
///********************************************************///

Multiply u2(
    .a_re(in_r1), 
    .a_im(in_i1), 
    .b_re(twiddle_r1), 
    .b_im(twiddle_i1), 
    .m_re(out_r1),
    .m_im(out_i1)
    );


///********************************************************///
//////////////////// R4_butterfly1 Unit Stage 2 /////////////////////
///********************************************************///

R4_butterfly1 # (.WIDTH(26) , .POINTS(256)) u3(
    .clk(clk),
    .rst(rst),
    .VALID(valid1),
    .OUT_VALID(valid2),
    .data_in_r(out_r1),
    .data_in_i(out_i1),    
    .radix_address(address2), 
    .data_out_r(in_r2),
    .data_out_i(in_i2) 
    );


                                   
///********************************************************///
//////////////////// Twiddle Factor 2048 ROM /////////////////////
///********************************************************///

Twiddle2048 u4(                                                        
    .clk(clk),
    .addr(address2),    
    .tw_re(twiddle_r2), 
    .tw_im(twiddle_i2) 
    );


///********************************************************///
////////////////////// Complex Multiplier /////////////////////
///********************************************************///

Multiply u5(
    .a_re(in_r2), 
    .a_im(in_i2), 
    .b_re(twiddle_r2), 
    .b_im(twiddle_i2), 
    .m_re(out_r2),
    .m_im(out_i2)
    );



///********************************************************///
//////////////////// R4_butterfly1 Unit Stage 3 /////////////////////
///********************************************************///

R4_butterfly2 # (.WIDTH(26) , .POINTS(64)) u6(
    .clk(clk),
    .rst(rst),
    .VALID(valid2),
    .OUT_VALID(valid3),    
    .data_in_r(out_r2),
    .data_in_i(out_i2),    
    .radix_address(address3), 
    .data_out_r(in_r3),
    .data_out_i(in_i3) 
    );


                                   
///********************************************************///
//////////////////// Twiddle Factor 2048 ROM /////////////////////
///********************************************************///

Twiddle2048 u7(                                                             /// HERE ****????
    .clk(clk),
    .addr(address3),    
    .tw_re(twiddle_r3), 
    .tw_im(twiddle_i3) 
    );


///********************************************************///
////////////////////// Complex Multiplier /////////////////////
///********************************************************///

Multiply u8(
    .a_re(in_r3), 
    .a_im(in_i3), 
    .b_re(twiddle_r3), 
    .b_im(twiddle_i3), 
    .m_re(out_r3),
    .m_im(out_i3)
    );




///********************************************************///
//////////////////// R4_butterfly1 Unit Stage 4 /////////////////////
///********************************************************///

R4_butterfly3 # (.WIDTH(26) , .POINTS(16)) u9(
    .clk(clk),
    .rst(rst),
    .VALID(valid3),
    .OUT_VALID(valid4),    
    .data_in_r(out_r3),
    .data_in_i(out_i3),    
    .radix_address(address4), 
    .data_out_r(in_r4),
    .data_out_i(in_i4) 
    );


                                   
///********************************************************///
//////////////////// Twiddle Factor 2048 ROM /////////////////////
///********************************************************///

Twiddle2048 u10(                                                             /// HERE ****????
    .clk(clk),
    .addr(address4),    
    .tw_re(twiddle_r4), 
    .tw_im(twiddle_i4) 
    );


///********************************************************///
////////////////////// Complex Multiplier /////////////////////
///********************************************************///

Multiply u11(
    .a_re(in_r4), 
    .a_im(in_i4), 
    .b_re(twiddle_r4), 
    .b_im(twiddle_i4), 
    .m_re(out_r4),
    .m_im(out_i4)
    );


///********************************************************///
//////////////////// R4_butterfly1 Unit Stage 5 /////////////////////
///********************************************************///

R4_butterfly4 # (.WIDTH(26) , .POINTS(4)) u12(
    .clk(clk),
    .rst(rst),
    .VALID(valid4),
    .OUT_VALID(valid5),     
    .data_in_r(out_r4),
    .data_in_i(out_i4),    
    .radix_address(address5), 
    .data_out_r(in_r5),
    .data_out_i(in_i5) 
    );


                                   
///********************************************************///
//////////////////// Twiddle Factor 2048 ROM /////////////////////
///********************************************************///

Twiddle2048 u13(                                                             /// HERE ****????
    .clk(clk),
    .addr(address5),    
    .tw_re(twiddle_r5), 
    .tw_im(twiddle_i5) 
    );


///********************************************************///
////////////////////// Complex Multiplier /////////////////////
///********************************************************///

Multiply u14(
    .a_re(in_r5), 
    .a_im(in_i5), 
    .b_re(twiddle_r5), 
    .b_im(twiddle_i5), 
    .m_re(out_r5),
    .m_im(out_i5)
    );


///********************************************************///
//////////////////// R4_butterfly1 Unit Stage 6 /////////////////////
///********************************************************///

R4_butterfly5 # (.WIDTH(26) , .POINTS(1)) u15(
    .clk(clk),
    .rst(rst),
    .VALID(valid5),   
    .data_in_r(out_r5),
    .data_in_i(out_i5),    
    .radix_address(address6),
    .order_cnt(IFFT_mem_address),     
    .data_out_r(in_r6),
    .data_out_i(in_i6),
    .OUT_VALID(READy_out) 
    );


                                   
///********************************************************///
//////////////////// Twiddle Factor 2048 ROM /////////////////////
///********************************************************///

Twiddle2048 u16(                                                             /// HERE ****????  No boundaries in last stage
    .clk(clk),
    .addr(address6),    
    .tw_re(twiddle_r6), 
    .tw_im(twiddle_i6) 
    );


///********************************************************///
////////////////////// Complex Multiplier /////////////////////
///********************************************************///

Multiply u17(
    .a_re(in_r6), 
    .a_im(in_i6), 
    .b_re(twiddle_r6), 
    .b_im(twiddle_i6), 
    .m_re(data_out1_r),
    .m_im(data_out1_i)
    );


endmodule
 