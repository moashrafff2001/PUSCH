module R4_butterfly3 # (parameter WIDTH = 26 , POINTS = 16 , N = 2048)
  (
  input wire clk, rst,
  input signed [WIDTH-1:0] data_in_r,
  input signed [WIDTH-1:0] data_in_i,
  input wire VALID,
  
  output reg [11:0] radix_address,
  output reg OUT_VALID,                             /// Signal indicate that first serial out is ready to go to next block R4-2
  output reg signed [WIDTH-1:0] data_out_r,
  output reg signed [WIDTH-1:0] data_out_i
              
);

reg signed [WIDTH-1:0] reg0_r [0:POINTS-1];
reg signed [WIDTH-1:0] reg1_r [0:POINTS-1];
reg signed [WIDTH-1:0] reg2_r [0:POINTS-1];
reg signed [WIDTH-1:0] in_r   [0:POINTS-1];

reg signed [WIDTH-1:0] reg0_i [0:POINTS-1];
reg signed [WIDTH-1:0] reg1_i [0:POINTS-1];
reg signed [WIDTH-1:0] reg2_i [0:POINTS-1];
reg signed [WIDTH-1:0] in_i   [0:POINTS-1];

reg signed [WIDTH-1:0] out0_r [0:POINTS-1];
reg signed [WIDTH-1:0] out1_r [0:POINTS-1];
reg signed [WIDTH-1:0] out2_r [0:POINTS-1];
reg signed [WIDTH-1:0] out3_r [0:POINTS-1];

reg signed [WIDTH-1:0] out0_i [0:POINTS-1];
reg signed [WIDTH-1:0] out1_i [0:POINTS-1];
reg signed [WIDTH-1:0] out2_i [0:POINTS-1];
reg signed [WIDTH-1:0] out3_i [0:POINTS-1];
  
reg full;             // Signal is high after every storing/operating data 
reg End_operation;    // Signal is high after storing all points data (N * 3) (256 * 3) 
reg SDF_DONE;         // Signal indicate that SDF Control Unit has done for 2048 POINTS
reg OUT_Done;         // Signal indicate that SDF OUTPUT is READY

reg [2:0] cs,ns;

reg [7:0] counter;
reg [11:0] counter_points;  // 2048 counter for tracing 2048 point output

localparam IDLE       = 3'b000;    // IDLE mode
localparam MODE1      = 3'b001;    // store data in reg0
localparam MODE2      = 3'b010;    // store data in reg1
localparam MODE3      = 3'b011;    // store data in reg2
localparam MODE4      = 3'b100;    // Butterfly Operation & store data in reg0/reg1/reg2

integer i ;

always @(posedge clk or negedge rst) begin
  if(!rst) begin
     counter        <= 0;
     counter_points <= 0;
     End_operation  <= 0;     
     SDF_DONE       <= 0;
     OUT_Done       <= 0;
     OUT_VALID      <= 0;
     cs             <= IDLE;
     radix_address  <= 0;

        for (i = 0; i < POINTS; i = i + 1) begin
            reg0_r[i] <= 0;
            reg0_i[i] <= 0;
            reg1_r[i] <= 0;
            reg1_i[i] <= 0;
            reg2_r[i] <= 0;
            reg2_i[i] <= 0;
            in_r[i]   <= 0;
            in_i[i]   <= 0;

            out0_r[i] <= 0;
            out0_i[i] <= 0;
            out1_r[i] <= 0;
            out1_i[i] <= 0;
            out2_r[i] <= 0;
            out2_i[i] <= 0;
            out3_r[i] <= 0;
            out3_i[i] <= 0;                      
        end

  end else begin
    cs <= ns ;

        if (cs == MODE1 || cs == MODE2 || cs == MODE3 || cs == MODE4 || cs == IDLE) begin   
            if (counter == (POINTS-1)) begin
                counter <= 0;
                full <= 1;      
            end else begin
                counter <= counter + 1;
                full <= 0;
            end
            if (counter_points == (N-1)) begin
                counter_points <= 0;
            end else begin
                counter_points <= counter_points + 1 ;
            end
        end else begin
            counter <= 0;
        end

        if (cs==MODE1 && End_operation) begin
            if (radix_address == 16*(POINTS-1)) begin
                radix_address <= 0;
            end else begin
                radix_address <= radix_address + 16;
            end
        end else if (cs==MODE2 && End_operation) begin
            if (radix_address == 32*(POINTS-1)) begin
                radix_address <= 0;
            end else begin
                radix_address <= radix_address + 32;
            end
        end else if (cs==MODE3 && End_operation) begin
            if (radix_address == 48*(POINTS-1)) begin
                radix_address <= 0;
            end else begin
                radix_address <= radix_address + 48;
            end
        end else begin
            radix_address <= 0;
        end

    end
end


