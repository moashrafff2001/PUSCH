module Mapper_TOP#(parameter LUT_WIDTH = 18 , parameter OUT_WIDTH = 36 )(
    
    input wire Serial_IN , // ex
    input wire CLK_Mod , 
    input wire RST_Mod , 
    input wire Valid_Mod_IN , 
    input wire [2:0] Order_Mod ,

    output wire Mod_Valid_OUT , 
    output wire signed [LUT_WIDTH-1:0] Mod_OUT_I,
    output wire signed [LUT_WIDTH-1:0] Mod_OUT_Q,

    output wire MOD_DONE , 
    output wire [10:0] Wr_addr ,
    output wire [10:0] Last_addr , 

    output wire write_enable  , 
    output wire PINGPONG_SWITCH 
    

);
       
     wire Mem_Done ;
   
    wire signed [ LUT_WIDTH-1:0] QPSK_I ;
    wire signed [ LUT_WIDTH-1:0] QPSK_Q ;
    wire signed[ LUT_WIDTH-1:0] QAM16_I;
    wire signed[ LUT_WIDTH-1:0] QAM16_Q;
    wire signed[ LUT_WIDTH-1:0] QAM64_I;
    wire signed[ LUT_WIDTH-1:0] QAM64_Q;
    wire EN_QPSK ; 
    wire EN_QAM16 ;
     wire EN_QAM64 ;
    wire [5:0] Bits_Mod ;

Mod_Mapper D1(

    .CLK_Mod(CLK_Mod) , 
    .RST_Mod(RST_Mod) , 
    .Valid_Mod_IN(Valid_Mod_IN) , 
    .Order_Mod(Order_Mod),
    .QPSK_I(QPSK_I),
    .QPSK_Q(QPSK_Q) ,
    .QAM16_I(QAM16_I),
    .QAM16_Q(QAM16_Q),
    .QAM64_I(QAM64_I),
    .QAM64_Q(QAM64_Q),
    .Last_addr(Last_addr) , 
    .EN_QPSK(EN_QPSK) , 
    .EN_QAM16 (EN_QAM16),
    .EN_QAM64(EN_QAM64) ,
    .Flag(Mem_Done) ,
    .Mod_Valid_OUT(Mod_Valid_OUT) , 
    .Mod_OUT_I(Mod_OUT_I) , 
    .Mod_OUT_Q(Mod_OUT_Q) , 
    .Wr_addr(Wr_addr) , 
    .MOD_DONE(MOD_DONE) , 
    .write_enable(write_enable) , 
    .PINGPONG_SWITCH(PINGPONG_SWITCH)
);

SC_MOD_Mem D2(
   .CLK(CLK_Mod) , 
   .RST(RST_Mod) ,
   .Done(Mem_Done) ,
   .SC_IN(Serial_IN) ,
   .SC_Valid(Valid_Mod_IN) ,
   .Mod_IN(Bits_Mod)
);

QPSk_LUT D3 (
 .Bits_In(Bits_Mod[5:4]) , 
 .EN_QPSK(EN_QPSK) ,
 .QPSK_I(QPSK_I),
 .QPSK_Q(QPSK_Q)
);

QAM16_LUT D4 (
    .Bits_In(Bits_Mod[5:2]),
    .EN_QAM16(EN_QAM16) , 
    .QAM16_I(QAM16_I),
    .QAM16_Q(QAM16_Q)
);

QAM64_LUT D5 (
    .Bits_In(Bits_Mod[5:0]),
    .EN_64QAM(EN_QAM64) , 
    .QAM64_I(QAM64_I),
    .QAM64_Q(QAM64_Q)
);
endmodule
