module SC_TOP( 
    input wire CLK_TOP , 
    input wire RST_TOP , 
    input wire EN_TOP , 
    input wire Shift_TOP , 
    input wire Config_TOP , // Higher Layer Parameter is Configured --> 1 else --> 0 
    input wire [9:0] N_cellID_TOP,
    input wire [5:0] N_Rapid_TOP , 
    input wire [15:0] N_Rnti_TOP , 
    input wire TOP_IN , 
    input wire TOP_BUSY_IN , 
    input wire TOP_Valid_IN,
    output wire SC_OUT , 
    output wire SC_Valid_OUT
);
    wire GOLD_OUT ; 
    wire GOLD_VALID ; 

Gold_Gen PRGEN(
    .CLK_PR(CLK_TOP) ,
    .RST_PR(RST_TOP) ,
    .EN_PR(EN_TOP) , 
    .Config(Config_TOP),
    .N_cellID(N_cellID_TOP),
    .Shift(Shift_TOP) ,
    .N_Rapid(N_Rapid_TOP),
    .N_Rnti(N_Rnti_TOP) ,
    .PR_BUSY_IN(TOP_BUSY_IN) ,
    .OUT_Enable(TOP_Valid_IN) , 
    .Gold_Seq(GOLD_OUT) , 
    .GOLD_VALID(GOLD_VALID)
);

Scrambler SC_1(

    .CLK_SC(CLK_TOP) ,
    .RST_SC(RST_TOP) ,
    .EN_SC(EN_TOP) , 
    .SC_IN(TOP_IN),
    .SC_BUSY_IN(TOP_BUSY_IN) ,
    .SC_Valid_IN(TOP_Valid_IN) , 
    .Gold_IN(GOLD_OUT) , 
    .SC_OUT(SC_OUT) , 
    .SC_Valid_OUT(SC_Valid_OUT) , 
    .GOLD_VALID(GOLD_VALID)
);

endmodule