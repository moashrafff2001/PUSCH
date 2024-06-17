module CyclicPrefix #(parameter WIDTH = 26, IFFT_SIZE = 2048, N_SYMB = 14, N_SUBFRAME = 1, NCP1 = 160 , NCP2 = 144 )
(
    input   signed   clk,
    input   signed   rst,
    input   wire   VALID,
    input   wire valid_in,
    input   wire [7:0] counter4,
    output  reg    OUT_VALID,
    input wire  signed  [WIDTH-1:0] data_in_r,
    input wire  signed  [WIDTH-1:0] data_in_i,    
    output reg  signed  [WIDTH-1:0] data_out_r,
    output reg  signed  [WIDTH-1:0] data_out_i    
);

reg signed [WIDTH-1:0] memory_r      [0:(N_SYMB*N_SUBFRAME)-1][0:IFFT_SIZE-1] ;         // 14x2048 - 26bit   input real one subframe 
reg signed [WIDTH-1:0] memory_i      [0:(N_SYMB*N_SUBFRAME)-1][0:IFFT_SIZE-1] ;         // 14x2048 - 26bit   input imaj one subframe 
reg signed [WIDTH-1:0] memory_out_r  [0:(N_SYMB*N_SUBFRAME)-1][0:(IFFT_SIZE+NCP1)-1] ;  // 14x2208 - 26bit   out1 real memory 
reg signed [WIDTH-1:0] memory_out_i  [0:(N_SYMB*N_SUBFRAME)-1][0:(IFFT_SIZE+NCP1)-1] ;  // 14x2208 - 26bit   out1 imaj memory
reg signed [WIDTH-1:0] memory_out2_r [0:(N_SYMB*N_SUBFRAME)-1][0:(IFFT_SIZE+NCP2)-1] ;  // 14x2192 - 26bit   out2 real memory
reg signed [WIDTH-1:0] memory_out2_i [0:(N_SYMB*N_SUBFRAME)-1][0:(IFFT_SIZE+NCP2)-1] ;  // 14x2192 - 26bit   out2 imaj memory

reg [10:0] counter;
reg [11:0] counter2;        // counter for symbols 1-14 except 0,7  -- 2048+144 = 2192
reg [11:0] counter3;        // counter for symbols 0,7              -- 2048+160 = 2208  
reg [3:0]  counter1;        // counter for symbols 14 symbols
// reg [11:0] counter4;        // counter for tracing input memory
reg [10:0] counter5;        // General counter //

reg ready;
reg mem_valid;

integer i , j ;

//  Sequential always
always @(posedge clk or negedge rst) begin 
    if(!rst) begin
         counter   <= 0;
         counter1  <= 0;
         counter2  <= 0;
         counter3  <= 0; 
         // counter4  <= 0;
         counter5  <= 0;
         ready     <= 0;
        for (i = 0; i < N_SYMB*N_SUBFRAME; i = i + 1) begin    
            for (j = 0; j < IFFT_SIZE; j = j + 1) begin
                memory_r[i][j] <= 0;
                memory_i[i][j] <= 0;           
            end
        end
    end else begin         
            if (counter4 == 1 || counter4 == 8) begin
                if (VALID) begin
                    if (valid_in) begin
                        counter <= counter +1;
                    end else begin
                        counter <= 0;
                    end
                    counter3 <= 0;          
                end else begin
                    counter   <= counter +1;
                    if (ready) begin
                        if (counter == NCP1-1 && ready == 1 && counter3 == 2207) begin
                            counter3 <= 0;
                            counter  <= 0;
                            ready    <= 0;
                        end else begin
                            counter3 <= counter3 +1;
                        end                         
                    end else begin // 
                        counter  <= 0;
                        counter3 <= counter3;
                    end                   
                    counter2  <= 0;                
                end
            end else if (counter4 == 0) begin
                counter <= 0;
            end else begin
                if (VALID) begin
                    if (valid_in) begin
                        counter <= counter +1;
                    end else begin
                        counter <= 0;
                    end
                    counter2 <= 0;          
                end else begin
                    counter   <= counter +1;
                    if (ready) begin
                        if (counter == NCP2-1 && ready == 1 && counter2 == 2191) begin
                            counter2 <= 0;
                            counter  <= 0;
                            ready    <= 0;
                        end else begin
                            counter2 <= counter2 +1;
                        end                         
                    end else begin // 
                        counter  <= 0;
                        counter2 <= counter2;
                    end                   
                    counter3  <= 0;                
                end                
            end 
    end
end

// Comp always
always @(*)
  begin
    if (valid_in) begin
        memory_r[counter4-1][counter] = data_in_r;                           // mem[1-14][0-2048]
        memory_i[counter4-1][counter] = data_in_i;
        ready = 1; 
    end else begin
        memory_r[counter4-1][counter] = memory_r[counter4-1][counter];                           
        memory_i[counter4-1][counter] = memory_i[counter4-1][counter];     
    end
    if (counter4 == 1 || counter4 == 8) begin  
            if (counter < 1888) begin
                memory_out_r[counter4-1][counter+(NCP1)] = memory_r[counter4-1][counter];             // out (160-2047)
                memory_out_i[counter4-1][counter+(NCP1)] = memory_i[counter4-1][counter]; 
            end else begin
                memory_out_r[counter4-1][counter-(IFFT_SIZE-NCP1)] = memory_r[counter4-1][counter];   // out (0-159)  
                memory_out_i[counter4-1][counter-(IFFT_SIZE-NCP1)] = memory_i[counter4-1][counter];
                memory_out_r[counter4-1][counter+(NCP1)] = memory_r[counter4-1][counter];             // out (2048-2207) 
                memory_out_i[counter4-1][counter+(NCP1)] = memory_i[counter4-1][counter];                               
            end
    end else if (counter4 == 15) begin
            memory_out_r[counter4-1][counter3]  = 0; 
            memory_out_i[counter4-1][counter3]  = 0;
            memory_out2_r[counter4-1][counter2] = 0; 
            memory_out2_i[counter4-1][counter2] = 0;            
    end else begin
        if (counter < 1904) begin
            memory_out2_r[counter4-1][counter+(NCP2)] = memory_r[counter4-1][counter];             // out (144-2047)
            memory_out2_i[counter4-1][counter+(NCP2)] = memory_i[counter4-1][counter]; 
        end else begin
            memory_out2_r[counter4-1][counter-(IFFT_SIZE-NCP2)] = memory_r[counter4-1][counter];   // out (0-143) 
            memory_out2_i[counter4-1][counter-(IFFT_SIZE-NCP2)] = memory_i[counter4-1][counter];
            memory_out2_r[counter4-1][counter+(NCP2)] = memory_r[counter4-1][counter];             // out (2048-2191)
            memory_out2_i[counter4-1][counter+(NCP2)] = memory_i[counter4-1][counter];                               
        end    
    end

    if (VALID == 0 && !valid_in) begin
        if (ready == 0) begin
            data_out_r =data_out_r;
            data_out_i =data_out_i;
            OUT_VALID = 0;
        end else begin
            OUT_VALID = 1;
            if (counter4 == 1 || counter4 == 8) begin
                data_out_r = memory_out_r[counter4-1][counter3]; 
                data_out_i = memory_out_i[counter4-1][counter3];         
            end else begin
                data_out_r = memory_out2_r[counter4-1][counter2]; 
                data_out_i = memory_out2_i[counter4-1][counter2];         
            end            
        end
    end else begin
        data_out_r =data_out_r;
        data_out_i =data_out_i;
        OUT_VALID = 0;
    end


end  

endmodule