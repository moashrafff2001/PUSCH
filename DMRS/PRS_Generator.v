module PRS_Generator (
    input [9:0] N_cell_ID,
    input [1:0] En_hopping,
    output reg [30:0] pseudo_sequence
);

localparam Nc = 1600 ;
localparam Seq_Len = 31 ;
localparam X1_initialCond = 31'd1;   
integer n; 

wire [19:0] recp_30;
assign recp_30 = 20'b00001000100010001001; // 1/30

wire [29:0] C_init_gh;
assign C_init_gh = N_cell_ID * recp_30; // Q10.0 * Q0.20 = Q10.20

reg [Seq_Len-1:0] X1 ;
reg [Seq_Len-1:0] X2 ;

// Function for mod 31
function [4:0] mod31;
    input [10:0] data_31;
	reg [10:0] temp;
    begin
        temp = data_31;

        // Add higher 6 bits to the lower 5 bits
        temp = (temp & 31) + (temp >> 5);
        // Since the maximum value after this addition can be 62 (which is 31*2),

        // Now temp should be less than 31
        if (temp >= 31)
            temp = temp - 31;

        mod31 = temp[4:0];
    end
endfunction

always @(*) begin

    X1 = X1_initialCond;
    // For Sequence hopping
    if (En_hopping == 2'd2) begin
        X2 = {21'd0, N_cell_ID};
    end
    
    // For Group hopping
    else begin
        X2 = {21'd0, C_init_gh[29:20]};
    end
    
    // X1 and X2 calculations
    for (n = 0; n < 31; n = n + 1) begin
        X1[n] = X1[mod31(n + 3)] ^ X1[n];
        X2[n] = X2[mod31(n + 3)] ^ X2[mod31(n + 2)] ^ X2[mod31(n + 1)] ^ X2[n];
    end
    
    // Since seq_length is 31 by shifting by 1600 we will notice there are 19 shift for each index
    for (n = 0; n < 31; n = n + 1) begin
        pseudo_sequence[n] = X1[mod31(n + 19)] ^ X2[mod31(n + 19)];
    end
    
end

endmodule