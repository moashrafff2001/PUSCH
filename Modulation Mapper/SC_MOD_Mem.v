module SC_MOD_Mem(
    input wire CLK , 
    input wire RST ,
    input wire Done ,
    input wire SC_IN ,
    input wire SC_Valid ,
    output wire [5:0] Mod_IN // max 6 bit input to mod if 64QAM
);

reg [6:0] Mod_Reg ; 
reg IN ; 

always@(posedge CLK or negedge RST) begin
    if(!RST) begin
        Mod_Reg <= 'b0;
    end
    else if(Done && SC_Valid) begin // if counter counts order bits    
       // Mod_Reg <= {SC_IN, 6'b0} ;
       Mod_Reg <= Mod_Reg >> 1 ;
       Mod_Reg[6] <= SC_IN ; 
       Mod_Reg[4:0] <= 5'b0 ; 
    end
    else if (Done && ! SC_Valid)begin
        Mod_Reg[6:0] <= 'b0 ;
    end 
    else if (!Done && ! SC_Valid)begin
        Mod_Reg[5:0] <= 'b0 ;
        Mod_Reg[6] <= SC_IN;
    end     
    else if(SC_Valid)begin // buffer input bits till Done
        Mod_Reg <= {SC_IN, Mod_Reg[6:1]};
    end 
           
    

end
assign Mod_IN = Mod_Reg[5:0]; // Combinational output assignment

endmodule