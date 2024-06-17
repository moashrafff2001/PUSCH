module R4_butterfly5 # (parameter WIDTH = 26 , POINTS = 1 , N = 2048)
  (
  input wire clk, rst,
  input signed [WIDTH-1:0] data_in_r,
  input signed [WIDTH-1:0] data_in_i,
  input wire VALID,
  
  output reg [11:0] radix_address,              // radix address for twiddle
  output reg [10:0] order_cnt,                  // address for IFFT Memory   
  output reg signed [WIDTH-1:0] data_out_r,
  output reg signed [WIDTH-1:0] data_out_i,
  output reg OUT_VALID
              
);

reg signed [WIDTH-1:0] reg0_r ;
reg signed [WIDTH-1:0] reg1_r ;
reg signed [WIDTH-1:0] reg2_r ;
reg signed [WIDTH-1:0] in_r   ;

reg signed [WIDTH-1:0] reg0_i ;
reg signed [WIDTH-1:0] reg1_i ;
reg signed [WIDTH-1:0] reg2_i ;
reg signed [WIDTH-1:0] in_i   ;

reg signed [WIDTH-1:0] out0_r ;
reg signed [WIDTH-1:0] out1_r ;
reg signed [WIDTH-1:0] out2_r ;
reg signed [WIDTH-1:0] out3_r ;

reg signed [WIDTH-1:0] out0_i ;
reg signed [WIDTH-1:0] out1_i ;
reg signed [WIDTH-1:0] out2_i ;
reg signed [WIDTH-1:0] out3_i ;

reg signed [WIDTH-1:0] out1_data_reversed_r [0:1023];
reg signed [WIDTH-1:0] out1_data_reversed_i [0:1023];
reg signed [WIDTH-1:0] out2_data_reversed_r [0:1023];
reg signed [WIDTH-1:0] out2_data_reversed_i [0:1023];
reg signed [WIDTH-1:0] mem_out_r [0:N-1];
reg signed [WIDTH-1:0] mem_out_i [0:N-1];
reg signed [WIDTH-1:0] op_out_r;
reg signed [WIDTH-1:0] op_out_i;

reg full;             // Signal is high after every storing/operating data 
reg End_operation;    // Signal is high after storing all points data (N * 3) (256 * 3) 
reg SDF_DONE;         // Signal indicate that SDF Control Unit has done for 2048 POINTS
reg start;
reg store_out;
reg out_ready;

reg [2:0] cnt;

reg [2:0] cs,ns;

reg [20:0] counter_points;  // 2048 counter 
// reg [10:0] order_cnt;       // 2048 counter for tracing 2048 point output
// reg [11:0] radix_address; 
reg [10:0] order_cnt2;
wire [10:0] reverse_order; 

localparam IDLE       = 3'b000;    // IDLE mode
localparam MODE1      = 3'b001;    // store data in reg0
localparam MODE2      = 3'b010;    // store data in reg1
localparam MODE3      = 3'b011;    // store data in reg2
localparam MODE4      = 3'b100;    // Butterfly Operation & store data in reg0/reg1/reg2
localparam MODE5      = 3'b101;    // Butterfly Operation & store data in reg0/reg1/reg2

integer i , j ;

