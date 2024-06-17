module Scrambler(
    
    input wire CLK_SC , 
    input wire RST_SC , 
    input wire EN_SC , 
    input wire SC_IN , // input bit from interleaver
    input wire GOLD_VALID , //Valid signal from PR_Gen 
    input wire SC_BUSY_IN , 
    input wire SC_Valid_IN, // from interleaver
    input wire Gold_IN ,  // input of PR_Gen
    output reg SC_OUT ,  // Output bit
    output reg SC_Valid_OUT //Valid Signal output to Modualtion mapper
);

always @ (posedge CLK_SC or negedge RST_SC) begin 

    if(!RST_SC) begin
        SC_Valid_OUT <= 'b0 ; 
        SC_OUT <= 0 ; 
    end   
    else if (EN_SC) begin
        if(SC_Valid_IN && GOLD_VALID && SC_BUSY_IN) begin 
            SC_OUT <= Gold_IN ^ SC_IN ;
            SC_Valid_OUT <= 1'b1 ; 
        end
        else begin 
             SC_OUT <= 0 ;
             SC_Valid_OUT <= 1'b0 ; 
        end
    end
    else begin 
        SC_OUT <= 0 ; 
        SC_Valid_OUT <= 'b0 ; 

    end   

end

endmodule