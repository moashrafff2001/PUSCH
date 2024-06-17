module R2_butterfly # (parameter WIDTH = 26 , POINTS = 1024 , N = 2048)
    (
  input wire clk, rst,
  input signed [WIDTH-1:0] data_in_r  ,
  input signed [WIDTH-1:0] data_in_i  ,
  input wire VALID,

  output reg [11:0] radix_address,                /// radix address
  output reg OUT_VALID,                           /// Signal indicate that first serial out is ready to go to next block R4-1
  output reg signed [WIDTH-1:0] data_out_r ,
  output reg signed [WIDTH-1:0] data_out_i            
);

reg signed [WIDTH-1:0] shift_reg_r [0:POINTS-1];            // Shift register storing data input REAL    
reg signed [WIDTH-1:0] shift_reg_i [0:POINTS-1];            // Shift register storing data input IMAJ  

reg signed [WIDTH-1:0] addition_part_r [0:POINTS-1];        // REAL Additional part output from Butterfly  
reg signed [WIDTH-1:0] addition_part_i [0:POINTS-1];        // IMAJ Additional part output from Butterfly 

reg signed [WIDTH-1:0] subtraction_part_r [0:POINTS-1];     // REAL Subtraction part output from Butterfly  
reg signed [WIDTH-1:0] subtraction_part_i [0:POINTS-1];     // IMAJ Subtraction part output from Butterfly 

reg signed [WIDTH-1:0] out1_data_reversed_r [0:1023];
reg signed [WIDTH-1:0] out1_data_reversed_i [0:1023];
reg signed [WIDTH-1:0] out2_data_reversed_r [0:1023];
reg signed [WIDTH-1:0] out2_data_reversed_i [0:1023];
reg signed [WIDTH-1:0] mem_out_r [0:N-1];
reg signed [WIDTH-1:0] mem_out_i [0:N-1];

reg signed [WIDTH-1:0] out_proc_r;                          // serial processing output real
reg signed [WIDTH-1:0] out_proc_i;                          // serial processing output imaj

reg [9:0] counter;
reg [10:0] counterin;
reg [11:0] counter1;
reg [7:0] cntt;
wire [10:0] reverse_order;

reg full;                                    // Signal is high after storing first 1024 data 
reg done;                                    // Signal is high after First part (1024) output is done 
reg SDF_DONE;                                // Signal indicate that SDF Control Unit Stage 1 has done for 2048 POINTS Radix-2  
reg store_out;                               // storing out1,out2 reversed order
reg sec_half;                                // second alf data out begin
reg radix_valid;                             // valid for radix address to begin count
                             

reg [1:0] cs,ns;

localparam IDLE  = 2'b00;                   // IDLE MODE indicate if input data is valid or not to begin processing
localparam MODE1 = 2'b01;                   // MODE 1 For storing first half data (0-1023)
localparam MODE2 = 2'b10;                   // MODE 2 For Radix-2 butterfly operation and storing first half output data 
localparam MODE3 = 2'b11;                   // MODE 3 For storing second half data (1024-2047)

integer i , j ;

