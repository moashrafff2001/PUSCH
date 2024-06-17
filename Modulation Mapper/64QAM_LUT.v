module QAM64_LUT #(parameter LUT_WIDTH = 18 )(
    input wire [5:0] Bits_In,
    input wire EN_64QAM , 
    output reg signed [LUT_WIDTH-1:0] QAM64_I,
    output reg signed [LUT_WIDTH-1:0] QAM64_Q
);

always @(EN_64QAM) begin 
  case(Bits_In[5:3]) 
// right half
    //Q1
    3'b000: begin  
        if(Bits_In[2:0]  == 3'b000) begin //(3,3)
            QAM64_I =  'b0_00000011;
            QAM64_Q =  'b0_00000011; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(3,1)
            QAM64_I =  'b0_00000011;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(1,3)
            QAM64_I =  'b0_00000001;
            QAM64_Q =  'b0_00000011; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(1,1)
            QAM64_I =  'b0_00000001;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(3,5)
            QAM64_I =  'b0_00000011;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(3,7)
            QAM64_I =  'b0_00000011;
            QAM64_Q =  'b0_00000111; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(1,5)
            QAM64_I =  'b0_00000001;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(1,7)
            QAM64_I =  'b0_00000001;
            QAM64_Q =  'b0_00000111; 
        end
    end

    3'b001: begin  
        if(Bits_In[2:0]  == 3'b000) begin //(5,3)
            QAM64_I =  'b0_00000101;
            QAM64_Q =  'b0_00000011; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(5,1)
            QAM64_I =  'b0_00000101;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(7,3)
            QAM64_I =  'b0_00000111;
            QAM64_Q =  'b0_00000011; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(7,1)
            QAM64_I =  'b0_00000111;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(5,5)
            QAM64_I =  'b0_00000101;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(5,7)
            QAM64_I =  'b0_00000101;
            QAM64_Q =  'b0_00000111; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(7,5)
            QAM64_I =  'b0_00000111;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(7,7)
            QAM64_I =  'b0_00000111;
            QAM64_Q =  'b0_00000111; 
        end 

    end
    //Q4
    3'b010: begin  
        if(Bits_In[2:0]  == 3'b000) begin //(3,-3)
            QAM64_I =  'b0_00000011;
            QAM64_Q = - 'd3; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(3,-1)
            QAM64_I =  'b0_00000011;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(1,-3)
            QAM64_I =  'b0_00000001;
            QAM64_Q = - 'd3; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(1,-1)
            QAM64_I =  'b0_00000001;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(3,-5)
            QAM64_I =  'b0_00000011;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(3,-7)
            QAM64_I =  'b0_00000011;
            QAM64_Q = - 'd7; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(1,-5)
            QAM64_I =  'b0_00000001;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(1,-7)
            QAM64_I =  'b0_00000001;
            QAM64_Q = - 'd7; 
        end
    end


    3'b011 : begin 
        if(Bits_In[2:0]  == 3'b000) begin //(5,-3)
            QAM64_I =  'b0_00000101;
            QAM64_Q = - 'd3; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(5,-1)
            QAM64_I =  'b0_00000101;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(7,-3)
            QAM64_I =  'b0_00000111;
            QAM64_Q = - 'd3; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(7,-1)
            QAM64_I =  'b0_00000111;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(5,-5)
            QAM64_I =  'b0_00000101;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(5,-7)
            QAM64_I =  'b0_00000101;
            QAM64_Q = - 'd7; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(7,-5)
            QAM64_I =  'b0_00000111;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(7,-7)
            QAM64_I =  'b0_00000111;
            QAM64_Q = - 'd7; 
        end 
    end
 
 // left quarter
    //Q2
    3'b100: begin  
        if(Bits_In[2:0]  == 3'b000) begin //(-3,3)
            QAM64_I = - 'd3;
            QAM64_Q =  'b0_00000011; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(-3,1)
            QAM64_I = - 'd3;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(-1,3)
            QAM64_I = - 'd1;
            QAM64_Q =  'b0_00000011; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(-1,1)
            QAM64_I = - 'd1;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(-3,5)
            QAM64_I = - 'd3;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(-3,7)
            QAM64_I = - 'd3;
            QAM64_Q =  'b0_00000111; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(-1,5)
            QAM64_I = - 'd1;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(-1,7)
            QAM64_I = - 'd1;
            QAM64_Q =  'b0_00000111; 
        end
    end
//
    3'b101: begin  
        if(Bits_In[2:0]  == 3'b000) begin //(-5,3)
            QAM64_I = - 'd5;
            QAM64_Q =  'b0_00000011; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(-5,1)
            QAM64_I = - 'd5;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(-7,3)
            QAM64_I = - 'd7;
            QAM64_Q =  'b0_00000011; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(-7,1)
            QAM64_I = - 'd7;
            QAM64_Q =  'b0_00000001; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(-5,5)
            QAM64_I = - 'd5;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(-5,7)
            QAM64_I = - 'd5;
            QAM64_Q =  'b0_00000111; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(-7,5)
            QAM64_I = - 'd7;
            QAM64_Q =  'b0_00000101; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(-7,7)
            QAM64_I = - 'd7;
            QAM64_Q =  'b0_00000111; 
        end 

    end
    //Q3
    3'b110: begin  
        if(Bits_In[2:0]  == 3'b000) begin //(-3,-3)
            QAM64_I = - 'd3;
            QAM64_Q = - 'd3; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(-3,-1)
            QAM64_I = - 'd3;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(-1,-3)
            QAM64_I = - 'd1;
            QAM64_Q = - 'd3; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(-1,-1)
            QAM64_I = - 'd1;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(-3,-5)
            QAM64_I = - 'd3;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(-3,-7)
            QAM64_I = - 'd3;
            QAM64_Q = - 'd7; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(-1,-5)
            QAM64_I = - 'd1;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(-1,-7)
            QAM64_I = - 'd1;
            QAM64_Q = - 'd7; 
        end
    end


    3'b111 : begin 
        if(Bits_In[2:0]  == 3'b000) begin //(-5,-3)
            QAM64_I = - 'd5;
            QAM64_Q = - 'd3; 
        end    
        if(Bits_In[2:0]  == 3'b001) begin //(-5,-1)
            QAM64_I = - 'd5;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b010) begin //(-7,-3)
            QAM64_I = - 'd7;
            QAM64_Q = - 'd3; 
        end  
        if(Bits_In[2:0]  == 3'b011) begin //(-7,-1)
            QAM64_I = - 'd7;
            QAM64_Q = - 'd1; 
        end  
        if(Bits_In[2:0]  == 3'b100) begin //(-5,-5)
            QAM64_I = - 'd5;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b101) begin //(-5,-7)
            QAM64_I = - 'd5;
            QAM64_Q = - 'd7; 
        end  
        if(Bits_In[2:0]  == 3'b110) begin //(-7,-5)
            QAM64_I = - 'd7;
            QAM64_Q = - 'd5; 
        end  
        if(Bits_In[2:0]  == 3'b111) begin //(-7,-7)
            QAM64_I = - 'd7;
            QAM64_Q = - 'd7; 
        end 
    end  
  endcase
end
endmodule

        