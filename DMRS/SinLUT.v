module SinLUT #(
    parameter WIDTH = 9
    )(
	input [14:0] phase,
	output reg signed [WIDTH-1:0] sin_value,
	output reg signed [WIDTH-1:0] cos_value
);

parameter table_size = 256;
wire [7:0] lut [0:table_size-1];
reg [24:0] ind;
reg [9:0] index, index_c;
reg [1:0] quad, quad_c;

// Phase for cosine Calculations
wire [14:0] phase_c;
assign phase_c = phase + 15'b010000000000000; // phase_c = phase + 0.25;

always@(*)
	begin			
		// Index calculation Q10.0*Q0.15 = Q10.15
		ind = (phase << 10) - (phase << 2); // phase * (table_size-1) * 4
		
		// Rounding the index
		index = ind[24:15] + ind[14]; // Q10.15 -> Q10.0 (Rounding)
		
		quad = phase[14:13];
		
		// Index calculation Q9.0*Q0.15 = Q9.15
		ind = (phase_c << 10) - (phase_c << 2); // phase * (table_size-1) * 4
		
		// Rounding the index
		index_c = ind[24:15] + ind[14]; // Q10.15 -> Q10.0 (Rounding)
		
		quad_c = phase_c[14:13];
		
		//calculation of the sine value
		case (quad)
		
			2'b00 : begin
						sin_value = {1'b0, lut[index]}; // from 0 -> 90
					end
				
			2'b01 : begin
						sin_value = {1'b0, lut[2*(table_size-1) - index]}; // from 90 -> 180
					end		
				
			2'b10 : begin
						if (index == 2*(table_size-1))
							sin_value = 9'b0;
							
						else
							sin_value = {1'b1, lut[index - 2*(table_size-1)]}; // from 180 -> 270	
					end
			
			2'b11 : begin
						if (index == 4*(table_size-1))
							sin_value = 9'b0;
							
						else
							sin_value = {1'b1, lut[4*(table_size-1) - index]}; // from 270 -> 360
					end
				
			default : sin_value = 9'b0;
		
		endcase
		
		//calculation of the cos value
		case (quad_c)
		
			2'b00 : begin
						cos_value = {1'b0, lut[index_c]}; // from 0 -> 90
					end
				
			2'b01 : begin
						cos_value = {1'b0, lut[2*(table_size-1) - index_c]}; // from 90 -> 180
					end		
				
			2'b10 : begin
						if (index_c == 2*(table_size-1))
							cos_value = 9'b0;
							
						else
							cos_value = {1'b1, lut[index_c - 2*(table_size-1)]}; // from 180 -> 270	
					end
			
			2'b11 : begin
						if (index_c == 4*(table_size-1))
							cos_value = 9'b0;
							
						else
							cos_value = {1'b1, lut[4*(table_size-1) - index_c]}; // from 270 -> 360
					end
				
			default : cos_value = 9'b0;
		
		endcase
	end

// Initialize LUT with sine values
assign lut [0] = 8'b00000000;
assign lut [1] = 8'b00000010;
assign lut [2] = 8'b00000011;
assign lut [3] = 8'b00000101;
assign lut [4] = 8'b00000110;
assign lut [5] = 8'b00001000;
assign lut [6] = 8'b00001001;
assign lut [7] = 8'b00001011;
assign lut [8] = 8'b00001101;
assign lut [9] = 8'b00001110;
assign lut [10] = 8'b00010000;
assign lut [11] = 8'b00010001;
assign lut [12] = 8'b00010011;
assign lut [13] = 8'b00010100;
assign lut [14] = 8'b00010110;
assign lut [15] = 8'b00011000;
assign lut [16] = 8'b00011001;
assign lut [17] = 8'b00011011;
assign lut [18] = 8'b00011100;
assign lut [19] = 8'b00011110;
assign lut [20] = 8'b00011111;
assign lut [21] = 8'b00100001;
assign lut [22] = 8'b00100010;
assign lut [23] = 8'b00100100;
assign lut [24] = 8'b00100110;
assign lut [25] = 8'b00100111;
assign lut [26] = 8'b00101001;
assign lut [27] = 8'b00101010;
assign lut [28] = 8'b00101100;
assign lut [29] = 8'b00101101;
assign lut [30] = 8'b00101111;
assign lut [31] = 8'b00110000;
assign lut [32] = 8'b00110010;
assign lut [33] = 8'b00110011;
assign lut [34] = 8'b00110101;
assign lut [35] = 8'b00110111;
assign lut [36] = 8'b00111000;
assign lut [37] = 8'b00111010;
assign lut [38] = 8'b00111011;
assign lut [39] = 8'b00111101;
assign lut [40] = 8'b00111110;
assign lut [41] = 8'b01000000;
assign lut [42] = 8'b01000001;
assign lut [43] = 8'b01000011;
assign lut [44] = 8'b01000100;
assign lut [45] = 8'b01000110;
assign lut [46] = 8'b01000111;
assign lut [47] = 8'b01001001;
assign lut [48] = 8'b01001010;
assign lut [49] = 8'b01001100;
assign lut [50] = 8'b01001101;
assign lut [51] = 8'b01001111;
assign lut [52] = 8'b01010000;
assign lut [53] = 8'b01010010;
assign lut [54] = 8'b01010011;
assign lut [55] = 8'b01010101;
assign lut [56] = 8'b01010110;
assign lut [57] = 8'b01011000;
assign lut [58] = 8'b01011001;
assign lut [59] = 8'b01011011;
assign lut [60] = 8'b01011100;
assign lut [61] = 8'b01011110;
assign lut [62] = 8'b01011111;
assign lut [63] = 8'b01100001;
assign lut [64] = 8'b01100010;
assign lut [65] = 8'b01100011;
assign lut [66] = 8'b01100101;
assign lut [67] = 8'b01100110;
assign lut [68] = 8'b01101000;
assign lut [69] = 8'b01101001;
assign lut [70] = 8'b01101011;
assign lut [71] = 8'b01101100;
assign lut [72] = 8'b01101101;
assign lut [73] = 8'b01101111;
assign lut [74] = 8'b01110000;
assign lut [75] = 8'b01110010;
assign lut [76] = 8'b01110011;
assign lut [77] = 8'b01110101;
assign lut [78] = 8'b01110110;
assign lut [79] = 8'b01110111;
assign lut [80] = 8'b01111001;
assign lut [81] = 8'b01111010;
assign lut [82] = 8'b01111011;
assign lut [83] = 8'b01111101;
assign lut [84] = 8'b01111110;
assign lut [85] = 8'b10000000;
assign lut [86] = 8'b10000001;
assign lut [87] = 8'b10000010;
assign lut [88] = 8'b10000100;
assign lut [89] = 8'b10000101;
assign lut [90] = 8'b10000110;
assign lut [91] = 8'b10001000;
assign lut [92] = 8'b10001001;
assign lut [93] = 8'b10001010;
assign lut [94] = 8'b10001100;
assign lut [95] = 8'b10001101;
assign lut [96] = 8'b10001110;
assign lut [97] = 8'b10010000;
assign lut [98] = 8'b10010001;
assign lut [99] = 8'b10010010;
assign lut [100] = 8'b10010011;
assign lut [101] = 8'b10010101;
assign lut [102] = 8'b10010110;
assign lut [103] = 8'b10010111;
assign lut [104] = 8'b10011000;
assign lut [105] = 8'b10011010;
assign lut [106] = 8'b10011011;
assign lut [107] = 8'b10011100;
assign lut [108] = 8'b10011101;
assign lut [109] = 8'b10011111;
assign lut [110] = 8'b10100000;
assign lut [111] = 8'b10100001;
assign lut [112] = 8'b10100010;
assign lut [113] = 8'b10100100;
assign lut [114] = 8'b10100101;
assign lut [115] = 8'b10100110;
assign lut [116] = 8'b10100111;
assign lut [117] = 8'b10101000;
assign lut [118] = 8'b10101010;
assign lut [119] = 8'b10101011;
assign lut [120] = 8'b10101100;
assign lut [121] = 8'b10101101;
assign lut [122] = 8'b10101110;
assign lut [123] = 8'b10101111;
assign lut [124] = 8'b10110001;
assign lut [125] = 8'b10110010;
assign lut [126] = 8'b10110011;
assign lut [127] = 8'b10110100;
assign lut [128] = 8'b10110101;
assign lut [129] = 8'b10110110;
assign lut [130] = 8'b10110111;
assign lut [131] = 8'b10111000;
assign lut [132] = 8'b10111001;
assign lut [133] = 8'b10111010;
assign lut [134] = 8'b10111100;
assign lut [135] = 8'b10111101;
assign lut [136] = 8'b10111110;
assign lut [137] = 8'b10111111;
assign lut [138] = 8'b11000000;
assign lut [139] = 8'b11000001;
assign lut [140] = 8'b11000010;
assign lut [141] = 8'b11000011;
assign lut [142] = 8'b11000100;
assign lut [143] = 8'b11000101;
assign lut [144] = 8'b11000110;
assign lut [145] = 8'b11000111;
assign lut [146] = 8'b11001000;
assign lut [147] = 8'b11001001;
assign lut [148] = 8'b11001010;
assign lut [149] = 8'b11001011;
assign lut [150] = 8'b11001100;
assign lut [151] = 8'b11001101;
assign lut [152] = 8'b11001110;
assign lut [153] = 8'b11001111;
assign lut [154] = 8'b11001111;
assign lut [155] = 8'b11010000;
assign lut [156] = 8'b11010001;
assign lut [157] = 8'b11010010;
assign lut [158] = 8'b11010011;
assign lut [159] = 8'b11010100;
assign lut [160] = 8'b11010101;
assign lut [161] = 8'b11010110;
assign lut [162] = 8'b11010111;
assign lut [163] = 8'b11010111;
assign lut [164] = 8'b11011000;
assign lut [165] = 8'b11011001;
assign lut [166] = 8'b11011010;
assign lut [167] = 8'b11011011;
assign lut [168] = 8'b11011100;
assign lut [169] = 8'b11011100;
assign lut [170] = 8'b11011101;
assign lut [171] = 8'b11011110;
assign lut [172] = 8'b11011111;
assign lut [173] = 8'b11100000;
assign lut [174] = 8'b11100000;
assign lut [175] = 8'b11100001;
assign lut [176] = 8'b11100010;
assign lut [177] = 8'b11100011;
assign lut [178] = 8'b11100011;
assign lut [179] = 8'b11100100;
assign lut [180] = 8'b11100101;
assign lut [181] = 8'b11100101;
assign lut [182] = 8'b11100110;
assign lut [183] = 8'b11100111;
assign lut [184] = 8'b11100111;
assign lut [185] = 8'b11101000;
assign lut [186] = 8'b11101001;
assign lut [187] = 8'b11101001;
assign lut [188] = 8'b11101010;
assign lut [189] = 8'b11101011;
assign lut [190] = 8'b11101011;
assign lut [191] = 8'b11101100;
assign lut [192] = 8'b11101101;
assign lut [193] = 8'b11101101;
assign lut [194] = 8'b11101110;
assign lut [195] = 8'b11101110;
assign lut [196] = 8'b11101111;
assign lut [197] = 8'b11101111;
assign lut [198] = 8'b11110000;
assign lut [199] = 8'b11110001;
assign lut [200] = 8'b11110001;
assign lut [201] = 8'b11110010;
assign lut [202] = 8'b11110010;
assign lut [203] = 8'b11110011;
assign lut [204] = 8'b11110011;
assign lut [205] = 8'b11110100;
assign lut [206] = 8'b11110100;
assign lut [207] = 8'b11110101;
assign lut [208] = 8'b11110101;
assign lut [209] = 8'b11110101;
assign lut [210] = 8'b11110110;
assign lut [211] = 8'b11110110;
assign lut [212] = 8'b11110111;
assign lut [213] = 8'b11110111;
assign lut [214] = 8'b11111000;
assign lut [215] = 8'b11111000;
assign lut [216] = 8'b11111000;
assign lut [217] = 8'b11111001;
assign lut [218] = 8'b11111001;
assign lut [219] = 8'b11111001;
assign lut [220] = 8'b11111010;
assign lut [221] = 8'b11111010;
assign lut [222] = 8'b11111010;
assign lut [223] = 8'b11111011;
assign lut [224] = 8'b11111011;
assign lut [225] = 8'b11111011;
assign lut [226] = 8'b11111100;
assign lut [227] = 8'b11111100;
assign lut [228] = 8'b11111100;
assign lut [229] = 8'b11111100;
assign lut [230] = 8'b11111101;
assign lut [231] = 8'b11111101;
assign lut [232] = 8'b11111101;
assign lut [233] = 8'b11111101;
assign lut [234] = 8'b11111110;
assign lut [235] = 8'b11111110;
assign lut [236] = 8'b11111110;
assign lut [237] = 8'b11111110;
assign lut [238] = 8'b11111110;
assign lut [239] = 8'b11111111;
assign lut [240] = 8'b11111111;
assign lut [241] = 8'b11111111;
assign lut [242] = 8'b11111111;
assign lut [243] = 8'b11111111;
assign lut [244] = 8'b11111111;
assign lut [245] = 8'b11111111;
assign lut [246] = 8'b11111111;
assign lut [247] = 8'b11111111;
assign lut [248] = 8'b11111111;
assign lut [249] = 8'b11111111;
assign lut [250] = 8'b11111111;
assign lut [251] = 8'b11111111;
assign lut [252] = 8'b11111111;
assign lut [253] = 8'b11111111;
assign lut [254] = 8'b11111111;
assign lut [255] = 8'b11111111;

endmodule