always @(posedge clk or negedge rst) begin 
    if(!rst) begin
         counter   <= 0;
         counter1  <= 0;
         counterin <= 0;
         full      <= 0;
         done      <= 0;
         SDF_DONE  <= 0;
         store_out <= 0;
         sec_half  <= 0;
         OUT_VALID <= 0;
         cntt      <= 0;
         radix_address  <= 0;
         out_proc_r <= 0;
         out_proc_i <= 0;                  
        for (i = 0; i < POINTS; i = i + 1) begin
            shift_reg_r[i]        <= 0;
            shift_reg_i[i]        <= 0;
            addition_part_r[i]    <= 0;
            addition_part_i[i]    <= 0;
            subtraction_part_r[i] <= 0;
            subtraction_part_i[i] <= 0;            
        end
        for (j = 0; j < N; j = j + 1) begin
            out1_data_reversed_r[j] <= 0;
            out1_data_reversed_i[j] <= 0;
            out2_data_reversed_r[j] <= 0;
            out2_data_reversed_i[j] <= 0;            
            mem_out_r[j]            <= 0;
            mem_out_i[j]            <= 0;                    
        end
        cs <= IDLE;
    end else begin
        cs <= ns ;

         if (cs==MODE1) begin
            if(counter == (POINTS-1)) begin
                counter <= 0;
                full <= 1;
            end else begin
                counter <= counter + 1;
                full <= 0;
            end 
         end else if (cs==MODE2) begin          
            full       <= 0;
            if(counter1 == (POINTS-1)) begin
                counter1  <= 0;
                counterin <= counterin + 1;                
                done      <= 1;
                store_out <= 1;
                OUT_VALID <= 1;
            end else if (done == 1) begin
                done <= 0;
            end else begin
                counter1  <= counter1 + 1;
                counterin <= counterin + 1;
                done      <= 0;
            end
        end else if (cs==MODE3) begin
            if(counter1 == (POINTS-1)) begin
                counter1  <= 0;
                counterin <= 0;
                done      <= 0;
            end else begin
                counter1  <= counter1 + 1;
                counterin <= counterin + 1;
                done      <= 0;
            end

            if (radix_valid) begin
                if(radix_address == (POINTS-1)) begin
                    radix_address  <= 0;
                end else begin
                    radix_address  <= radix_address + 1;
                end
            end else begin
                radix_address  <= 0;
            end    

        end else begin
            counter <= 0;
        end      
    end
end

always @(*) begin 

    case (cs)

        IDLE: begin 
                    full     = 0;    
                    OUT_VALID = 0;
                    SDF_DONE = 0;
                               
                    if (VALID) begin
                        if (SDF_DONE) begin                  // Wait SDF to be 0 to take next frame SDF is out valid for this block
                            ns = IDLE;
                        end else begin
                            ns = MODE1; 
                        end    
                    end else begin
                        if (SDF_DONE) begin                  // Wait SDF to be 0 to take next frame SDF is out valid for this block
                            ns = MODE1;
                        end else begin
                            ns = IDLE; 
                        end
                    end    
                end
                
        MODE1: begin
                    shift_reg_r[counter] = data_in_r;
                    shift_reg_i[counter] = data_in_i;
                    if (counter == (POINTS-1)) begin
                        ns = MODE2;
                    end else begin
                        ns = MODE1;
                    end            
                end

        MODE2: begin
                    addition_part_r[counter1] = data_in_r + shift_reg_r[counter1];    // shift_reg[0] + data_in [1024] , shift_reg[1] + data_in [1025]
                    subtraction_part_r[counter1] = data_in_r - shift_reg_r[counter1]; // shift_reg[0] - data_in [1024] , shift_reg[1] - data_in [1025]
                    data_out_r = addition_part_r[counter1];                           // data[0]=add[0]*tw_re[0] -- data[1023]=add[1023]*tw_re[1023]

                    addition_part_i[counter1] = data_in_i + shift_reg_i[counter1];
                    subtraction_part_i[counter1] = data_in_i - shift_reg_i[counter1];
                    data_out_i = addition_part_i[counter1];

                    OUT_VALID = 1;                    

                    if (counter1 == (POINTS-1)) begin                                          
                        ns = MODE3;
                    end else begin
                        ns = MODE2;
                    end
                end

        MODE3: begin

                    data_out_r = subtraction_part_r[counter1];        // data[1024]=sub[0]*tw_re[0] -- data[2047]=sub[1023]*tw_re[1023]
                    data_out_i = subtraction_part_i[counter1];

                    shift_reg_r[counter1] = 0;
                    shift_reg_i[counter1] = 0;

                    radix_valid = 1;

                    if (counter1 == (POINTS-1) && counterin == (N-1)) begin
                        SDF_DONE = 1;
                        cntt = cntt + 1;
                        ns       = IDLE;
                    end else begin
                        ns = MODE3;
                    end

                end                                                
    
        default : begin
                    ns = IDLE;
                  end
    endcase   
end

endmodule


// data_out[0-1023] = addition_part[0-1023]
// data_out[1024-2047] = subtraction_part[0-1023]


