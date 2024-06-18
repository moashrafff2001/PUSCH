module RateMatching_and_HARQ (
    input clk,rst,Active,
    input [1:0] base_graph,     // Base graph selection (1 or 2)
    input [8:0] Z,              // lifting factor
    input [127:0] data_in,      // Input data stream
    input [1:0] RV,             // Redundancy Version (0, 1, 2, or 3)
    input [3:0] PN,             // process number (0, 1, 2, or 3)
    input [16:0] data_size,             // total size of the ip data given from the LDPC
    input [16:0] G,             // size of the op Rv given from the base station 

    output reg op_RV_bit, 
    output reg valid_out  // Output rate-matched data
);
    parameter [4:0] NUM_ROWS = 20;   
    parameter [3:0] NUM_COLS = 10;
    parameter [7:0] CELL_WIDTH = 128;
    integer i, j, k; // counters for the nested loops to determine the staring index

    reg [127:0] mem1 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem2 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem3 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem4 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem5 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem6 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem7 [0:NUM_ROWS-1][0:NUM_COLS-1];
    reg [127:0] mem8 [0:NUM_ROWS-1][0:NUM_COLS-1];

    reg [14:0] k0;
    reg [14:0] RVs_base_graph_1 [0:3];
    reg [14:0] RVs_base_graph_2 [0:3];
    reg [1:0] RV_ID;
    reg [1:0] RV_ID_counter;
    reg [1:0] RV_ID_array [0:3];

    reg [14:0] index;               // temp variable to save the starting point of the RV (KO)
    reg [4:0] row_index;            // row number starting point
    reg [3:0] column_index;         // coloumn number starting point
    reg [7:0] bit_index;            // bit number starting point

    reg [4:0] write_addr_row;       // Write address row
    reg [3:0] write_addr_col;       // Write address column
    reg [7:0] write_addr_bit;       // write address bit
    reg [4:0] read_addr_row;        // Read address row
    reg [3:0] read_addr_col;        // Read address column
    reg [7:0] read_addr_bit;        // Read address bit
    reg [31:0] write_counter;       // Counter for tracking total data bits written
    reg [31:0] read_counter;        // Counter for tracking total data bits read

    reg [31:0] cycle_counter;
    reg [16:0] starting_value;      // to save the count (easy debug purpose)
    reg [9:0] cycle_repeat;        // reg to determine number of repeated cycles in the repetation case
    
    reg enable_read_flag;
    always @(posedge clk or posedge rst) 
    begin
        if (!rst)
            begin
                write_addr_row <= 0;
                write_addr_col <= 0;
                write_counter <= 0;
                read_addr_row <= 0;
                read_addr_col <= 0;
                read_addr_bit <= 0;                
                read_counter <= 1;
                op_RV_bit <= 0;
                valid_out <= 0;
                cycle_counter <= 0;
