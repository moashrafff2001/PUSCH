module QAM16_LUT#(parameter LUT_WIDTH = 18 ) (
    input wire [3:0] Bits_In,
    input wire EN_QAM16 , 
    output reg signed [LUT_WIDTH-1:0] QAM16_I,
    output reg signed [LUT_WIDTH-1:0] QAM16_Q
);

always @(EN_QAM16) begin
 case( Bits_In[3:2] )

    2'b00 : begin 
        if(Bits_In[1:0] == 2'b00)begin //(1,1)
            QAM16_I =  'd1;
            QAM16_Q =  'd1;    
        end  
        else if(Bits_In[1:0] == 2'b01)begin //(1,3)
            QAM16_I =  'd1;
            QAM16_Q =  'd3; 
        end
        else if(Bits_In[1:0] ==2'b11 )begin //(3,1)
            QAM16_I =  'd3;
            QAM16_Q =  'd3; 
        end
        else if(Bits_In[1:0] ==2'b10 )begin //(3,3)
            QAM16_I =  'd3;
            QAM16_Q =  'd1;
        end
    end 

    2'b01 : begin  
        if(Bits_In[1:0] == 2'b00)begin //(1,-1)
            QAM16_I =  'd1;
            QAM16_Q = - 'd1 ;    
        end  
        else if(Bits_In[1:0] == 2'b01)begin //(1,-3)
            QAM16_I =  'd1;
            QAM16_Q = - 'd3; 
        end
        else if(Bits_In[1:0] == 2'b10)begin //(3,-1)
            QAM16_I =  'd3;
            QAM16_Q = - 'd1; 
        end
        else if(Bits_In[1:0] == 2'b11)begin //(3,-3)
            QAM16_I =  'd3;
            QAM16_Q = - 'd3;
        end
    end 

    2'b10 : begin
        if(Bits_In[1:0] == 2'b00)begin //(-1,1)
            QAM16_I = - 'd1;
            QAM16_Q =  'd1;    
        end  
        else if(Bits_In[1:0] == 2'b01)begin //(-1,3)
            QAM16_I = - 'd1;
            QAM16_Q =  'd3; 
        end
        else if(Bits_In[1:0] == 2'b10)begin //(-3,1)
            QAM16_I = - 'd3;
            QAM16_Q =  'd1; 
        end
        else if(Bits_In[1:0] == 2'b11)begin //(-3,3)
            QAM16_I = - 'd3;
            QAM16_Q =  'd3;
        end
    end
    
    2'b11 : begin 
        if(Bits_In[1:0] == 2'b00)begin //(-1,-1)
            QAM16_I = - 'd1;
            QAM16_Q = - 'd1;    
        end  
        else if(Bits_In[1:0] == 2'b01)begin //(-1,-3)
            QAM16_I = - 'd1;
            QAM16_Q = - 'd3; 
        end
        else if(Bits_In[1:0] == 2'b10)begin //(-3,-1)
            QAM16_I = - 'd3;
            QAM16_Q = - 'd1; 
        end
        else if(Bits_In[1:0] == 2'b11)begin //(-3,-3)
            QAM16_I = - 'd3;
            QAM16_Q = - 'd3;
        end
    end
        default: begin // Default mapping to (0, 0)
            QAM16_I =  'b0_00000000;
            QAM16_Q =  'b0_00000000;
        end
    endcase
end
endmodule