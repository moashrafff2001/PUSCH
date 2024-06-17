module REmapper_new #(parameter FFT_Len =18  ,parameter DMRS_Len = 9 )(
    input wire CLK_RE , 
    input wire RST_RE , 
    input wire EN_RE ,

    input wire [10:0] N_sc , // subcarrier starting point
    input wire [6:0] N_rb ,     // no. of RBs allocated
    input wire  [3:0] Sym_Start ,
    input wire  [3:0] Sym_End ,  


    input wire signed [DMRS_Len-1:0]Dmrs_I , 
    input wire signed [DMRS_Len-1:0]Dmrs_Q ,
    input wire DMRS_Valid_In ,
    input wire DMRS_Done ,

    input wire signed [FFT_Len-1:0] FFT_I , 
    input wire signed [FFT_Len-1:0] FFT_Q , 
    input wire FFT_Valid_In ,
    input wire FFT_Done , // flag reports that fft finished writing in memory & all symbols is valid
    input  wire [10:0] FFT_addr , // fft   address mn mostafa direct 

    output wire write_enable ,
    output reg signed [FFT_Len-1:0] RE_Real , 
    output reg signed [FFT_Len-1:0] RE_Imj , 
    output reg RE_Valid_OUT ,
    output reg [10:0] Wr_addr , 
    output reg [9:0] DMRS_addr , // dmrs memory ely abli 
    output reg Sym_Done , 
    output reg RE_Done
); 

localparam Total_Sc = 12'd1200 ; 
wire [10:0] N_symbol ;  // no. of fft symbols expected to recieve = nrb * 12
wire [9:0] D_symbol ;   // no. of dmrs symbols expected to recieve

wire [10:0] Last_indx ; 
reg [3:0] Symbol_now ; 
reg [10:0] Counter ; // ahm haga fel block 


parameter IDLE = 2'b00 ;  // at begining 
parameter WAIT_FFT = 2'b10 ; 
parameter Map_DMRS = 2'b01 ; 
parameter Map_FFT = 2'b11 ; 

reg [1:0] current_state , next_state ;

reg EN_Counter ; 

always @(posedge CLK_RE or negedge RST_RE) begin 
    if (!RST_RE) begin
        //DMRS_addr <= 0 ; 
        //RE_Valid_OUT <= 0 ;
        //RE_Real <= 12'b0 ; 
       // RE_Imj <= 12'b0 ;
       // Wr_addr <= 'b0 ;
        //Sym_Done <=0 ;
       // Counter <= 0 ;
       // RE_Done <= 0 ;
        //Symbol_now <= 0; 
        current_state <= IDLE ; 
    end
    else if (EN_RE)
        current_state <= next_state ;     
end 

always @(*) begin 

  case(current_state)

    IDLE: begin 
        if(EN_RE && (DMRS_Valid_In || DMRS_Done) && Symbol_now == Sym_Start) begin 
            next_state =Map_DMRS;
        end 
        else if (EN_RE && (FFT_Valid_In || FFT_Done) && (Symbol_now > Sym_Start && Symbol_now <= Sym_End)) begin
            next_state = Map_FFT; 
        end 
        else begin
            next_state = IDLE;
        end
    end     

    Map_DMRS: begin 
        if (EN_RE && (DMRS_Valid_In || DMRS_Done)) begin
            if (Counter >= N_sc && Counter < Last_indx) begin
                next_state = Map_DMRS; 
            end else begin
                next_state = WAIT_FFT; 
            end
        end else begin
            next_state = WAIT_FFT; 
        end
    end    
    WAIT_FFT : begin 
      if (EN_RE && (FFT_Valid_In || FFT_Done) && (Symbol_now > Sym_Start && Symbol_now <= Sym_End)) begin
            next_state = Map_FFT; 
      end else 
            next_state = WAIT_FFT ; 
    end  

    Map_FFT: begin 
        if (EN_RE && (FFT_Valid_In || FFT_Done) && (Symbol_now > Sym_Start && Symbol_now <= Sym_End) && Counter >= N_sc && Counter <= Last_indx) begin    
                next_state = Map_FFT; 
            end else if (Symbol_now < Sym_End+1) begin
                next_state = WAIT_FFT;  
            end
            else
                next_state = IDLE; 

    end 

 default: next_state = IDLE;
  endcase