always @(posedge clk or negedge rst) begin
  if(!rst) begin
     counter_points <= 0;
     End_operation  <= 0;     
     SDF_DONE       <= 0;
     out_ready      <= 0;
     OUT_VALID      <= 0;
     cs             <= IDLE;
     radix_address  <= 0;
     cnt            <= 0;
     order_cnt      <= 0;
     order_cnt2     <= 0;
     start          <= 0;
     store_out      <= 0;

        for (j = 0; j < N; j = j + 1) begin
            out1_data_reversed_r[j] <= 0;
            out1_data_reversed_i[j] <= 0;
            out2_data_reversed_r[j] <= 0;
            out2_data_reversed_i[j] <= 0;            
            mem_out_r[j]            <= 0;
            mem_out_i[j]            <= 0;
            op_out_r[j]             <= 0;
            op_out_i[j]             <= 0;                   
        end
            reg0_r <= 0;
            reg0_i <= 0;
            reg1_r <= 0;
            reg1_i <= 0;
            reg2_r <= 0;
            reg2_i <= 0;
            in_r   <= 0;
            in_i   <= 0;

            out0_r <= 0;
            out0_i <= 0;
            out1_r <= 0;
            out1_i <= 0;
            out2_r <= 0;
            out2_i <= 0;
            out3_r <= 0;
            out3_i <= 0;                    

  end else begin
    cs <= ns ;
        if (cs == MODE1 || cs == MODE2 || cs == MODE3 || cs == MODE4 || cs == MODE5 || cs == IDLE) begin   
            if (counter_points == (N*10)-1) begin
                counter_points <= 0;
            end else begin
                counter_points <= counter_points + 1 ;
            end
            if (cnt == 3) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1 ;
            end            
        end else begin
            counter_points <= 0;
        end
            if (cs == MODE5) begin
                if (order_cnt == 2047) begin
                    OUT_VALID <= 0;
                end else begin
                    OUT_VALID <= 1; 
                end  
            end else begin
                    OUT_VALID <= 0;                
            end          

        if (counter_points == 0 || counter_points == 1 || counter_points == 2) begin
            order_cnt  <= 0;          
        end else begin
            if (order_cnt == 2047) begin
                order_cnt  <= 0;
                store_out <= 0;
            end else if (order_cnt == 1023) begin
                store_out  <= 1;
                order_cnt  <= order_cnt +1;             
            end else if (order_cnt == 1022) begin
                start <= 1;
                order_cnt <= order_cnt +1;                               
            end else begin
                order_cnt <= order_cnt +1;                
            end
        end
        if (start) begin
            if (order_cnt2 == 1023) begin
                order_cnt2 <= 0;
                start <= 0;
            end else if (order_cnt == 1023) begin
                order_cnt2 <= 0;         
            end else begin
                order_cnt2 <= order_cnt2 +1;
            end
        end else begin
            order_cnt2 <= 0;
        end              

    end
end


