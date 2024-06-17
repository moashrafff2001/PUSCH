module Gold_Gen( 
    input wire CLK_PR , 
    input wire RST_PR , 
    input wire EN_PR , 
    input wire Config , // Higher Layer Parameter is Configured --> 1 else --> 0 
    input wire Shift , 
    input wire [9:0] N_cellID,
    input wire [5:0] N_Rapid , 
    input wire [15:0] N_Rnti , 
    input wire PR_BUSY_IN , 
    input wire OUT_Enable , 
    output wire Gold_Seq ,   // Output Scrambling Bit
    output reg GOLD_VALID
 );
 
 localparam Nc = 1600 ; //Gold Shift
 localparam Seq_Len = 31 ;
 localparam X1_initialCond = 31'b1;   
 integer n  ; 
 reg Shift_end ; 
 wire [31:0] C_init ; // new value every time according to new upper layer parameters related to specific UE to guarntee randomness 

 reg [Seq_Len-1:0] X1 ;
 reg [Seq_Len-1:0] X2 ;
 wire Feedback_X1 ,Feedback_X2 ;


always @(posedge CLK_PR or negedge RST_PR)  begin
    if(! RST_PR) begin 

        X1 <= 31'b0 ; 
        X2 <= 31'b0 ;
        n <= 0 ; 
        Shift_end <= 0 ; 
    //    Gold_Seq <= 'b0 ; 
        GOLD_VALID <= 0 ; 

    end  else if (EN_PR && !Shift && !OUT_Enable) begin
        X1 <=  X1_initialCond ;
        X2 <= {'b0 , C_init } ;
        n <= 0 ;
        Shift_end <= 0 ; 
        GOLD_VALID <= 0 ;

    end

    else if (EN_PR && Shift && ! OUT_Enable) begin  
        
        GOLD_VALID <= 0 ; 
        if ( n < Nc) begin
     //       Feedback_X1 <= X1[3] ^ X1[0] ;
            X1 <= X1 >> 1 ;
            X1[Seq_Len-1] <= Feedback_X1 ;

      //      Feedback_X2 <= X2[3]^X2[2]^X2[1]^X2[0] ; 
            X2 <= X2 >> 1 ;
            X2[Seq_Len-1] <= Feedback_X2 ;

            n <= n+1 ; 
            
              // scrambling bit 

        end   
        else  begin
            Shift_end <= 1 ; 
            GOLD_VALID <= 1 ; 
        end       
    end    
        else if (OUT_Enable && PR_BUSY_IN) begin
                   
                X1 <= X1 >> 1 ;
                X1[Seq_Len-1] <= Feedback_X1 ;

                X2 <= X2 >> 1 ;
                X2[Seq_Len-1] <= Feedback_X2 ;    
                
                GOLD_VALID <=1 ; 

        //end
        end
        else begin 
                GOLD_VALID <= 0 ;  
        end    
end


assign C_init = (Config == 1)? ((N_Rnti<<16) + (N_Rapid<<10)+N_cellID) : (N_Rnti<<15)+N_cellID ; 
assign Feedback_X1 = X1[3] ^ X1[0] ;
assign Feedback_X2 = X2[3]^X2[2]^X2[1]^X2[0];
assign Gold_Seq = X1[0] ^X2[0] ;
endmodule