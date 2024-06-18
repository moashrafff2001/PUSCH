module LDPC #(parameter zc = 2, parameter kb = 10,parameter width =50,parameter size =width*zc ) (
    input CLK,
    input RST,
    input DATA,
    input [15:0] CRC_bits,
    input ACTIVE ,
    output     reg   [128-1:0]                   data_out,          
    output     reg                      Valid   
);
reg [(kb*zc)-1:0] message;
wire [3:0] A_matrix[3:0][kb-1:0];
wire [3:0]  B_matrix[3:0][3:0];
wire [3:0]  C1_matrix[37:0][kb-1:0];
wire [3:0]  D_matrix[37:0][3:0];

always @ (*) begin
    message = 'b0;
    message={CRC_bits,DATA};
end


  assign A_matrix[0][0] = 4'b0001;
    assign A_matrix[0][1] = 4'b0001;
    assign A_matrix[0][2] = 4'b0000;
    assign A_matrix[0][3] = 4'b0000;
    assign A_matrix[0][4] = 4'b1111;
    assign A_matrix[0][5] = 4'b1111;
    assign A_matrix[0][6] = 4'b0001;
    assign A_matrix[0][7] = 4'b1111;
    assign A_matrix[0][8] = 4'b1111;
    assign A_matrix[0][9] = 4'b0001;
    
    assign A_matrix[1][0] = 4'b0001;
    assign A_matrix[1][1] = 4'b1111;
    assign A_matrix[1][2] = 4'b1111;
    assign A_matrix[1][3] = 4'b0000;
    assign A_matrix[1][4] = 4'b0001;
    assign A_matrix[1][5] = 4'b0001;
    assign A_matrix[1][6] = 4'b0000;
    assign A_matrix[1][7] = 4'b0000;
    assign A_matrix[1][8] = 4'b0000;
    assign A_matrix[1][9] = 4'b0000;
    
    assign A_matrix[2][0] = 4'b0001;
    assign A_matrix[2][1] = 4'b0000;
    assign A_matrix[2][2] = 4'b1111;
    assign A_matrix[2][3] = 4'b0000;
    assign A_matrix[2][4] = 4'b0000;
    assign A_matrix[2][5] = 4'b1111;
    assign A_matrix[2][6] = 4'b1111;
    assign A_matrix[2][7] = 4'b1111;
    assign A_matrix[2][8] = 4'b0000;
    assign A_matrix[2][9] = 4'b1111;
    
     assign A_matrix[3][0] = 4'b1111;
    assign A_matrix[3][1] = 4'b0000;
    assign A_matrix[3][2] = 4'b0000;
    assign A_matrix[3][3] = 4'b1111;
    assign A_matrix[3][4] = 4'b0000;
    assign A_matrix[3][5] = 4'b0000;
    assign A_matrix[3][6] = 4'b0001;
    assign A_matrix[3][7] = 4'b0000;
    assign A_matrix[3][8] = 4'b0000;
    assign A_matrix[3][9] = 4'b0000;


   assign B_matrix[0][0] = 4'b0000;
    assign B_matrix[0][1] = 4'b0000;
    assign B_matrix[0][2] = 4'b1111;
    assign B_matrix[0][3] = 4'b1111;
    
     assign B_matrix[1][0] = 4'b1111;
    assign B_matrix[1][1] = 4'b0000;
    assign B_matrix[1][2] = 4'b0000;
    assign B_matrix[1][3] = 4'b1111;
    
    
     assign B_matrix[2][0] = 4'b0001;
    assign B_matrix[2][1] = 4'b1111;
    assign B_matrix[2][2] = 4'b0000;
    assign B_matrix[2][3] = 4'b0000;
    
    
     assign B_matrix[3][0] = 4'b0000;
    assign B_matrix[3][1] = 4'b1111;
    assign B_matrix[3][2] = 4'b1111;
    assign B_matrix[3][3] = 4'b0000;  

        assign C1_matrix[0][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[0][1] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[0][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[0][9] = 4'b1111; // -1 in 4-bit binary (two's complement)
  

assign C1_matrix[1][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[1][1] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[1][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[1][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[1][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[1][5] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[1][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[1][7] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[1][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[1][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

 assign C1_matrix[2][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[2][1] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[2][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[2][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[2][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[2][5] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[2][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[2][7] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[2][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[2][9] = 4'b0000; // 0 in 4-bit binary

        assign C1_matrix[3][0] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[3][1] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[3][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[3][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[3][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[3][5] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[3][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[3][7] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[3][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[3][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

 assign C1_matrix[4][0] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[4][1] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[4][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[4][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

 assign C1_matrix[5][0] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][1] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[5][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[5][8] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[5][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

 assign C1_matrix[6][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[6][1] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[6][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[6][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[6][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[6][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[6][6] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[6][7] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[6][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[6][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

 assign C1_matrix[7][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[7][1] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][7] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[7][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[7][9] = 4'b0000; // 0 in 4-bit binary

assign C1_matrix[8][0] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][1] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[8][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][3] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[8][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[8][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

assign C1_matrix[9][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[9][1] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[9][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[9][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[9][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[9][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[9][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[9][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[9][8] = 4'b0000; // 0 in 4-bit binary
        assign C1_matrix[9][9] = 4'b1111; // -1 in 4-bit binary (two's complement)

assign C1_matrix[10][0] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][1] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[10][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][6] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[10][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[10][9] = 4'b1111; // -1 in 4-bit binary (two's complement)


assign C1_matrix[11][0] = 4'b0001; // 1 in 4-bit binary
        assign C1_matrix[11][1] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][2] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][3] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][4] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][5] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][6] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][7] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][8] = 4'b1111; // -1 in 4-bit binary (two's complement)
        assign C1_matrix[11][9] = 4'b1111; // -1 in 4-bit binary (two's complement)


 assign C1_matrix[12][0] = 4'b1111; // -1
        assign C1_matrix[12][1] = 4'b0001; // 1
        assign C1_matrix[12][2] = 4'b1111; // -1
        assign C1_matrix[12][3] = 4'b1111; // -1
        assign C1_matrix[12][4] = 4'b1111; // -1
        assign C1_matrix[12][5] = 4'b1111; // -1
        assign C1_matrix[12][6] = 4'b1111; // -1
        assign C1_matrix[12][7] = 4'b1111; // -1
        assign C1_matrix[12][8] = 4'b1111; // -1
        assign C1_matrix[12][9] = 4'b0000; // 0

        // Row 2 (assign C1_matrix[13][j])
        assign C1_matrix[13][0] = 4'b1111; // -1
        assign C1_matrix[13][1] = 4'b0000; // 0
        assign C1_matrix[13][2] = 4'b1111; // -1
        assign C1_matrix[13][3] = 4'b1111; // -1
        assign C1_matrix[13][4] = 4'b1111; // -1
        assign C1_matrix[13][5] = 4'b0000; // 0
        assign C1_matrix[13][6] = 4'b1111; // -1
        assign C1_matrix[13][7] = 4'b1111; // -1
        assign C1_matrix[13][8] = 4'b1111; // -1
        assign C1_matrix[13][9] = 4'b1111; // -1

        // Row 3 (assign C1_matrix[14][j])
        assign C1_matrix[14][0] = 4'b0000; // 0
        assign C1_matrix[14][1] = 4'b1111; // -1
        assign C1_matrix[14][2] = 4'b1111; // -1
        assign C1_matrix[14][3] = 4'b1111; // -1
        assign C1_matrix[14][4] = 4'b1111; // -1
        assign C1_matrix[14][5] = 4'b1111; // -1
        assign C1_matrix[14][6] = 4'b0000; // 0
        assign C1_matrix[14][7] = 4'b0000; // 0
        assign C1_matrix[14][8] = 4'b1111; // -1
        assign C1_matrix[14][9] = 4'b1111; // -1

        // Row 4 (assign C1_matrix[15][j])
        assign C1_matrix[15][0] = 4'b0001; // 1
        assign C1_matrix[15][1] = 4'b0000; // 0
        assign C1_matrix[15][2] = 4'b1111; // -1
        assign C1_matrix[15][3] = 4'b1111; // -1
        assign C1_matrix[15][4] = 4'b1111; // -1
        assign C1_matrix[15][5] = 4'b1111; // -1
        assign C1_matrix[15][6] = 4'b1111; // -1
        assign C1_matrix[15][7] = 4'b1111; // -1
        assign C1_matrix[15][8] = 4'b1111; // -1
        assign C1_matrix[15][9] = 4'b1111; // -1

        // Row 5 (assign C1_matrix[16][j])
        assign C1_matrix[16][0] = 4'b1111; // -1
        assign C1_matrix[16][1] = 4'b0000; // 0
        assign C1_matrix[16][2] = 4'b1111; // -1
        assign C1_matrix[16][3] = 4'b1111; // -1
        assign C1_matrix[16][4] = 4'b0001; // 1
        assign C1_matrix[16][5] = 4'b1111; // -1
       assign C1_matrix [16][6] = 4'b1111; // -1
        assign C1_matrix[16][7] = 4'b1111; // -1
        assign C1_matrix[16][8] = 4'b1111; // -1
        assign C1_matrix[16][9] = 4'b1111; // -1

 assign C1_matrix[17][0] = 4'b0000; // 0
        assign C1_matrix[17][1] = 4'b1111; // -1
        assign C1_matrix[17][2] = 4'b1111; // -1
        assign C1_matrix[17][3] = 4'b1111; // -1
        assign C1_matrix[17][4] = 4'b1111; // -1
        assign C1_matrix[17][5] = 4'b1111; // -1
        assign C1_matrix[17][6] = 4'b1111; // -1
        assign C1_matrix[17][7] = 4'b1111; // -1
        assign C1_matrix[17][8] = 4'b0000; // 0
        assign C1_matrix[17][9] = 4'b1111; // -1

        // Row 2 (assign C1_matrix[18][j])
        assign C1_matrix[18][0] = 4'b1111; // -1
        assign C1_matrix[18][1] = 4'b0000; // 0
        assign C1_matrix[18][2] = 4'b0001; // 1
        assign C1_matrix[18][3] = 4'b1111; // -1
        assign C1_matrix[18][4] = 4'b1111; // -1
        assign C1_matrix[18][5] = 4'b1111; // -1
        assign C1_matrix[18][6] = 4'b1111; // -1
        assign C1_matrix[18][7] = 4'b1111; // -1
        assign C1_matrix[18][8] = 4'b1111; // -1
        assign C1_matrix[18][9] = 4'b1111; // -1

        // Row 3 (assign C1_matrix[19][j])
        assign C1_matrix[19][0] = 4'b0001; // 1
        assign C1_matrix[19][1] = 4'b1111; // -1
        assign C1_matrix[19][2] = 4'b1111; // -1
        assign C1_matrix[19][3] = 4'b0001; // 1
        assign C1_matrix[19][4] = 4'b1111; // -1
        assign C1_matrix[19][5] = 4'b0000; // 0
        assign C1_matrix[19][6] = 4'b1111; // -1
        assign C1_matrix[19][7] = 4'b1111; // -1
        assign C1_matrix[19][8] = 4'b1111; // -1
        assign C1_matrix[19][9] = 4'b1111; // -1

        // Row 4 (assign C1_matrix[20][j])
        assign C1_matrix[20][0] = 4'b1111; // -1
        assign C1_matrix[20][1] = 4'b0000; // 0
        assign C1_matrix[20][2] = 4'b0001; // 1
        assign C1_matrix[20][3] = 4'b1111; // -1
        assign C1_matrix[20][4] = 4'b1111; // -1
        assign C1_matrix[20][5] = 4'b1111; // -1
        assign C1_matrix[20][6] = 4'b1111; // -1
        assign C1_matrix[20][7] = 4'b1111; // -1
        assign C1_matrix[20][8] = 4'b1111; // -1
        assign C1_matrix[20][9] = 4'b0000; // 0

        // Row 5 (assign C1_matrix[21][j])
        assign C1_matrix[21][0] = 4'b0000; // 0
        assign C1_matrix[21][1] = 4'b1111; // -1
        assign C1_matrix[21][2] = 4'b1111; // -1
        assign C1_matrix[21][3] = 4'b1111; // -1
        assign C1_matrix[21][4] = 4'b1111; // -1
        assign C1_matrix[21][5] = 4'b0000; // 0
        assign C1_matrix[21][6] = 4'b1111; // -1
        assign C1_matrix[21][7] = 4'b1111; // -1
        assign C1_matrix[21][8] = 4'b1111; // -1
        assign C1_matrix[21][9] = 4'b1111; // -1

        // Row 6 (assign C1_matrix[22][j])
        assign C1_matrix[22][0] = 4'b1111; // -1
        assign C1_matrix[22][1] = 4'b1111; // -1
        assign C1_matrix[22][2] = 4'b0001; // 1
        assign C1_matrix[22][3] = 4'b1111; // -1
        assign C1_matrix[22][4] = 4'b1111; // -1
        assign C1_matrix[22][5] = 4'b1111; // -1
        assign C1_matrix[22][6] = 4'b1111; // -1
        assign C1_matrix[22][7] = 4'b0001; // 1
        assign C1_matrix[22][8] = 4'b1111; // -1
        assign C1_matrix[22][9] = 4'b1111; // -1

        // Row 7 (assign C1_matrix[23][j])
        assign C1_matrix[23][0] = 4'b0000; // 0
        assign C1_matrix[23][1] = 4'b1111; // -1
        assign C1_matrix[23][2] = 4'b1111; // -1
        assign C1_matrix[23][3] = 4'b1111; // -1
        assign C1_matrix[23][4] = 4'b1111; // -1
        assign C1_matrix[23][5] = 4'b1111; // -1
        assign C1_matrix[23][6] = 4'b0001; // 1
        assign C1_matrix[23][7] = 4'b1111; // -1
        assign C1_matrix[23][8] = 4'b1111; // -1
        assign C1_matrix[23][9] = 4'b1111; // -1

        // Row 8 (assign C1_matrix[24][j])
        assign C1_matrix[24][0] = 4'b1111; // -1
        assign C1_matrix[24][1] = 4'b0000; // 0
        assign C1_matrix[24][2] = 4'b0001; // 1
        assign C1_matrix[24][3] = 4'b1111; // -1
        assign C1_matrix[24][4] = 4'b1111; // -1
        assign C1_matrix[24][5] = 4'b0001; // 1
        assign C1_matrix[24][6] = 4'b1111; // -1
        assign C1_matrix[24][7] = 4'b1111; // -1
        assign C1_matrix[24][8] = 4'b1111; // -1
        assign C1_matrix[24][9] = 4'b1111; // -1

 assign C1_matrix[25][0] = 4'b0000; // 0
        assign C1_matrix[25][1] = 4'b1111; // -1
        assign C1_matrix[25][2] = 4'b1111; // -1
        assign C1_matrix[25][3] = 4'b1111; // -1
        assign C1_matrix[25][4] = 4'b0000; // 0
        assign C1_matrix[25][5] = 4'b1111; // -1
        assign C1_matrix[25][6] = 4'b1111; // -1
        assign C1_matrix[25][7] = 4'b1111; // -1
        assign C1_matrix[25][8] = 4'b1111; // -1
        assign C1_matrix[25][9] = 4'b1111; // -1

        // Row 2 (assign C1_matrix[26][j])
        assign C1_matrix[26][0] = 4'b1111; // -1
        assign C1_matrix[26][1] = 4'b1111; // -1
        assign C1_matrix[26][2] = 4'b0001; // 1
        assign C1_matrix[26][3] = 4'b1111; // -1
        assign C1_matrix[26][4] = 4'b1111; // -1
        assign C1_matrix[26][5] = 4'b0000; // 0
        assign C1_matrix[26][6] = 4'b1111; // -1
        assign C1_matrix[26][7] = 4'b0001; // 1
        assign C1_matrix[26][8] = 4'b1111; // -1
        assign C1_matrix[26][9] = 4'b0000; // 0

        // Row 3 (assign C1_matrix[27][j])
        assign C1_matrix[27][0] = 4'b1111; // -1
        assign C1_matrix[27][1] = 4'b0000; // 0
        assign C1_matrix[27][2] = 4'b1111; // -1
        assign C1_matrix[27][3] = 4'b1111; // -1
        assign C1_matrix[27][4] = 4'b1111; // -1
        assign C1_matrix[27][5] = 4'b1111; // -1
        assign C1_matrix[27][6] = 4'b1111; // -1
        assign C1_matrix[27][7] = 4'b1111; // -1
         assign C1_matrix[27][8] = 4'b1111; // -1
        assign C1_matrix[27][9] = 4'b1111; // -1

        // Row 4 (assign C1_matrix[28][j])
        assign C1_matrix[28][0] = 4'b0000; // 0
        assign C1_matrix[28][1] = 4'b1111; // -1
        assign C1_matrix[28][2] = 4'b1111; // -1
        assign C1_matrix[28][3] = 4'b1111; // -1
        assign C1_matrix[28][4] = 4'b1111; // -1
        assign C1_matrix[28][5] = 4'b0000; // 0
        assign C1_matrix[28][6] = 4'b1111; // -1
        assign C1_matrix[28][7] = 4'b1111; // -1
        assign C1_matrix[28][8] = 4'b1111; // -1
        assign C1_matrix[28][9] = 4'b1111; // -1

        // Row 5 (assign C1_matrix[29][j])
        assign C1_matrix[29][0] = 4'b1111; // -1
        assign C1_matrix[29][1] = 4'b1111; // -1
        assign C1_matrix[29][2] = 4'b0000; // 0
        assign C1_matrix[29][3] = 4'b1111; // -1
        assign C1_matrix[29][4] = 4'b1111; // -1
        assign C1_matrix[29][5] = 4'b1111; // -1
        assign C1_matrix[29][6] = 4'b1111; // -1
        assign C1_matrix[29][7] = 4'b0000; // 0
        assign C1_matrix[29][8] = 4'b1111; // -1
        assign C1_matrix[29][9] = 4'b1111; // -1

        // Row 6 (assign C1_matrix[30][j])
        assign C1_matrix[30][0] = 4'b0001; // 1
        assign C1_matrix[30][1] = 4'b1111; // -1
        assign C1_matrix[30][2] = 4'b1111; // -1
        assign C1_matrix[30][3] = 4'b1111; // -1
        assign C1_matrix[30][4] = 4'b1111; // -1
        assign C1_matrix[30][5] = 4'b1111; // -1
        assign C1_matrix[30][6] = 4'b1111; // -1
        assign C1_matrix[30][7] = 4'b1111; // -1
        assign C1_matrix[30][8] = 4'b1111; // -1
        assign C1_matrix[30][9] = 4'b1111; // -1

        // Row 7 (assign C1_matrix[31][j])
        assign C1_matrix[31][0] = 4'b1111; // -1
        assign C1_matrix[31][1] = 4'b0001; // 1
        assign C1_matrix[31][2] = 4'b1111; // -1
        assign C1_matrix[31][3] = 4'b1111; // -1
        assign C1_matrix[31][4] = 4'b1111; // -1
        assign C1_matrix[31][5] = 4'b0000; // 0
        assign C1_matrix[31][6] = 4'b1111; // -1
        assign C1_matrix[31][7] = 4'b1111; // -1
        assign C1_matrix[31][8] = 4'b1111; // -1
        assign C1_matrix[31][9] = 4'b1111; // -1

 assign C1_matrix[32][0] = 4'b0000; // 0
        assign C1_matrix[32][1] = 4'b1111; // -1
        assign C1_matrix[32][2] = 4'b0000; // 0
        assign C1_matrix[32][3] = 4'b1111; // -1
        assign C1_matrix[32][4] = 4'b1111; // -1
        assign C1_matrix[32][5] = 4'b1111; // -1
        assign C1_matrix[32][6] = 4'b1111; // -1
        assign C1_matrix[32][7] = 4'b0000; // 0
        assign C1_matrix[32][8] = 4'b1111; // -1
        assign C1_matrix[32][9] = 4'b1111; // -1

        // Row 2 (assign C1_matrix[33][j])
        assign C1_matrix[33][0] = 4'b1111; // -1
        assign C1_matrix[33][1] = 4'b1111; // -1
        assign C1_matrix[33][2] = 4'b1111; // -1
        assign C1_matrix[33][3] = 4'b1111; // -1
        assign C1_matrix[33][4] = 4'b1111; // -1
        assign C1_matrix[33][5] = 4'b1111; // -1
        assign C1_matrix[33][6] = 4'b1111; // -1
        assign C1_matrix[33][7] = 4'b1111; // -1
        assign C1_matrix[33][8] = 4'b1111; // -1
        assign C1_matrix[33][9] = 4'b1111; // -1

        // Row 3 (assign C1_matrix[34][j])
        assign C1_matrix[34][0] = 4'b1111; // -1
        assign C1_matrix[34][1] = 4'b0001; // 1
        assign C1_matrix[34][2] = 4'b1111; // -1
        assign C1_matrix[34][3] = 4'b1111; // -1
        assign C1_matrix[34][4] = 4'b1111; // -1
        assign C1_matrix[34][5] = 4'b0000; // 0
        assign C1_matrix[34][6] = 4'b1111; // -1
        assign C1_matrix[34][7] = 4'b1111; // -1
        assign C1_matrix[34][8] = 4'b1111; // -1
        assign C1_matrix[34][9] = 4'b1111; // -1

        // Row 4 (assign C1_matrix[35][j])
        assign C1_matrix[35][0] = 4'b0001; // 1
        assign C1_matrix[35][1] = 4'b1111; // -1
        assign C1_matrix[35][2] = 4'b1111; // -1
        assign C1_matrix[35][3] = 4'b1111; // -1
        assign C1_matrix[35][4] = 4'b1111; // -1
        assign C1_matrix[35][5] = 4'b1111; // -1
        assign C1_matrix[35][6] = 4'b1111; // -1
        assign C1_matrix[35][7] = 4'b0000; // 0
        assign C1_matrix[35][8] = 4'b1111; // -1
        assign C1_matrix[35][9] = 4'b1111; // -1

        // Row 5 (assign C1_matrix[36][j])
        assign C1_matrix[36][0] = 4'b1111; // -1
        assign C1_matrix[36][1] = 4'b1111; // -1
        assign C1_matrix[36][2] = 4'b0000; // 0
        assign C1_matrix[36][3] = 4'b1111; // -1
        assign C1_matrix[36][4] = 4'b1111; // -1
        assign C1_matrix[36][5] = 4'b1111; // -1
        assign C1_matrix[36][6] = 4'b1111; // -1
        assign C1_matrix[36][7] = 4'b1111; // -1
        assign C1_matrix[36][8] = 4'b1111; // -1
        assign C1_matrix[36][9] = 4'b1111; // -1

        // Row 6 (assign C1_matrix[37][j])
        assign C1_matrix[37][0] = 4'b1111; // -1
        assign C1_matrix[37][1] = 4'b0001; // 1
        assign C1_matrix[37][2] = 4'b1111; // -1
        assign C1_matrix[37][3] = 4'b1111; // -1
        assign C1_matrix[37][4] = 4'b1111; // -1
        assign C1_matrix[37][5] = 4'b0001; // 1
        assign C1_matrix[37][6] = 4'b1111; // -1
        assign C1_matrix[37][7] = 4'b1111; // -1
        assign C1_matrix[37][8] = 4'b1111; // -1
        assign C1_matrix[37][9] = 4'b1111; // -1

 // Row 0
    assign D_matrix[0][0] = 4'b1111; // -1
    assign D_matrix[0][1] = 4'b0001; // 1
    assign D_matrix[0][2] = 4'b1111; // -1
    assign D_matrix[0][3] = 4'b1111; // -1
    
    // Row 1
    assign D_matrix[1][0] = 4'b1111; // -1
    assign D_matrix[1][1] = 4'b0001; // 1
    assign D_matrix[1][2] = 4'b1111; // -1
    assign D_matrix[1][3] = 4'b1111; // -1

       // Row 2
    assign D_matrix[2][0] = 4'b1111; // -1
    assign D_matrix[2][1] = 4'b0000; // 0
    assign D_matrix[2][2] = 4'b1111; // -1
    assign D_matrix[2][3] = 4'b1111; // -1
    
    // Row 3
    assign D_matrix[3][0] = 4'b1111; // -1
    assign D_matrix[3][1] = 4'b0001; // 1
    assign D_matrix[3][2] = 4'b1111; // -1
    assign D_matrix[3][3] = 4'b0000; // 0

         // Row 4
    assign D_matrix[4][0] = 4'b1111; // -1
    assign D_matrix[4][1] = 4'b1111; // -1
    assign D_matrix[4][2] = 4'b0000; // 0
    assign D_matrix[4][3] = 4'b1111; // -1
    
    // Row 5
    assign D_matrix[5][0] = 4'b0001; // 1
    assign D_matrix[5][1] = 4'b0001; // 1
    assign D_matrix[5][2] = 4'b1111; // -1
    assign D_matrix[5][3] = 4'b1111; // -1
    
 // Row 6
    assign D_matrix[6][0] = 4'b1111; // -1
    assign D_matrix[6][1] = 4'b1111; // -1
    assign D_matrix[6][2] = 4'b1111; // -1
    assign D_matrix[6][3] = 4'b1111; // -1
    
    // Row 7
    assign D_matrix[7][0] = 4'b1111; // -1
    assign D_matrix[7][1] = 4'b1111; // -1
    assign D_matrix[7][2] = 4'b1111; // -1
    assign D_matrix[7][3] = 4'b0000; // 0

       // Row 8
    assign D_matrix[8][0] = 4'b1111; // -1
    assign D_matrix[8][1] = 4'b0000; // 0
    assign D_matrix[8][2] = 4'b1111; // -1
    assign D_matrix[8][3] = 4'b1111; // -1
    
    // Row 9
    assign D_matrix[9][0] = 4'b1111; // -1
    assign D_matrix[9][1] = 4'b1111; // -1
    assign D_matrix[9][2] = 4'b1111; // -1
    assign D_matrix[9][3] = 4'b0000; // 0
    
     // Row 10
    assign D_matrix[10][0] = 4'b1111; // -1
    assign D_matrix[10][1] = 4'b0001; // 1
    assign D_matrix[10][2] = 4'b1111; // -1
    assign D_matrix[10][3] = 4'b0000; // 0
    
    // Row 11
    assign D_matrix[11][0] = 4'b0001; // 1
    assign D_matrix[11][1] = 4'b0001; // 1
    assign D_matrix[11][2] = 4'b1111; // -1
    assign D_matrix[11][3] = 4'b1111; // -1
    
   // Row 12
    assign D_matrix[12][0] = 4'b1111; // -1
    assign D_matrix[12][1] = 4'b0000; // 0
    assign D_matrix[12][2] = 4'b0000; // 0
    assign D_matrix[12][3] = 4'b1111; // -1
    
    // Row 13
    assign D_matrix[13][0] = 4'b1111; // -1
    assign D_matrix[13][1] = 4'b0000; // 0
    assign D_matrix[13][2] = 4'b0000; // 0
    assign D_matrix[13][3] = 4'b1111; // -1

         // Row 14
    assign D_matrix[14][0] = 4'b1111; // -1
    assign D_matrix[14][1] = 4'b1111; // -1
    assign D_matrix[14][2] = 4'b1111; // -1
    assign D_matrix[14][3] = 4'b1111; // -1
    
    // Row 15
    assign D_matrix[15][0] = 4'b0001; // 1
    assign D_matrix[15][1] = 4'b1111; // -1
    assign D_matrix[15][2] = 4'b1111; // -1
    assign D_matrix[15][3] = 4'b1111; // -1


 // Row 16
    assign D_matrix[16][0] = 4'b1111; // -1
    assign D_matrix[16][1] = 4'b0001; // 1
    assign D_matrix[16][2] = 4'b1111; // -1
    assign D_matrix[16][3] = 4'b1111; // -1
    
    // Row 17
    assign D_matrix[17][0] = 4'b1111; // -1
    assign D_matrix[17][1] = 4'b1111; // -1
    assign D_matrix[17][2] = 4'b1111; // -1
    assign D_matrix[17][3] = 4'b0000; // 0

       // Row 18
    assign D_matrix[18][0] = 4'b1111; // -1
    assign D_matrix[18][1] = 4'b1111; // -1
    assign D_matrix[18][2] = 4'b1111; // -1
    assign D_matrix[18][3] = 4'b1111; // -1
    
    // Row 19
    assign D_matrix[19][0] = 4'b1111; // -1
    assign D_matrix[19][1] = 4'b1111; // -1
    assign D_matrix[19][2] = 4'b1111; // -1
    assign D_matrix[19][3] = 4'b1111; // -1

        // Row 20 
        assign D_matrix[20][0] = 4'b1111; // -1
        assign D_matrix[20][1] = 4'b1111; // -1
        assign D_matrix[20][2] = 4'b1111; // -1
        assign D_matrix[20][3] = 4'b1111; // -1

        // Row 21 
        assign D_matrix[21][0] = 4'b1111; // -1
        assign D_matrix[21][1] = 4'b1111; // -1
        assign D_matrix[21][2] = 4'b1111; // -1
        assign D_matrix[21][3] = 4'b1111; // -1

         // Row 22
    assign D_matrix[22][0] = 4'b1111; // -1
    assign D_matrix[22][1] = 4'b1111; // -1
    assign D_matrix[22][2] = 4'b0000; // 0
    assign D_matrix[22][3] = 4'b0000; // 0
    
    // Row 23
    assign D_matrix[23][0] = 4'b1111; // -1
    assign D_matrix[23][1] = 4'b1111; // -1
    assign D_matrix[23][2] = 4'b1111; // -1
    assign D_matrix[23][3] = 4'b1111; // -1


assign D_matrix[24][0] = 4'b1111; // -1
        assign D_matrix[24][1] = 4'b1111; // -1
        assign D_matrix[24][2] = 4'b1111; // -1
        assign D_matrix[24][3] = 4'b1111; // -1

        // Row 2 (assign D_matrix[25][j])
        assign D_matrix[25][0] = 4'b1111; // -1
        assign D_matrix[25][1] = 4'b1111; // -1
        assign D_matrix[25][2] = 4'b1111; // -1
        assign D_matrix[25][3] = 4'b1111; // -1

        // Row 3 (assign D_matrix[26][j])
        assign D_matrix[26][0] = 4'b1111; // -1
        assign D_matrix[26][1] = 4'b1111; // -1
        assign D_matrix[26][2] = 4'b1111; // -1
        assign D_matrix[26][3] = 4'b1111; // -1

        // Row 27
    assign D_matrix[27][0] = 4'b1111; // -1
    assign D_matrix[27][1] = 4'b1111; // -1
    assign D_matrix[27][2] = 4'b1111; // -1
    assign D_matrix[27][3] = 4'b0001; // 1
    
    // Row 28
    assign D_matrix[28][0] = 4'b1111; // -1
    assign D_matrix[28][1] = 4'b1111; // -1
    assign D_matrix[28][2] = 4'b0000; // 0
    assign D_matrix[28][3] = 4'b1111; // -1

        // Row 29
    assign D_matrix[29][0] = 4'b0001; // 1
    assign D_matrix[29][1] = 4'b1111; // -1
    assign D_matrix[29][2] = 4'b1111; // -1
    assign D_matrix[29][3] = 4'b1111; // -1
    
    // Row 30
    assign D_matrix[30][0] = 4'b1111; // -1
    assign D_matrix[30][1] = 4'b1111; // -1
    assign D_matrix[30][2] = 4'b0001; // 1
    assign D_matrix[30][3] = 4'b0000; // 0

        // Row 31
    assign D_matrix[31][0] = 4'b1111; // -1
    assign D_matrix[31][1] = 4'b0001; // 1
    assign D_matrix[31][2] = 4'b1111; // -1
    assign D_matrix[31][3] = 4'b1111; // -1
    
    // Row 32
    assign D_matrix[32][0] = 4'b1111; // -1
    assign D_matrix[32][1] = 4'b1111; // -1
    assign D_matrix[32][2] = 4'b1111; // -1
    assign D_matrix[32][3] = 4'b1111; // -1

        // Row 33
    assign D_matrix[33][0] = 4'b0001; // 1
    assign D_matrix[33][1] = 4'b1111; // -1
    assign D_matrix[33][2] = 4'b1111; // -1
    assign D_matrix[33][3] = 4'b0001; // 1
    
    // Row 34
    assign D_matrix[34][0] = 4'b1111; // -1
    assign D_matrix[34][1] = 4'b0000; // 0
    assign D_matrix[34][2] = 4'b1111; // -1
    assign D_matrix[34][3] = 4'b1111; // -1

       // Row 35
    assign D_matrix[35][0] = 4'b1111; // -1
    assign D_matrix[35][1] = 4'b1111; // -1
    assign D_matrix[35][2] = 4'b0000; // 0
    assign D_matrix[35][3] = 4'b1111; // -1
    
    // Row 36
    assign D_matrix[36][0] = 4'b0001; // 1
    assign D_matrix[36][1] = 4'b1111; // -1
    assign D_matrix[36][2] = 4'b1111; // -1
    assign D_matrix[36][3] = 4'b0000; // 0
    
    // Row 37
    assign D_matrix[37][0] = 4'b1111; // -1
    assign D_matrix[37][1] = 4'b0000; // 0
    assign D_matrix[37][2] = 4'b1111; // -1
    assign D_matrix[37][3] = 4'b1111; // -1






integer i,j,M;

reg s[kb-1:0][zc-1:0];


always @(*) begin
  for (i = 0; i < kb; i = i + 1) begin
            for (j = 0; j < zc; j = j + 1) begin
                s[i][j] <= message[i*zc+j];  
            end
        end
      end
reg [zc-1:0] cyclic_s[kb-1:0];
reg [zc-1:0] cyclic_c[kb-1:0];
reg [zc-1:0] cyclic_c_2[3:0];




reg [zc-1:0] lambda[3:0];
reg [zc-1:0] value[37:0];
reg [zc-1:0] value_2[37:0];
reg [zc-1:0] pa [3:0];
reg [zc-1:0] pc [37:0];


always @(*) begin
    
    for (i = 0; i < 4; i = i + 1) begin
      lambda[i] = 'b0;
    for (j = 0; j < kb; j = j + 1) begin
      cyclic_s[j]='b0;
            if(A_matrix[i][j]==4'b1111)begin
         
          cyclic_s[j]='b0;
        
        end
            else
              for (M = 0; M < zc; M = M + 1) begin

           cyclic_s[j][M] = s[j][(M + (A_matrix[i][j]) - zc) % zc];
     
end
lambda[i] = lambda[i] ^ cyclic_s[j]; 
end
end
end


always @(*) begin
    
    for (i = 0; i < 38; i = i + 1) begin
      value[i] = 'b0;
    for (j = 0; j < kb; j = j + 1) begin
     cyclic_c[j]=6'b0;
            if( C1_matrix[i][j]==4'b1111)begin
          cyclic_c[j]='b0;
        end
            else
              for (M = 0; M < zc; M = M + 1) begin
           cyclic_c[j][M] = s[j][(M + (  C1_matrix[i][j]) - zc) % zc];
   
end
value[i] = value[i] ^ cyclic_c[j]; 
end
end
end

always @(*) begin
    
    for (i = 0; i < 38; i = i + 1) begin
     value_2[i] = 'b0;
    for (j = 0; j < 4; j = j + 1) begin
      cyclic_c_2[j]='b0;
            if(D_matrix[i][j]==4'b1111)begin
          cyclic_c_2[j]='b0;
        end
            else
              for (M = 0; M < zc; M = M + 1) begin
           cyclic_c_2[j][M] = pa[j][(M + (D_matrix[i][j]) - zc) % zc];
   
end
value_2[i] = value_2[i] ^ cyclic_c_2[j]; 
end
end
end

parameter shift=105%zc;
reg[zc-1:0]pa_c;

always @(*) begin
          if( B_matrix[0][0]==4'b0001)begin 
 pa[0]=lambda[1]^lambda[0]^lambda[2]^lambda[3];
 end
 else if ( B_matrix[1][0]==105)begin 
  pa_c=lambda[1]^lambda[0]^lambda[2]^lambda[3];
  pa[0]={pa_c[zc-(shift)-1:0], pa_c[zc-1:zc-(shift)]}; 
 end
 else begin 
    pa_c=lambda[1]^lambda[0]^lambda[2]^lambda[3];
   pa[0]={pa_c[zc-(1)-1:0], pa_c[zc-1:zc-(1)]}; 
 end
 
 if( B_matrix[0][0]==4'b0001)begin 
  pa[1]= {pa[0][zc-(1)-1:0], pa[0][zc-1:zc-(1)]}^lambda[0];
 end
 
 else begin 
 pa[1]=pa[0]^lambda[0];
 end
 
 
 if((B_matrix[0][0]==4'b0001) && (kb==22)) begin
 pa[3]={pa[0][zc-(1)-1:0], pa[0][zc-1:zc-(1)]}^lambda[3];
 end
 else if(( B_matrix[0][0]==4'b0001) && (kb==10)) begin 
  pa[3]={pa[0][zc-(1)-1:0], pa[0][zc-1:zc-(1)]}^lambda[2];
end 
else begin 
  pa[3]=pa[0]^lambda[3];
end 
 
 if(kb==10)begin 
    pa[2]=pa[1]^lambda[1];
 end
 else begin 
 pa[2]=pa[3]^lambda[2];
 end
  
end

reg enable;

always @(posedge CLK or negedge RST) 
begin
     if(!RST)
          begin
           data_out<='b0;
           Valid <= 1'b0;
           enable <= 0;
          end
     else if(ACTIVE)      
        begin 
          enable <= 1; 
          for (i = 0; i < 38; i = i + 1) 
          begin
              pc[i]=value[i]^value_2[i];
          end
        end
      else if (enable) 
        begin
          data_out <={pc[37],pc[36],pc[35],pc[34],pc[33],pc[32],pc[31],pc[30],pc[29],pc[28],pc[27],pc[26],pc[25],pc[24],pc[23],pc[22],pc[21],pc[20],pc[19],pc[18],pc[17],pc[16],pc[15],pc[14],pc[13],pc[12],pc[11],pc[10],pc[9],pc[8],pc[7],pc[6],pc[5],pc[4],pc[3],pc[2],pc[1],pc[0],pa[3],pa[2],pa[1],pa[0],message[10*zc-1:2*zc]};
          Valid <= 1'b1;
          enable <= 0;					  
        end 
      else
        begin
          Valid <= 0;
        end
end

endmodule
