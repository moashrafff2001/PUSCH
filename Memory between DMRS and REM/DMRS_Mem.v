module DMRS_Mem #(
    parameter WIDTH = 9
    )(
    input clk,
    input reset,
    input DMRS_valid,
    input [9:0] read_ptr,
    input signed [WIDTH-1:0] DMRS_r_in,
    input signed [WIDTH-1:0] DMRS_i_in,
    output wire signed [WIDTH-1:0] DMRS_r_out,
    output wire signed [WIDTH-1:0] DMRS_i_out
);

reg [WIDTH-1:0] DMRS_Memory_r [0:599];
reg [WIDTH-1:0] DMRS_Memory_i [0:599];
reg [9:0] write_ptr;

// Read operation
// Possible problem is that it can read before write
assign DMRS_r_out = DMRS_Memory_r[read_ptr];
assign DMRS_i_out = DMRS_Memory_i[read_ptr];

// Write data into memory
always @(posedge clk or negedge reset) begin
    if (!reset || !DMRS_valid) begin
        write_ptr <= 0;
    end 
    
    else begin
        // Write operation
        if (DMRS_valid) begin
            DMRS_Memory_r[write_ptr] <= DMRS_r_in;
            DMRS_Memory_i[write_ptr] <= DMRS_i_in;
            write_ptr <= write_ptr + 1;
        end
    end
end

endmodule