/*
                RVs_base_graph_1[0] <= 0;
                RVs_base_graph_1[1] <= 0;
                RVs_base_graph_1[2] <= 0;
                RVs_base_graph_1[3] <= 0;
                
                RVs_base_graph_2[0] <= 0;
                RVs_base_graph_2[1] <= 0;
                RVs_base_graph_2[2] <= 0;
                RVs_base_graph_2[3] <= 0;
*/
                RVs_base_graph_1[0] <= 0;
                RVs_base_graph_1[1] <= 17 * Z;
                RVs_base_graph_1[2] <= 33 * Z;
                RVs_base_graph_1[3] <= 56 * Z;
                
                RVs_base_graph_2[0] <= 0;
                RVs_base_graph_2[1] <= 13 * Z;
                RVs_base_graph_2[2] <= 25 * Z;
                RVs_base_graph_2[3] <= 43 * Z;

                RV_ID_array[0] <= 0;
                RV_ID_array[1] <= 2;
                RV_ID_array[2] <= 3;
                RV_ID_array[3] <= 1;

                RV_ID_counter <= 0;

                cycle_repeat <= 0;

                enable_read_flag <= 0;

            end

        else 
            begin
                if (Active) // matrix filling 
                    begin
                        enable_read_flag <= 1;
        /*              RVs_base_graph_1[0] <= 0;
                        RVs_base_graph_1[1] <= 17 * Z;
                        RVs_base_graph_1[2] <= 33 * Z;
                        RVs_base_graph_1[3] <= 56 * Z;
                        
                        RVs_base_graph_2[0] <= 0;
                        RVs_base_graph_2[1] <= 13 * Z;
                        RVs_base_graph_2[2] <= 25 * Z;
                        RVs_base_graph_2[3] <= 43 * Z;
        */
                        case (PN)
                            1:mem1[write_addr_row][write_addr_col] <= data_in;
                            2:mem2[write_addr_row][write_addr_col] <= data_in;
                            3:mem3[write_addr_row][write_addr_col] <= data_in;
                            4:mem4[write_addr_row][write_addr_col] <= data_in;
                            5:mem5[write_addr_row][write_addr_col] <= data_in;
                            6:mem6[write_addr_row][write_addr_col] <= data_in;
                            7:mem7[write_addr_row][write_addr_col] <= data_in;
                            8:mem8[write_addr_row][write_addr_col] <= data_in;
                        endcase
                                
                        // Check for end of row
                        if (write_addr_col == NUM_COLS - 1) 
                            begin
                                // Wrap around to next row if end of current row
                                write_addr_row <= write_addr_row + 1;
                                write_addr_col <= 0;
                            end 
                        else 
                            begin
                                // Increment column within same row
                                write_addr_col <= write_addr_col + 1;
                            end

                        // Increment write counter
                        write_counter <= write_counter + 128;
                    end
                else // reading from the matrix and perform the operations (trancation or repeating) 
                    begin
                        if ( (enable_read_flag == 1) && (cycle_counter < G) )
                            begin
                                valid_out <= 1;
                                
                                // updating the reading addresses 
                                if ( (RV_ID_counter == 0) && (read_addr_col == 0) && (read_addr_row == 0) && (read_addr_bit == 0) ) // =1 to not enter the if condition of %(data_size) as 0%data_size = 0
                                    begin
                                        // Initial assignment
                                        read_addr_col <= column_index; //3
                                        read_addr_row <= row_index; //1
                                        read_addr_bit <= bit_index; //36
                                        cycle_repeat  <= 0;
                                    end
                                else if (read_counter % (data_size) == 0)
                                    begin
                                        read_addr_row <= 0;
                                        read_addr_col <= 0; 
                                        read_addr_bit <= 0;
                                        cycle_repeat  <= cycle_repeat + 1;
                                        cycle_counter <= cycle_counter + 1;                                       
                                    end
                                else
                                    begin
                                        // Increment read address
                                        if (read_addr_bit == CELL_WIDTH - 1)
                                            begin
                                                // Reset bit index to 0 when it reaches 128 bits
                                                read_addr_bit <= 0;
                                                
                                                // Check for end of row
                                                if (read_addr_col == NUM_COLS - 1) 
                                                    begin
                                                        // Wrap around to next row if end of current row
                                                        read_addr_row <= read_addr_row + 1;
                                                        read_addr_col <= 0;
                                                    end 
                                                else 
                                                    begin
                                                        // Increment column within same row
                                                        read_addr_col <= read_addr_col + 1;
                                                    end
                                            end
                                        else
                                            begin
                                                // Increment bit index
                                                read_addr_bit <= read_addr_bit + 1;
                                            end
                                    end

                                // sending the RV_ID first 
                                if (RV_ID_counter < 1) // the RV_ID is only 2 bits so this if condition will only applied twice 0,1 
                                    begin
                                        case (RV)
                                            0:
                                            begin
                                                op_RV_bit <= 0;
                                                read_counter  <= starting_value + 1;
                                                cycle_counter <= cycle_counter + 1;
                                            end
                                            1:
                                            begin
                                                op_RV_bit <= 1;
                                                read_counter  <= starting_value + 1;
                                                cycle_counter <= cycle_counter + 1;
                                            end 
                                            2:
                                            begin
                                                op_RV_bit <= 0;
                                                @(posedge clk);
                                                op_RV_bit <= 1;
                                                read_counter  <= starting_value + 2;
                                                cycle_counter <= cycle_counter + 2;
                                            end 
                                            3:
                                            begin
                                                op_RV_bit <= 1;
                                                @(posedge clk);
                                                op_RV_bit <= 1;
                                                read_counter  <= starting_value + 1;
                                                cycle_counter <= cycle_counter + 1;
                                            end 
                                        endcase        
                                        RV_ID_counter = RV_ID_counter +1;
                                    end
                                else // sending the data
                                    begin
                                        case (PN)
                                            1:op_RV_bit <= mem1[read_addr_row][read_addr_col][read_addr_bit]; 
                                            2:op_RV_bit <= mem2[read_addr_row][read_addr_col][read_addr_bit]; 
                                            3:op_RV_bit <= mem3[read_addr_row][read_addr_col][read_addr_bit]; 
                                            4:op_RV_bit <= mem4[read_addr_row][read_addr_col][read_addr_bit]; 
                                            5:op_RV_bit <= mem5[read_addr_row][read_addr_col][read_addr_bit]; 
                                            6:op_RV_bit <= mem6[read_addr_row][read_addr_col][read_addr_bit]; 
                                            7:op_RV_bit <= mem7[read_addr_row][read_addr_col][read_addr_bit]; 
                                            8:op_RV_bit <= mem8[read_addr_row][read_addr_col][read_addr_bit]; 
                                        endcase 

                                        read_counter <= read_counter + 1;  
                                        cycle_counter <= cycle_counter + 1; 
                                    end                                                                   
                            end
                        else 
                            begin
                                // Reset read pointer if all data has been read
                                read_addr_row <= 0;
                                read_addr_col <= 0;
                                read_addr_bit <= 0;
                                read_counter <= 0;
                                valid_out <= 0;
                                cycle_repeat <= 0;
                                enable_read_flag <= 0;
                            end
                        
                    end
            end
    end

    always @(*) 
    begin : proc_
        if (base_graph == 1)
            begin
            $display("",);
                if (RV == 0)
                    begin
                        k0 = RVs_base_graph_1[0];       // starting point
                        RV_ID = RV_ID_array[0];                        
                    end

                else if (RV == 2)
                    begin
                        k0 = RVs_base_graph_1[1];      // starting point
                        RV_ID = RV_ID_array[1];                        
                    end

                else if (RV == 1)
                    begin
                        k0 = RVs_base_graph_1[3];      // starting point
                        RV_ID = RV_ID_array[3];                        
                    end

                else  // RV == 3
                    begin
                        k0 = RVs_base_graph_1[2];      // starting point
                        RV_ID = RV_ID_array[2];                        
                    end      
            end
        else if (base_graph == 2)
            begin
                if (RV == 0)
                    begin
                        k0 = RVs_base_graph_2[0];       // starting point
                        RV_ID = RV_ID_array[0];                        
                    end

                else if (RV == 2)
                    begin
                        k0 = RVs_base_graph_2[1];      // starting point
                        RV_ID = RV_ID_array[1];                        
                    end

                else if (RV == 1)
                    begin
                        k0 = RVs_base_graph_2[3];      // starting point
                        RV_ID = RV_ID_array[3];                        
                    end

                else  // RV == 3
                    begin
                        k0 = RVs_base_graph_2[2];      // starting point
                        RV_ID = RV_ID_array[2];                        
                    end          
            end

        // loops to know the starting index
        // Iterate over rows
        index = k0; 

        for (i = 0; i < NUM_ROWS; i = i + 1) begin: row_loop
            // Iterate over columns
            for (j = 0; j < NUM_COLS; j = j + 1) begin: colomn_loop
                // Iterate over cell
                for (k = 0; k < CELL_WIDTH; k = k + 1) begin: cell_loop
                    if (index == 0) 
                        begin
                            row_index = i;
                            column_index = j;
                            bit_index = k;
                            starting_value = column_index * 128 + row_index * 128 * 10 + bit_index;
                            $display("time = %0t bit_index = %0d",$time(), bit_index); 
                        end
                    index = index - 1; 
                end
            end
        end
    end
endmodule
