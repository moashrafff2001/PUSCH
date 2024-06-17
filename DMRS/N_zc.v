module N_zc (
        input   [9:0]  Mzc,   //  Sequence length
        output reg [9:0]  Nzc,  //  N zadoff chu
        output reg [29:0]  Nzc_rec  //  N_rec zadoff chu
    );

    reg Nzc_flag;
    reg [4:0] ind;
    integer j;

    wire [9:0] prime [0:26];
    wire [29:0] prime_rec [0:26];
                
    // Nzc and Nzc_rec Calculations
    always@(*)
        begin
            ind = 7'b0;
            Nzc_flag = 1'b0;
            
            for(j = 1; j <= 26; j = j + 1) begin
                if ((Mzc < prime[j]) && (!Nzc_flag)) begin
                    ind = j - 1;
                    Nzc_flag = 1'b1;
                end
                
                else if (!Nzc_flag)
                    ind = 7'd26;
                
            end
		
		// Nzc and its reciprocal Calculations
		Nzc = prime[ind];
		Nzc_rec = prime_rec[ind];
        end
assign prime [0] = 10'b0000011111; assign prime_rec [0] = 30'b100001000010000100001000010001;
assign prime [1] = 10'b0000101111; assign prime_rec [1] = 30'b010101110010011000100000101100;
assign prime [2] = 10'b0000110101; assign prime_rec [2] = 30'b010011010100100001110011111011;
assign prime [3] = 10'b0000111011; assign prime_rec [3] = 30'b010001010110110001111001011111;
assign prime [4] = 10'b0001000111; assign prime_rec [4] = 30'b001110011011000010101101000101;
assign prime [5] = 10'b0001011001; assign prime_rec [5] = 30'b001011100000010111000000101110;
assign prime [6] = 10'b0001101011; assign prime_rec [6] = 30'b001001100100011111000110100101;
assign prime [7] = 10'b0001110001; assign prime_rec [7] = 30'b001001000011111101101111000001;
assign prime [8] = 10'b0010001011; assign prime_rec [8] = 30'b000111010111011110110110010101;
assign prime [9] = 10'b0010010101; assign prime_rec [9] = 30'b000110110111110101101100001111;
assign prime [10] = 10'b0010011101; assign prime_rec [10] = 30'b000110100001011011010011111110;
assign prime [11] = 10'b0010110011; assign prime_rec [11] = 30'b000101101110000111110111011011;
assign prime [12] = 10'b0010111111; assign prime_rec [12] = 30'b000101010111000111101101001111;
assign prime [13] = 10'b0011010011; assign prime_rec [13] = 30'b000100110110100110001101111101;
assign prime [14] = 10'b0011101111; assign prime_rec [14] = 30'b000100010010001101011000111010;
assign prime [15] = 10'b0100001101; assign prime_rec [15] = 30'b000011110011101000001101010101;
assign prime [16] = 10'b0100011011; assign prime_rec [16] = 30'b000011100111100100110111001100;
assign prime [17] = 10'b0100100101; assign prime_rec [17] = 30'b000011011111101011000001111110;
assign prime [18] = 10'b0100111101; assign prime_rec [18] = 30'b000011001110101111001111100011;
assign prime [19] = 10'b0101100111; assign prime_rec [19] = 30'b000010110110100011010011000101;
assign prime [20] = 10'b0101111111; assign prime_rec [20] = 30'b000010101011000111001011110111;
assign prime [21] = 10'b0110101111; assign prime_rec [21] = 30'b000010011000000011100100000101;
assign prime [22] = 10'b0111000001; assign prime_rec [22] = 30'b000010010001111101011011110011;
assign prime [23] = 10'b0111011111; assign prime_rec [23] = 30'b000010001000110100011000000011;
assign prime [24] = 10'b1000001011; assign prime_rec [24] = 30'b000001111101010011101100111010;
assign prime [25] = 10'b1000111011; assign prime_rec [25] = 30'b000001110010110001100010101001;
assign prime [26] = 10'b1001010111; assign prime_rec [26] = 30'b000001101101011010001011010101;

endmodule