// SDF Stage-4 Radix-4 Butterfly Operation
always @(*) begin 

    case (cs)

        IDLE: begin
                full = 0;
                counter_points = 0;
                cnt = 0;
                End_operation  = 0;     
                SDF_DONE       = 0;
                out_ready      = 0;
                radix_address  = 0;
                start          = 0;
                OUT_VALID      = 0;                                
                    if (VALID) begin
                        reg0_r = data_in_r;           // second 4 point 
                        reg0_i = data_in_i ;                         
                        ns = MODE2 ; 
                    end else begin
                        ns = IDLE ;                                                
                    end
                end
                
        MODE1: begin
            radix_address = 0;

                    if (!SDF_DONE) begin
                        if (End_operation) begin

                            op_out_r = out0_r;
                            op_out_i = out0_i;

                            op_out_r = op_out_r >>> 11;
                            op_out_i = op_out_i >>> 11;                             

                            if (!store_out) begin
                                out1_data_reversed_r[reverse_order] = op_out_r ;
                                out1_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                                
                            end else begin
                                out2_data_reversed_r[reverse_order] = op_out_r ;
                                out2_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                        
                            end                             

                            reg0_r = data_in_r ;           // second 4 point 
                            reg0_i = data_in_i ;
                            ns   = MODE2; 

                        end else begin
                            reg0_r = data_in_r ;
                            reg0_i = data_in_i ;
                            ns = MODE2;
                       
                        end
                    end else begin
                            op_out_r = out0_r;
                            op_out_i = out0_i;

                            op_out_r = op_out_r >>> 11;
                            op_out_i = op_out_i >>> 11;

                            if (!store_out) begin
                                out1_data_reversed_r[reverse_order] = op_out_r ;
                                out1_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                                
                            end else begin
                                out2_data_reversed_r[reverse_order] = op_out_r ;
                                out2_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                        
                            end                              

                            ns   = MODE2;                                                                                                          
                    end              
                end

        MODE2: begin
            radix_address = 0;
                    if (!SDF_DONE) begin            
                        if (End_operation) begin

                            op_out_r = out1_r;
                            op_out_i = out1_i;

                            op_out_r = op_out_r >>> 11;
                            op_out_i = op_out_i >>> 11;                             

                            if (!store_out) begin
                                out1_data_reversed_r[reverse_order] = op_out_r ;
                                out1_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                                
                            end else begin
                                out2_data_reversed_r[reverse_order] = op_out_r ;
                                out2_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                        
                            end                             
                               
                            reg1_r = data_in_r ;
                            reg1_i = data_in_i ;
                            ns   = MODE3; 

                        end else begin
                            reg1_r = data_in_r ;
                            reg1_i = data_in_i ;
                            ns   = MODE3;
                        end
                    end else begin
                            op_out_r = out1_r;
                            op_out_i = out1_i;

                            op_out_r = op_out_r >>> 11;
                            op_out_i = op_out_i >>> 11;

                            if (!store_out) begin
                                out1_data_reversed_r[reverse_order] = op_out_r ;
                                out1_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                                
                            end else begin
                                out2_data_reversed_r[reverse_order] = op_out_r ;
                                out2_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                        
                            end                              

                            ns   = MODE3;                                                                                                          
                    end              
                end

        MODE3: begin
            radix_address = 0;

                    if (!SDF_DONE) begin
                        if (End_operation) begin 
                            op_out_r = out2_r;
                            op_out_i = out2_i;

                            op_out_r = op_out_r >>> 11;
                            op_out_i = op_out_i >>> 11;                             

                            if (!store_out) begin
                                out1_data_reversed_r[reverse_order] = op_out_r ;
                                out1_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                                
                            end else begin
                                out2_data_reversed_r[reverse_order] = op_out_r ;
                                out2_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                        
                            end                            

                            reg2_r = data_in_r ;
                            reg2_i = data_in_i ;
            
                            ns   = MODE4;
                            End_operation = 0;                                                
                        end else begin
                            reg2_r = data_in_r ;
                            reg2_i = data_in_i ;                           
                            ns = MODE4;
                      
                        end
                    end else begin
                            op_out_r = out2_r;
                            op_out_i = out2_i;

                            op_out_r = op_out_r >>> 11;
                            op_out_i = op_out_i >>> 11;

                            if (!store_out) begin
                                out1_data_reversed_r[reverse_order] = op_out_r ;
                                out1_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                                
                            end else begin
                                out2_data_reversed_r[reverse_order] = op_out_r ;
                                out2_data_reversed_i[reverse_order] = op_out_i ;
                                mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                                mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                        
                            end                                                     

                            if (order_cnt == (N-1)) begin
                                SDF_DONE = 0;
                                out_ready = 1;
                                ns   = MODE5;
                            end else begin
                                ns   = MODE3;
                            end                         
                    end               
                end

        MODE4: begin
            radix_address = 0;
                    in_r = data_in_r ;
                    in_i = data_in_i ;                

                    out0_r = reg0_r + reg1_r + reg2_r + in_r;
                    out1_r = reg0_r + reg1_i - reg2_r - in_i;
                    out2_r = reg0_r - reg1_r + reg2_i - in_i;
                    out3_r = reg0_r - reg1_i - reg2_r + in_i;

                    out0_i = reg0_i + reg1_i + reg2_i + in_i;
                    out1_i = reg0_i - reg1_r - reg2_i + in_r ;
                    out2_i = reg0_i - reg1_i - reg2_r + in_r ;
                    out3_i = reg0_i + reg1_r - reg2_i - in_r ;

                    op_out_r = out3_r ;
                    op_out_r = op_out_r >>> 11;

                    op_out_i = out3_i ;
                    op_out_i = op_out_i >>> 11;

                    if (!store_out) begin
                        out1_data_reversed_r[reverse_order] = op_out_r ;
                        out1_data_reversed_i[reverse_order] = op_out_i ;
                        mem_out_r[reverse_order] = out1_data_reversed_r[reverse_order];
                        mem_out_i[reverse_order] = out1_data_reversed_i[reverse_order];                        
                    end else begin
                        out2_data_reversed_r[reverse_order] = op_out_r ;
                        out2_data_reversed_i[reverse_order] = op_out_i ;
                        mem_out_r[reverse_order+1024] = out2_data_reversed_r[reverse_order];
                        mem_out_i[reverse_order+1024] = out2_data_reversed_i[reverse_order];                                                 
                    end                       
                                       
                    End_operation = 1;
                                                   
                    if (cnt == 3 && counter_points !== (N-1)) begin
                        ns = MODE1;
                    end else if (cnt == 3 && counter_points == N-1) begin 
                        SDF_DONE = 1;
                        ns = MODE1;                              
                    end else begin
                        ns = MODE4;
                    end             
                end

        MODE5 : begin
                OUT_VALID = 1;                         
                    if (order_cnt == 0) begin
                    data_out_r = mem_out_r[0];
                    data_out_i = mem_out_i[0];
                    ns = MODE5;
                    end else if (order_cnt == 2047) begin
                    // OUT_VALID = 0;    
                    ns = IDLE;  
                    data_out_r = mem_out_r[order_cnt];   
                    data_out_i = mem_out_i[order_cnt];  
                    end else begin
                    data_out_r = mem_out_r[order_cnt];   
                    data_out_i = mem_out_i[order_cnt];
                    ns = MODE5;                        
                    end
                end                                                                                                               
    
        default : begin
                    ns = IDLE;
                  end
    endcase   
end

// Bit Reversal order
assign reverse_order = {order_cnt[1],order_cnt[0],order_cnt[3],order_cnt[2],order_cnt[5],order_cnt[4],order_cnt[7],order_cnt[6],order_cnt[9],order_cnt[8]};

endmodule
