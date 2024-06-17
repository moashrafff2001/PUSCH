module interleaver (
    input clk,
    input reset,
    input Active,
    input [16:0] E,
    input [2:0] Qm,
    input data_in, // fix the size


    output reg data_out, valid_out, data_not_repeated
);

    // Parameters
    parameter [13:0] MAX_HEIGHT = 17'd15666; // E / Qm  
    parameter [2:0]  MAX_WIDTH  = 3'd6; // Qm(max)


    // Internal variables
    reg mem [0:MAX_HEIGHT-1][0:MAX_WIDTH-1];
    reg [13:0] write_addr_row;        // Write address row
    reg [2:0] write_addr_col;        // Write address column
    reg [13:0] read_addr_row;         // Read address row
    reg [2:0] read_addr_col;         // Read address column
    reg [31:0] write_counter;        // Counter for tracking total data bits written
    reg [31:0] read_counter;         // Counter for tracking total data bits read
    reg [5:0] one_over_Qm [0:3];     // Size 6 to accommodate Qm values
    reg [22:0] const1, const2, const3, const4;
    reg [17:0] NUM_ROWS;
    reg [17:0] NUM_COLS;
    reg flag;                        // flag to enable the reading process

    always @(posedge clk or posedge reset) 
    begin
        if (!reset) 
            begin
                write_addr_row <= 0;
                write_addr_col <= 0;
                read_addr_row <= 0;
                read_addr_col <= 0;
                write_counter <= 0;
                read_counter <= 0;

                NUM_COLS <= Qm;

                flag <= 0;

                data_out <= 0;
                valid_out <= 0;

                one_over_Qm[0] <= 6'b100000;    // Qm = 1, 1/1 = 1
                one_over_Qm[1] <= 6'b010000;    // Qm = 2, 1/2 = 0.5 (fixed-point binary representation with 1 fractional bit)
                one_over_Qm[2] <= 6'b001000;    // Qm = 4, 1/4 = 0.25
                one_over_Qm[3] <= 6'b000101;    // Qm = 6, 1/6 = 0.16666 (approximated)
            end 
        else  
            begin
                if ( (Active) && (write_counter < E) ) // matrix filling
                    // the active flag is to close the filling after all the data were written 
                    begin
                        // Write data to memory at current address
                        mem[write_addr_row][write_addr_col] <= data_in;

                        // Increment write address
                        if (write_addr_col == NUM_COLS - 1)  
                            begin
                                // Wrap around to next row if end of current row
                                write_addr_row <= write_addr_row + 1;
                                write_addr_col <= 0;
                                if (write_addr_row == NUM_ROWS -1)
                                    flag <= 1;
                                else
                                    flag <= 0;
                            end 
                        else 
                            begin
                                // Increment column within same row
                                write_addr_col <= write_addr_col + 1;
                            end

                        // Increment write counter
                        write_counter <= write_counter + 1;
                    end
                // Reset write pointer if total data bits written exceeds total data bits
                else
                    begin
                        write_addr_row <= 0;
                        write_addr_col <= 0;
                        write_counter <= 0;
                    end

                if ( (flag) && (read_counter < E) ) // matrix reading 
                    begin
                        data_out <= mem[read_addr_row][read_addr_col];
                        valid_out <= 1;
                        data_not_repeated <= 1;

                        // Increment read address
                        if (read_addr_row == NUM_ROWS-1)
                            begin
                                if (read_addr_col == NUM_COLS - 1)
                                    read_addr_col <= 0;
                                else
                                    read_addr_col <= read_addr_col + 1;

                                read_addr_row <= 0;
                            end
                        else
                            begin
                                read_addr_row <= read_addr_row + 1;
                            end

                        // Increment read counter
                        read_counter <= read_counter + 1;
                    end 
                else 
                    begin
                        // Reset read pointer if all data has been read
                        read_addr_row <= 0;
                        read_addr_col <= 0;
                        read_counter <= 0;
                        valid_out <= 0;
                        data_not_repeated <= 0;
                    end
            end

    end

    always @(*) 
    begin : proc_
        // get the NUM_ROWS value
        case (Qm)
            3'b001: begin
                const1 = E;
                NUM_ROWS = E;    // Qm = 1
            end 
            3'b010: begin
                const2 = E * one_over_Qm[1];
                NUM_ROWS = myciel(const2);   // Qm = 2
            end
            3'b100: begin
                const3 = E * one_over_Qm[2];
                NUM_ROWS = myciel(const3);   // Qm = 4
            end
            3'b110: begin
                const4 = E * one_over_Qm[3];
                NUM_ROWS = myciel(const4);   // Qm = 6
            end
            default: NUM_ROWS = E;       
        endcase
    end

    function [17:0] myciel(input [22:0] mult_result);
        if (mult_result[4:0] == 5'b0)
            myciel = mult_result[22:5];
        else
            myciel = mult_result[22:5] + 1;
    endfunction

endmodule