end    

always @(*) begin

    case(current_state)

     IDLE : begin 
        Symbol_now = Sym_Start ; 
        RE_Valid_OUT = 1'b0 ; 
        EN_Counter = 1'b0 ; 
        Sym_Done = 1'b0 ; 
        RE_Real = 12'b0 ; 
        RE_Imj = 12'b0 ;
        Wr_addr = 'b0 ;
        if(Symbol_now > Sym_End )
            RE_Done = 1 ; 
        else 
            RE_Done = 0 ;  
    end   
  
        Map_DMRS : begin          
             EN_Counter = 1'b1 ; 
             RE_Done = 0 ; 
            
            if (Counter[0] ==  N_sc[0]) begin // condition to write dmrs symbols 
                RE_Real = Dmrs_I ;
                RE_Imj = Dmrs_Q ;
                Wr_addr = Counter ;
                RE_Valid_OUT = 1'b1 ;   
            end 
            else begin
                RE_Real = 1'b0 ;
                RE_Imj = 1'b0 ;
                Wr_addr = Counter ;
                RE_Valid_OUT = 1'b1 ;     
            end

            if (Counter >= Last_indx) begin
                Symbol_now = Sym_Start + 1 ; 
                Sym_Done = 1 ; 
            end else begin
                Symbol_now = Sym_Start ;
                Sym_Done = 0 ;       
            end
        end     
        WAIT_FFT : begin 
            Symbol_now = Sym_Start + 1 ;
            RE_Done = 0 ; 
            RE_Valid_OUT = 1'b0 ; 
            EN_Counter = 1'b0 ; 
            Sym_Done = 1'b0 ;
            Wr_addr = 1'b0 ;  
            RE_Imj = 0 ; 
            RE_Real = 0 ; 
        end   

        Map_FFT : begin    
            EN_Counter = 1'b1 ; 
       // condition ti write fft but dmrs is not done yet 
                RE_Done = 0 ; 
                RE_Real = FFT_I ; 
                RE_Imj = FFT_Q ; 
                Wr_addr = FFT_addr + N_sc ;
                RE_Valid_OUT = 1 ; 
            if (Counter > Last_indx-1) begin
                Symbol_now = Symbol_now + 1 ; 
                Sym_Done = 1 ; 
            end else begin
                Symbol_now = Symbol_now ; 
                Sym_Done = 0 ;       
            end

        end    
 
        default : current_state = IDLE ; 
     endcase    
end
// tyb 3shan mn3mlsh delay kbeer hnkhleh yktb el zeros mn el awel ely abl sib carrier starting point 

always @(posedge CLK_RE or negedge RST_RE ) begin 
   if(!RST_RE)
            DMRS_addr <= 0 ;
   else if((current_state == Map_DMRS))
            DMRS_addr <= 0 ; 
   else if((current_state == Map_DMRS) && (Counter[0] == N_sc[0]) )     
                DMRS_addr <= DMRS_addr + 1 ;                     

end

always @(posedge CLK_RE or negedge RST_RE ) begin 
    if(!RST_RE) 
            Counter <= 0 ; 
    else if (EN_Counter ) begin // hena b hot awl zeros
            Counter <= Counter +1 ; 
    end else 
            Counter <= N_sc ; 


end   

assign N_symbol = N_rb * 12 ; // de ghalat el mfrod enha a2l mstnyen rd mostafa
assign D_symbol = N_rb * 6    ;          // 3dd el dmrs kolha b2a mstnyen rd kareem 

assign Last_indx = N_sc + N_symbol -1 ; 

assign write_enable = EN_Counter ; 


endmodule