// SDF Stage-4 Radix-4 Butterfly Operation
always @(*) begin 

    case (cs)

        IDLE: begin
                full = 0;
                counter        = 0;
                counter_points = 0;                   
                SDF_DONE       = 0;
                OUT_Done      = 0;                                
                    if (VALID) begin
                        reg0_r[counter] = data_in_r ;           // second 4 point 
                        reg0_i[counter] = data_in_i ;                                              
                        ns = MODE1 ; 
                    end else begin
                        ns = IDLE ;
                    end
                end
                
        MODE1: begin
                    if (!SDF_DONE) begin
                        if (End_operation) begin 
                            data_out_r = out0_r[counter];
                            data_out_i = out0_i[counter];

                            reg0_r[counter] = data_in_r ;           // second 4 point 
                            reg0_i[counter] = data_in_i ;
                         
                            if (counter == (POINTS-1)) begin
                                ns   = MODE2;
                            end else begin
                                ns   = MODE1;
                            end                        
                        end else begin
                            reg0_r[counter] = data_in_r ;
                            reg0_i[counter] = data_in_i ;
                            if (counter == (POINTS-1)) begin
                                ns = MODE2;
                            end else begin
                                ns = MODE1;
                            end                        
                        end
                    end else begin
                            data_out_r = out0_r[counter];
                            data_out_i = out0_i[counter];                         

                            if (counter == (POINTS-1)) begin
                                ns   = MODE2;
                            end else begin
                                ns   = MODE1;
                            end                                                                                                           
                    end              
                end

        MODE2: begin
                    if (!SDF_DONE) begin            
                        if (End_operation) begin 
                            data_out_r = out1_r[counter];
                            data_out_i = out1_i[counter];

                            reg1_r[counter] = data_in_r ;
                            reg1_i[counter] = data_in_i ;                        
                            if (counter == (POINTS-1)) begin
                                ns = MODE3;
                            end else begin
                                ns = MODE2;
                            end                        
                        end else begin
                            reg1_r[counter] = data_in_r ;
                            reg1_i[counter] = data_in_i ;
                            if (counter == (POINTS-1)) begin
                                ns = MODE3;
                            end else begin
                                ns = MODE2;
                            end                        
                        end
                    end else begin
                            data_out_r = out1_r[counter];
                            data_out_i = out1_i[counter];                          

                            if (counter == (POINTS-1)) begin
                                ns   = MODE3;
                            end else begin
                                ns   = MODE2;
                            end                                                                                                           
                    end              
                end

        MODE3: begin
                    if (!SDF_DONE) begin
                        if (End_operation) begin 
                            data_out_r = out2_r[counter];
                            data_out_i = out2_i[counter];

                            reg2_r[counter] = data_in_r ;
                            reg2_i[counter] = data_in_i ;                        
                            if (counter == (POINTS-1)) begin
                                ns   = MODE4;
                                End_operation = 0;                          
                            end else begin
                                ns   = MODE3;
                            end                        
                        end else begin
                            reg2_r[counter] = data_in_r ;
                            reg2_i[counter] = data_in_i ;
                            if (counter == (POINTS-1)) begin
                                ns = MODE4;
                            end else begin
                                ns = MODE3;
                            end                        
                        end
                    end else begin
                            data_out_r = out2_r[counter];
                            data_out_i = out2_i[counter];                         

                            if (counter == (POINTS-1)) begin
                                SDF_DONE  = 0;
                                OUT_Done  = 1;
                                OUT_VALID = 0;
                                ns   = IDLE;
                            end else begin
                                ns   = MODE3;
                            end                         
                    end               
                end

        MODE4: begin
                    in_r[counter]   = data_in_r ;
                    in_i[counter]   = data_in_i ;

                    out0_r[counter] = reg0_r[counter] + reg1_r[counter] + reg2_r[counter] + in_r[counter];
                    out1_r[counter] = reg0_r[counter] + reg1_i[counter] - reg2_r[counter] - in_i[counter];
                    out2_r[counter] = reg0_r[counter] - reg1_r[counter] + reg2_i[counter] - in_i[counter];
                    out3_r[counter] = reg0_r[counter] - reg1_i[counter] - reg2_r[counter] + in_i[counter];

                    out0_i[counter] = reg0_i[counter] + reg1_i[counter] + reg2_i[counter] + in_i[counter];
                    out1_i[counter] = reg0_i[counter] - reg1_r[counter] - reg2_i[counter] + in_r[counter];
                    out2_i[counter] = reg0_i[counter] - reg1_i[counter] - reg2_r[counter] + in_r[counter];
                    out3_i[counter] = reg0_i[counter] + reg1_r[counter] - reg2_i[counter] - in_r[counter];

                    data_out_r      = out3_r[counter];
                    data_out_i      = out3_i[counter];

                    End_operation = 1;

                    OUT_VALID = 1;                                                                              
                                                
                    if (counter == (POINTS-1) && counter_points !== (N-1)) begin
                        ns = MODE1;
                    end else if (counter == (POINTS-1) && counter_points == (N-1)) begin 
                        SDF_DONE = 1;
                        ns = MODE1;                              
                    end else begin
                        ns = MODE4;
                    end             
                end                                                                                               
    
        default : begin
                    ns = MODE1;
                  end
    endcase   
end
endmodule

// 0-256
// 64-127 &(64-64) * 4 * 2