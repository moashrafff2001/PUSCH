module Mod_Mapper#(parameter LUT_WIDTH = 18 , parameter OUT_WIDTH = 34 )(

    input wire CLK_Mod , 
    input wire RST_Mod , 
    input wire EN_Mod , 
    input wire Valid_Mod_IN , 
    input wire [2:0] Order_Mod ,
    input wire signed [LUT_WIDTH-1:0] QPSK_I ,
    input wire signed [LUT_WIDTH-1:0] QPSK_Q ,
    input wire signed [LUT_WIDTH-1:0] QAM16_I,
    input wire signed [LUT_WIDTH-1:0] QAM16_Q,
    input wire signed [LUT_WIDTH-1:0] QAM64_I,
    input wire signed [LUT_WIDTH-1:0] QAM64_Q,
    
    output wire EN_QPSK , 
    output wire EN_QAM16 ,
    output wire EN_QAM64 ,

    output reg Flag ,
    output reg Mod_Valid_OUT ,
    output reg [10:0] Wr_addr ,  
    output reg write_enable , 
    output reg MOD_DONE , 
    output reg signed [LUT_WIDTH-1:0] Mod_OUT_I , 
    output reg signed [LUT_WIDTH-1:0] Mod_OUT_Q , 

    output reg PINGPONG_SWITCH 

);

reg [2:0] Counter ; 
reg signed [OUT_WIDTH-1:0] I_reg ;
reg signed [OUT_WIDTH-1:0] Q_reg ;
reg [3:0] PingPong_Counter ; 

localparam signed [LUT_WIDTH-1:0] QPSK_Fac =  'd724;
localparam signed [LUT_WIDTH-1:0] QAM16_Fac = 'd324;
localparam signed [LUT_WIDTH-1:0] QAM64_Fac = 'd158;


always@(posedge CLK_Mod) begin
   if (Valid_Mod_IN ==1 && EN_Mod) begin        
        if (Counter == Order_Mod) begin
            Flag <= 1 ; 
            Counter <= 1 ;
        end
        else begin
            Counter <= Counter + 1'b1 ;
            Flag <= 0 ;
        end    
   end else begin            
            Counter <= 0;
            Flag <= 0 ;
   end
end

always@(posedge CLK_Mod) begin
   if(!RST_Mod) begin 
        PingPong_Counter <= 0 ; 
        MOD_DONE <= 0 ;   

   end
   else if (Valid_Mod_IN == 1 ) begin        
            if(Wr_addr == 1200) begin
                PingPong_Counter <= 3 ; 
                MOD_DONE <= 1 ;   
            end
          else if ((PingPong_Counter == Order_Mod+2) && !Mod_Valid_OUT) begin 
                PingPong_Counter <= 0 ; 
                MOD_DONE <= 1 ;   

          end else if ((PingPong_Counter == Order_Mod+2) && Mod_Valid_OUT) begin 
                PingPong_Counter <= 3 ; 
                MOD_DONE <= 0 ;   

          end
          else begin  
                PingPong_Counter <= PingPong_Counter +1 ; 
                MOD_DONE <= 0 ;   
          end
   end 
   else if (! Valid_Mod_IN) begin 
                PingPong_Counter <= 0 ; 
                MOD_DONE <= 1 ;  
   end
end

always@(*) begin 

    if(!RST_Mod)
        PINGPONG_SWITCH = 0 ; 
//    else if (Wr_addr == 1200 )
 //       PINGPONG_SWITCH = 1 ;    
    else if (MOD_DONE && Valid_Mod_IN) 
        PINGPONG_SWITCH =1 ;     
    else 
        PINGPONG_SWITCH = 0 ; 
end    



always@(posedge CLK_Mod or negedge RST_Mod) begin
    if(!RST_Mod) begin
        Mod_OUT_I <= 0 ;
        Mod_OUT_Q <= 0 ;
        Counter <= 0 ;
        Flag <= 0 ;
        Mod_Valid_OUT <= 0 ; 
        Wr_addr <= 'b0 ;    
        write_enable <= 0 ; 
    end
    
    else if (!Valid_Mod_IN) begin 
        Wr_addr <= 'b0 ;    
        Mod_Valid_OUT <= 0 ; 
        write_enable <= 0 ;
 
    end    
  else if (Wr_addr == 1200) begin
            Wr_addr <= 0 ; 
            Mod_Valid_OUT <= 0 ; 
  end
  else if (Valid_Mod_IN & !MOD_DONE) begin
                write_enable <= 1 ;      
     if (Flag)begin
        case(Order_Mod)
        2: begin 

            Mod_OUT_I <=   I_reg[LUT_WIDTH-1:0] ;
            Mod_OUT_Q <=   Q_reg [LUT_WIDTH-1:0]  ;
            Mod_Valid_OUT <= 1'b1 ;
            if(Wr_addr != 1200) begin
                  Wr_addr <= Wr_addr + 1 ; 
            end else begin 
                  Wr_addr <= 0 ;   
            end    
                
        end
        4 : begin 
              
            Mod_OUT_I <=   I_reg[LUT_WIDTH-1:0] ;
            Mod_OUT_Q <=   Q_reg [LUT_WIDTH-1:0]  ;                
            Mod_Valid_OUT <= 1'b1 ;
            if(Wr_addr <=1199) begin
                    Wr_addr <= Wr_addr + 1 ; 
            end else begin 
                  Wr_addr <= 0 ;   
            end  

        end

        6 :  begin 
            Mod_OUT_I <=   I_reg[LUT_WIDTH-1:0] ;
            Mod_OUT_Q <=   Q_reg [LUT_WIDTH-1:0]  ;  
             Mod_Valid_OUT <= 1'b1 ;
            if(Wr_addr <=1199) begin
                    Wr_addr <= Wr_addr + 1 ; 
            end else begin 
                  Wr_addr <= 0 ;   
            end  

        end

        endcase

    end   
    else begin
             Mod_Valid_OUT <= 0 ;
    end    
end 

end

assign EN_QPSK = ((Flag==1) && (Order_Mod == 2))? 1'b1 :1'b0;
assign EN_QAM16 = ((Flag==1) && (Order_Mod == 4))? 1'b1 :1'b0;
assign EN_QAM64 = ((Flag==1) && (Order_Mod == 6))? 1'b1 :1'b0;
always@(*)begin
    if(!RST_Mod) begin 
        I_reg = 'b0 ; 
        Q_reg = 'b0 ; 
    end    
    else if(EN_QPSK) begin 
      I_reg =  QPSK_I * QPSK_Fac;
      Q_reg =QPSK_Q * QPSK_Fac;
    end else if(EN_QAM16) begin    
       I_reg = QAM16_I * QAM16_Fac ;
       Q_reg = QAM16_Q * QAM16_Fac;
   end else if(EN_QAM64)  begin
        I_reg = QAM64_I * QAM64_Fac ; 
        Q_reg =  QAM64_Q * QAM64_Fac ; 
    end
    else begin 
        I_reg = QAM64_I * QAM64_Fac ; 
        Q_reg =  QAM64_Q * QAM64_Fac ; 
    end   
end 


always@(posedge CLK_Mod) begin 
    if(!MOD_DONE)
        write_enable <= 1 ;
     else
        write_enable <= 0 ;    
end

endmodule