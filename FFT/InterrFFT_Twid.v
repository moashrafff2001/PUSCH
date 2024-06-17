module InterFFT #(
    parameter WIDTH=18
    )(
    input clk,rst,
    input [WIDTH-1:0] di_re,
    input [WIDTH-1:0] di_im,
    input [10:0] address,
    input [4:0] pow5,
    input [8:0] pow2,
    input [7:0] pow3x5,
    input FFT3_enable,
    input FFT5_enable,
    output enable5,
    output  [WIDTH-1:0] do5_re,
    output  [WIDTH-1:0] do5_im,
    output enable3,
    output  [WIDTH-1:0] do3_re,
    output  [WIDTH-1:0] do3_im
);
wire [10:0] di_count3;
reg [10:0]di_count5;
wire [WIDTH-1:0] do_re,do_im;
wire [10:0] tw_addr3,tw_addr5;
wire [WIDTH-1:0] Twid_re3,Twid_im3,Twid_re5,Twid_im5,Twid_re,Twid_im;
reg [10:0] shift,x;
wire [17:0] tw_re_temp1,tw_re_temp2,tw_re_temp3,tw_re_temp4,tw_re_temp5,tw_re_temp6,tw_re_temp7,tw_re_temp8,tw_re_temp9,tw_re_temp10,
             tw_re_temp11,tw_re_temp12,tw_re_temp13,tw_re_temp14,tw_re_temp15,tw_re_temp16,tw_re_temp17,tw_re_temp18,tw_re_temp19,tw_re_temp20,
             tw_re_temp21,tw_re_temp22,tw_re_temp23,tw_re_temp24,tw_re_temp25,tw_re_temp26,tw_re_temp27,tw_re_temp28,tw_re_temp29,tw_re_temp30,
             tw_re_temp31,tw_re_temp32,tw_re_temp33,tw_re_temp34,tw_re_temp35,tw_re_temp36,tw_re_temp37,tw_re_temp38,tw_re_temp39;

wire [17:0] tw_im_temp1,tw_im_temp2,tw_im_temp3,tw_im_temp4,tw_im_temp5,tw_im_temp6,tw_im_temp7,tw_im_temp8,tw_im_temp9,tw_im_temp10,
             tw_im_temp11,tw_im_temp12,tw_im_temp13,tw_im_temp14,tw_im_temp15,tw_im_temp16,tw_im_temp17,tw_im_temp18,tw_im_temp19,tw_im_temp20,
             tw_im_temp21,tw_im_temp22,tw_im_temp23,tw_im_temp24,tw_im_temp25,tw_im_temp26,tw_im_temp27,tw_im_temp28,tw_im_temp29,tw_im_temp30,
             tw_im_temp31,tw_im_temp32,tw_im_temp33,tw_im_temp34,tw_im_temp35,tw_im_temp36,tw_im_temp37,tw_im_temp38,tw_im_temp39;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        di_count5 <= 0;
        shift<=0;
        x<=0;
    end
    else begin
        if (FFT5_enable) begin
            di_count5 <= di_count5==pow3x5-1 ? 0 :  di_count5 + 1;
        end
        else if (FFT3_enable &&|pow5) begin
            shift<=di_count3==(pow2*pow3x5)-1?0:address==pow3x5-1?shift+pow3x5:shift;
        end else if(FFT3_enable &&!(|pow5))begin
            x <= x==(pow2*pow3x5)-1 ? 0 :  x + 1;
        end
        else begin
            x<=x;
            di_count5<=di_count5;
        end
end
end
assign di_count3=rst?0:(FFT3_enable)?(|pow5)?address+shift:x:0;
assign tw_addr5 =   pow3x5==15 && FFT5_enable ? di_count5>4 && di_count5<10 ? di_count5-5 : di_count5>9 ? (di_count5-10)<<1 : 0 :
                    pow3x5==45 && FFT5_enable ? di_count5>4 && di_count5<10 ? di_count5-5 : di_count5>9 && di_count5<15 ? (di_count5-10)<<1 : di_count5>14 && di_count5<20 ? (di_count5-15)*3 : di_count5 > 19 && di_count5<25? (di_count5-20)*4 : di_count5>24 && di_count5<30 ? (di_count5-25)*5 : di_count5 > 29 && di_count5<35 ? (di_count5-30)*6 : di_count5>34 && di_count5<40 ? (di_count5-35)*7 : di_count5>39 && di_count5<45 ? (di_count5-40)*8 : 0:
                    pow3x5==75 && FFT5_enable ? di_count5>24 && di_count5<50 ? di_count5-25 : di_count5>49 ? (di_count5-50)<<1 : 0 :
                    pow3x5==135 && FFT5_enable ? di_count5>4 && di_count5<10 ? di_count5-5 : di_count5>9 && di_count5<15 ? (di_count5-10)<<1  : di_count5>14 && di_count5<20 ? (di_count5-15)*3  : di_count5 > 19 && di_count5<25? (di_count5-20)*4 : di_count5>24 && di_count5<30 ? (di_count5-25)*5 : di_count5 > 29 && di_count5<35 ? (di_count5-30)*6 : di_count5>34 && di_count5<40 ? (di_count5-35)*7 : di_count5>39 && di_count5<45 ? (di_count5-40)*8 : di_count5 >44 && di_count5<50 ? (di_count5-45)*9 : di_count5>49 && di_count5<55 ? (di_count5-50)*10 : di_count5>54 && di_count5<60 ? (di_count5-55)*11 : di_count5>59 && di_count5<65 ? (di_count5-60)*12 : di_count5>64 && di_count5<70 ? (di_count5-65)*13 : di_count5>69 && di_count5<75  ? (di_count5-70)*14 : di_count5>74 && di_count5<80 ? (di_count5-75)*15 : di_count5 >79 && di_count5<85 ? (di_count5-80)*16 : di_count5>84 && di_count5<90 ? (di_count5-85)*17 : di_count5>89 && di_count5<95 ? (di_count5-90)*18 : di_count5>94 && di_count5<100 ? (di_count5-95)*19 : di_count5>99 && di_count5<105 ? (di_count5-100)*20 : di_count5>104 && di_count5<110 ? (di_count5-105)*21 : di_count5>109 && di_count5<115 ? (di_count5-110)*22 : di_count5>114 && di_count5<120 ? (di_count5-115)*23 : di_count5>119 && di_count5<125 ? (di_count5-120)*24 : di_count5>124 && di_count5<130 ? (di_count5-125)*25 : di_count5>129 && di_count5<135 ? (di_count5-130)*26 : 0:             
                    pow3x5==225 && FFT5_enable ? di_count5>24 && di_count5<50 ? di_count5-25 : di_count5>49 && di_count5<75 ? (di_count5-50)<<1 : di_count5>74 && di_count5<100 ? (di_count5-75)*3 : di_count5>99 && di_count5<125 ? (di_count5-100)*4 : di_count5>124 && di_count5<150 ? (di_count5-125)*5 : di_count5>149 && di_count5<175 ? (di_count5-150)*6 : di_count5>174 && di_count5<200 ? (di_count5-175)*7 : di_count5>199 ? (di_count5-200)*8 : 0:0;

assign tw_addr3 = 
                    pow2 == 4 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 9 ? di_count3 > 8 && di_count3 < 18 ? (di_count3-9) : di_count3 > 17 && di_count3 < 27 ? (di_count3-18)*2 : di_count3 > 26 && di_count3 < 36 ? (di_count3-27)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 15 ? di_count3 > 14 && di_count3 < 30 ? (di_count3-15) : di_count3 > 29 && di_count3 < 45 ? (di_count3-30)*2 : di_count3 > 44 && di_count3 < 60 ? (di_count3-45)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 27 ? di_count3 > 26 && di_count3 < 54 ? (di_count3-27) : di_count3 > 53 && di_count3 < 81 ? (di_count3-54)*2 : di_count3 > 80 && di_count3 < 108 ? (di_count3-81)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 45 ? di_count3 > 44 && di_count3 < 90 ? (di_count3-45) : di_count3 > 89 && di_count3 < 135 ? (di_count3-90)*2 : di_count3 > 134 && di_count3 < 180 ? (di_count3-135)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 75 ? di_count3 > 74 && di_count3 < 150 ? (di_count3-75) : di_count3 > 149 && di_count3 < 225 ? (di_count3-150)*2 : di_count3 > 224 && di_count3 < 300 ? (di_count3-225)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 81 ? di_count3 > 80 && di_count3 < 162 ? (di_count3-81) : di_count3 > 161 && di_count3 < 243 ? (di_count3-162)*2 : di_count3 > 242 && di_count3 < 324 ? (di_count3-243)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 135 ? di_count3 > 134 && di_count3 < 270 ? (di_count3-135) : di_count3 > 269 && di_count3 < 405 ? (di_count3-270)*2 : di_count3 > 404 && di_count3 < 540 ? (di_count3-405)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 225 ? di_count3 > 224 && di_count3 < 450 ? (di_count3-225) : di_count3 > 449 && di_count3 < 675 ? (di_count3-450)*2 : di_count3 > 674 && di_count3 < 900 ? (di_count3-675)*3 : 0 :
                    pow2 == 4 && FFT3_enable && pow3x5 == 243 ? di_count3 > 242 && di_count3 < 486 ? (di_count3-243) : di_count3 > 485 && di_count3 < 729 ? (di_count3-486)*2 : di_count3 > 728 && di_count3 < 972 ? (di_count3-729)*3 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : di_count3 > 11 && di_count3 < 15 ? (di_count3-12)*4 : di_count3 > 14 && di_count3 < 18 ? (di_count3-15)*5 : di_count3 > 17 && di_count3 < 21 ? (di_count3-18)*6 : di_count3 > 20 && di_count3 < 24 ? (di_count3-21)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 9 ? di_count3 > 8 && di_count3 < 18 ? (di_count3-9) : di_count3 > 17 && di_count3 < 27 ? (di_count3-18)*2 : di_count3 > 26 && di_count3 < 36 ? (di_count3-27)*3 : di_count3 > 35 && di_count3 < 45 ? (di_count3-36)*4 : di_count3 > 44 && di_count3 < 54 ? (di_count3-45)*5 : di_count3 > 53 && di_count3 < 63 ? (di_count3-54)*6 : di_count3 > 62 && di_count3 < 72 ? (di_count3-63)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 15 ? di_count3 > 14 && di_count3 < 30 ? (di_count3-15) : di_count3 > 29 && di_count3 < 45 ? (di_count3-30)*2 : di_count3 > 44 && di_count3 < 60 ? (di_count3-45)*3 : di_count3 > 59 && di_count3 < 75 ? (di_count3-60)*4 : di_count3 > 74 && di_count3 < 90 ? (di_count3-75)*5 : di_count3 > 89 && di_count3 < 105 ? (di_count3-90)*6 : di_count3 > 104 && di_count3 < 120 ? (di_count3-105)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 27 ? di_count3 > 26 && di_count3 < 54 ? (di_count3-27) : di_count3 > 53 && di_count3 < 81 ? (di_count3-54)*2 : di_count3 > 80 && di_count3 < 108 ? (di_count3-81)*3 : di_count3 > 107 && di_count3 < 135 ? (di_count3-108)*4 : di_count3 > 134 && di_count3 < 162 ? (di_count3-135)*5 : di_count3 > 161 && di_count3 < 189 ? (di_count3-162)*6 : di_count3 > 188 && di_count3 < 216 ? (di_count3-189)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 45 ? di_count3 > 44 && di_count3 < 90 ? (di_count3-45) : di_count3 > 89 && di_count3 < 135 ? (di_count3-90)*2 : di_count3 > 134 && di_count3 < 180 ? (di_count3-135)*3 : di_count3 > 179 && di_count3 < 225 ? (di_count3-180)*4 : di_count3 > 224 && di_count3 < 270 ? (di_count3-225)*5 : di_count3 > 269 && di_count3 < 315 ? (di_count3-270)*6 : di_count3 > 314 && di_count3 < 360 ? (di_count3-315)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 75 ? di_count3 > 74 && di_count3 < 150 ? (di_count3-75) : di_count3 > 149 && di_count3 < 225 ? (di_count3-150)*2 : di_count3 > 224 && di_count3 < 300 ? (di_count3-225)*3 : di_count3 > 299 && di_count3 < 375 ? (di_count3-300)*4 : di_count3 > 374 && di_count3 < 450 ? (di_count3-375)*5 : di_count3 > 449 && di_count3 < 525 ? (di_count3-450)*6 : di_count3 > 524 && di_count3 < 600 ? (di_count3-525)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 81 ? di_count3 > 80 && di_count3 < 162 ? (di_count3-81) : di_count3 > 161 && di_count3 < 243 ? (di_count3-162)*2 : di_count3 > 242 && di_count3 < 324 ? (di_count3-243)*3 : di_count3 > 323 && di_count3 < 405 ? (di_count3-324)*4 : di_count3 > 404 && di_count3 < 486 ? (di_count3-405)*5 : di_count3 > 485 && di_count3 < 567 ? (di_count3-486)*6 : di_count3 > 566 && di_count3 < 648 ? (di_count3-567)*7 : 0 :
                    pow2 == 8 && FFT3_enable && pow3x5 == 135 ? di_count3 > 134 && di_count3 < 270 ? (di_count3-135) : di_count3 > 269 && di_count3 < 405 ? (di_count3-270)*2 : di_count3 > 404 && di_count3 < 540 ? (di_count3-405)*3 : di_count3 > 539 && di_count3 < 675 ? (di_count3-540)*4 : di_count3 > 674 && di_count3 < 810 ? (di_count3-675)*5 : di_count3 > 809 && di_count3 < 945 ? (di_count3-810)*6 : di_count3 > 944 && di_count3 < 1080 ? (di_count3-945)*7 : 0 :
                    pow2 == 16 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : di_count3 > 11 && di_count3 < 15 ? (di_count3-12)*4 : di_count3 > 14 && di_count3 < 18 ? (di_count3-15)*5 : di_count3 > 17 && di_count3 < 21 ? (di_count3-18)*6 : di_count3 > 20 && di_count3 < 24 ? (di_count3-21)*7 : di_count3 > 23 && di_count3 < 27 ? (di_count3-24)*8 : di_count3 > 26 && di_count3 < 30 ? (di_count3-27)*9 : di_count3 > 29 && di_count3 < 33 ? (di_count3-30)*10 : di_count3 > 32 && di_count3 < 36 ? (di_count3-33)*11 : di_count3 > 35 && di_count3 < 39 ? (di_count3-36)*12 : di_count3 > 38 && di_count3 < 42 ? (di_count3-39)*13 : di_count3 > 41 && di_count3 < 45 ? (di_count3-42)*14 : di_count3 > 44 && di_count3 < 48 ? (di_count3-45)*15 : 0 :
                    pow2 == 16 && FFT3_enable && pow3x5 == 9 ? di_count3 > 8 && di_count3 < 18 ? (di_count3-9) : di_count3 > 17 && di_count3 < 27 ? (di_count3-18)*2 : di_count3 > 26 && di_count3 < 36 ? (di_count3-27)*3 : di_count3 > 35 && di_count3 < 45 ? (di_count3-36)*4 : di_count3 > 44 && di_count3 < 54 ? (di_count3-45)*5 : di_count3 > 53 && di_count3 < 63 ? (di_count3-54)*6 : di_count3 > 62 && di_count3 < 72 ? (di_count3-63)*7 : di_count3 > 71 && di_count3 < 81 ? (di_count3-72)*8 : di_count3 > 80 && di_count3 < 90 ? (di_count3-81)*9 : di_count3 > 89 && di_count3 < 99 ? (di_count3-90)*10 : di_count3 > 98 && di_count3 < 108 ? (di_count3-99)*11 : di_count3 > 107 && di_count3 < 117 ? (di_count3-108)*12 : di_count3 > 116 && di_count3 < 126 ? (di_count3-117)*13 : di_count3 > 125 && di_count3 < 135 ? (di_count3-126)*14 : di_count3 > 134 && di_count3 < 144 ? (di_count3-135)*15 : 0 :
                    pow2 == 16 && FFT3_enable && pow3x5 == 15 ? di_count3 > 14 && di_count3 < 30 ? (di_count3-15) : di_count3 > 29 && di_count3 < 45 ? (di_count3-30)*2 : di_count3 > 44 && di_count3 < 60 ? (di_count3-45)*3 : di_count3 > 59 && di_count3 < 75 ? (di_count3-60)*4 : di_count3 > 74 && di_count3 < 90 ? (di_count3-75)*5 : di_count3 > 89 && di_count3 < 105 ? (di_count3-90)*6 : di_count3 > 104 && di_count3 < 120 ? (di_count3-105)*7 : di_count3 > 119 && di_count3 < 135 ? (di_count3-120)*8 : di_count3 > 134 && di_count3 < 150 ? (di_count3-135)*9 : di_count3 > 149 && di_count3 < 165 ? (di_count3-150)*10 : di_count3 > 164 && di_count3 < 180 ? (di_count3-165)*11 : di_count3 > 179 && di_count3 < 195 ? (di_count3-180)*12 : di_count3 > 194 && di_count3 < 210 ? (di_count3-195)*13 : di_count3 > 209 && di_count3 < 225 ? (di_count3-210)*14 : di_count3 > 224 && di_count3 < 240 ? (di_count3-225)*15 : 0 :
                    pow2 == 16 && FFT3_enable && pow3x5 == 27 ? di_count3 > 26 && di_count3 < 54 ? (di_count3-27) : di_count3 > 53 && di_count3 < 81 ? (di_count3-54)*2 : di_count3 > 80 && di_count3 < 108 ? (di_count3-81)*3 : di_count3 > 107 && di_count3 < 135 ? (di_count3-108)*4 : di_count3 > 134 && di_count3 < 162 ? (di_count3-135)*5 : di_count3 > 161 && di_count3 < 189 ? (di_count3-162)*6 : di_count3 > 188 && di_count3 < 216 ? (di_count3-189)*7 : di_count3 > 215 && di_count3 < 243 ? (di_count3-216)*8 : di_count3 > 242 && di_count3 < 270 ? (di_count3-243)*9 : di_count3 > 269 && di_count3 < 297 ? (di_count3-270)*10 : di_count3 > 296 && di_count3 < 324 ? (di_count3-297)*11 : di_count3 > 323 && di_count3 < 351 ? (di_count3-324)*12 : di_count3 > 350 && di_count3 < 378 ? (di_count3-351)*13 : di_count3 > 377 && di_count3 < 405 ? (di_count3-378)*14 : di_count3 > 404 && di_count3 < 432 ? (di_count3-405)*15 : 0 :
                    pow2 == 16 && FFT3_enable && pow3x5 == 45 ? di_count3 > 44 && di_count3 < 90 ? (di_count3-45) : di_count3 > 89 && di_count3 < 135 ? (di_count3-90)*2 : di_count3 > 134 && di_count3 < 180 ? (di_count3-135)*3 : di_count3 > 179 && di_count3 < 225 ? (di_count3-180)*4 : di_count3 > 224 && di_count3 < 270 ? (di_count3-225)*5 : di_count3 > 269 && di_count3 < 315 ? (di_count3-270)*6 : di_count3 > 314 && di_count3 < 360 ? (di_count3-315)*7 : di_count3 > 359 && di_count3 < 405 ? (di_count3-360)*8 : di_count3 > 404 && di_count3 < 450 ? (di_count3-405)*9 : di_count3 > 449 && di_count3 < 495 ? (di_count3-450)*10 : di_count3 > 494 && di_count3 < 540 ? (di_count3-495)*11 : di_count3 > 539 && di_count3 < 585 ? (di_count3-540)*12 : di_count3 > 584 && di_count3 < 630 ? (di_count3-585)*13 : di_count3 > 629 && di_count3 < 675 ? (di_count3-630)*14 : di_count3 > 674 && di_count3 < 720 ? (di_count3-675)*15 : 0 :
                    pow2 == 16 && FFT3_enable && pow3x5 == 75 ? di_count3 > 74 && di_count3 < 150 ? (di_count3-75) : di_count3 > 149 && di_count3 < 225 ? (di_count3-150)*2 : di_count3 > 224 && di_count3 < 300 ? (di_count3-225)*3 : di_count3 > 299 && di_count3 < 375 ? (di_count3-300)*4 : di_count3 > 374 && di_count3 < 450 ? (di_count3-375)*5 : di_count3 > 449 && di_count3 < 525 ? (di_count3-450)*6 : di_count3 > 524 && di_count3 < 600 ? (di_count3-525)*7 : di_count3 > 599 && di_count3 < 675 ? (di_count3-600)*8 : di_count3 > 674 && di_count3 < 750 ? (di_count3-675)*9 : di_count3 > 749 && di_count3 < 825 ? (di_count3-750)*10 : di_count3 > 824 && di_count3 < 900 ? (di_count3-825)*11 : di_count3 > 899 && di_count3 < 975 ? (di_count3-900)*12 : di_count3 > 974 && di_count3 < 1050 ? (di_count3-975)*13 : di_count3 > 1049 && di_count3 < 1125 ? (di_count3-1050)*14 : di_count3 > 1124 && di_count3 < 1200 ? (di_count3-1125)*15 : 0 :
                    pow2 == 32 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : di_count3 > 11 && di_count3 < 15 ? (di_count3-12)*4 : di_count3 > 14 && di_count3 < 18 ? (di_count3-15)*5 : di_count3 > 17 && di_count3 < 21 ? (di_count3-18)*6 : di_count3 > 20 && di_count3 < 24 ? (di_count3-21)*7 : di_count3 > 23 && di_count3 < 27 ? (di_count3-24)*8 : di_count3 > 26 && di_count3 < 30 ? (di_count3-27)*9 : di_count3 > 29 && di_count3 < 33 ? (di_count3-30)*10 : di_count3 > 32 && di_count3 < 36 ? (di_count3-33)*11 : di_count3 > 35 && di_count3 < 39 ? (di_count3-36)*12 : di_count3 > 38 && di_count3 < 42 ? (di_count3-39)*13 : di_count3 > 41 && di_count3 < 45 ? (di_count3-42)*14 : di_count3 > 44 && di_count3 < 48 ? (di_count3-45)*15 : di_count3 > 47 && di_count3 < 51 ? (di_count3-48)*16 : di_count3 > 50 && di_count3 < 54 ? (di_count3-51)*17 : di_count3 > 53 && di_count3 < 57 ? (di_count3-54)*18 : di_count3 > 56 && di_count3 < 60 ? (di_count3-57)*19 : di_count3 > 59 && di_count3 < 63 ? (di_count3-60)*20 : di_count3 > 62 && di_count3 < 66 ? (di_count3-63)*21 : di_count3 > 65 && di_count3 < 69 ? (di_count3-66)*22 : di_count3 > 68 && di_count3 < 72 ? (di_count3-69)*23 : di_count3 > 71 && di_count3 < 75 ? (di_count3-72)*24 : di_count3 > 74 && di_count3 < 78 ? (di_count3-75)*25 : di_count3 > 77 && di_count3 < 81 ? (di_count3-78)*26 : di_count3 > 80 && di_count3 < 84 ? (di_count3-81)*27 : di_count3 > 83 && di_count3 < 87 ? (di_count3-84)*28 : di_count3 > 86 && di_count3 < 90 ? (di_count3-87)*29 : di_count3 > 89 && di_count3 < 93 ? (di_count3-90)*30 : di_count3 > 92 && di_count3 < 96 ? (di_count3-93)*31 : 0 :
                    pow2 == 32 && FFT3_enable && pow3x5 == 9 ? di_count3 > 8 && di_count3 < 18 ? (di_count3-9) : di_count3 > 17 && di_count3 < 27 ? (di_count3-18)*2 : di_count3 > 26 && di_count3 < 36 ? (di_count3-27)*3 : di_count3 > 35 && di_count3 < 45 ? (di_count3-36)*4 : di_count3 > 44 && di_count3 < 54 ? (di_count3-45)*5 : di_count3 > 53 && di_count3 < 63 ? (di_count3-54)*6 : di_count3 > 62 && di_count3 < 72 ? (di_count3-63)*7 : di_count3 > 71 && di_count3 < 81 ? (di_count3-72)*8 : di_count3 > 80 && di_count3 < 90 ? (di_count3-81)*9 : di_count3 > 89 && di_count3 < 99 ? (di_count3-90)*10 : di_count3 > 98 && di_count3 < 108 ? (di_count3-99)*11 : di_count3 > 107 && di_count3 < 117 ? (di_count3-108)*12 : di_count3 > 116 && di_count3 < 126 ? (di_count3-117)*13 : di_count3 > 125 && di_count3 < 135 ? (di_count3-126)*14 : di_count3 > 134 && di_count3 < 144 ? (di_count3-135)*15 : di_count3 > 143 && di_count3 < 153 ? (di_count3-144)*16 : di_count3 > 152 && di_count3 < 162 ? (di_count3-153)*17 : di_count3 > 161 && di_count3 < 171 ? (di_count3-162)*18 : di_count3 > 170 && di_count3 < 180 ? (di_count3-171)*19 : di_count3 > 179 && di_count3 < 189 ? (di_count3-180)*20 : di_count3 > 188 && di_count3 < 198 ? (di_count3-189)*21 : di_count3 > 197 && di_count3 < 207 ? (di_count3-198)*22 : di_count3 > 206 && di_count3 < 216 ? (di_count3-207)*23 : di_count3 > 215 && di_count3 < 225 ? (di_count3-216)*24 : di_count3 > 224 && di_count3 < 234 ? (di_count3-225)*25 : di_count3 > 233 && di_count3 < 243 ? (di_count3-234)*26 : di_count3 > 242 && di_count3 < 252 ? (di_count3-243)*27 : di_count3 > 251 && di_count3 < 261 ? (di_count3-252)*28 : di_count3 > 260 && di_count3 < 270 ? (di_count3-261)*29 : di_count3 > 269 && di_count3 < 279 ? (di_count3-270)*30 : di_count3 > 278 && di_count3 < 288 ? (di_count3-279)*31 : 0 :
                    pow2 == 32 && FFT3_enable && pow3x5 == 15 ? di_count3 > 14 && di_count3 < 30 ? (di_count3-15) : di_count3 > 29 && di_count3 < 45 ? (di_count3-30)*2 : di_count3 > 44 && di_count3 < 60 ? (di_count3-45)*3 : di_count3 > 59 && di_count3 < 75 ? (di_count3-60)*4 : di_count3 > 74 && di_count3 < 90 ? (di_count3-75)*5 : di_count3 > 89 && di_count3 < 105 ? (di_count3-90)*6 : di_count3 > 104 && di_count3 < 120 ? (di_count3-105)*7 : di_count3 > 119 && di_count3 < 135 ? (di_count3-120)*8 : di_count3 > 134 && di_count3 < 150 ? (di_count3-135)*9 : di_count3 > 149 && di_count3 < 165 ? (di_count3-150)*10 : di_count3 > 164 && di_count3 < 180 ? (di_count3-165)*11 : di_count3 > 179 && di_count3 < 195 ? (di_count3-180)*12 : di_count3 > 194 && di_count3 < 210 ? (di_count3-195)*13 : di_count3 > 209 && di_count3 < 225 ? (di_count3-210)*14 : di_count3 > 224 && di_count3 < 240 ? (di_count3-225)*15 : di_count3 > 239 && di_count3 < 255 ? (di_count3-240)*16 : di_count3 > 254 && di_count3 < 270 ? (di_count3-255)*17 : di_count3 > 269 && di_count3 < 285 ? (di_count3-270)*18 : di_count3 > 284 && di_count3 < 300 ? (di_count3-285)*19 : di_count3 > 299 && di_count3 < 315 ? (di_count3-300)*20 : di_count3 > 314 && di_count3 < 330 ? (di_count3-315)*21 : di_count3 > 329 && di_count3 < 345 ? (di_count3-330)*22 : di_count3 > 344 && di_count3 < 360 ? (di_count3-345)*23 : di_count3 > 359 && di_count3 < 375 ? (di_count3-360)*24 : di_count3 > 374 && di_count3 < 390 ? (di_count3-375)*25 : di_count3 > 389 && di_count3 < 405 ? (di_count3-390)*26 : di_count3 > 404 && di_count3 < 420 ? (di_count3-405)*27 : di_count3 > 419 && di_count3 < 435 ? (di_count3-420)*28 : di_count3 > 434 && di_count3 < 450 ? (di_count3-435)*29 : di_count3 > 449 && di_count3 < 465 ? (di_count3-450)*30 : di_count3 > 464 && di_count3 < 480 ? (di_count3-465)*31 : 0 :
                    pow2 == 32 && FFT3_enable && pow3x5 == 27 ? di_count3 > 26 && di_count3 < 54 ? (di_count3-27) : di_count3 > 53 && di_count3 < 81 ? (di_count3-54)*2 : di_count3 > 80 && di_count3 < 108 ? (di_count3-81)*3 : di_count3 > 107 && di_count3 < 135 ? (di_count3-108)*4 : di_count3 > 134 && di_count3 < 162 ? (di_count3-135)*5 : di_count3 > 161 && di_count3 < 189 ? (di_count3-162)*6 : di_count3 > 188 && di_count3 < 216 ? (di_count3-189)*7 : di_count3 > 215 && di_count3 < 243 ? (di_count3-216)*8 : di_count3 > 242 && di_count3 < 270 ? (di_count3-243)*9 : di_count3 > 269 && di_count3 < 297 ? (di_count3-270)*10 : di_count3 > 296 && di_count3 < 324 ? (di_count3-297)*11 : di_count3 > 323 && di_count3 < 351 ? (di_count3-324)*12 : di_count3 > 350 && di_count3 < 378 ? (di_count3-351)*13 : di_count3 > 377 && di_count3 < 405 ? (di_count3-378)*14 : di_count3 > 404 && di_count3 < 432 ? (di_count3-405)*15 : di_count3 > 431 && di_count3 < 459 ? (di_count3-432)*16 : di_count3 > 458 && di_count3 < 486 ? (di_count3-459)*17 : di_count3 > 485 && di_count3 < 513 ? (di_count3-486)*18 : di_count3 > 512 && di_count3 < 540 ? (di_count3-513)*19 : di_count3 > 539 && di_count3 < 567 ? (di_count3-540)*20 : di_count3 > 566 && di_count3 < 594 ? (di_count3-567)*21 : di_count3 > 593 && di_count3 < 621 ? (di_count3-594)*22 : di_count3 > 620 && di_count3 < 648 ? (di_count3-621)*23 : di_count3 > 647 && di_count3 < 675 ? (di_count3-648)*24 : di_count3 > 674 && di_count3 < 702 ? (di_count3-675)*25 : di_count3 > 701 && di_count3 < 729 ? (di_count3-702)*26 : di_count3 > 728 && di_count3 < 756 ? (di_count3-729)*27 : di_count3 > 755 && di_count3 < 783 ? (di_count3-756)*28 : di_count3 > 782 && di_count3 < 810 ? (di_count3-783)*29 : di_count3 > 809 && di_count3 < 837 ? (di_count3-810)*30 : di_count3 > 836 && di_count3 < 864 ? (di_count3-837)*31 : 0 :
                    pow2 == 64 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : di_count3 > 11 && di_count3 < 15 ? (di_count3-12)*4 : di_count3 > 14 && di_count3 < 18 ? (di_count3-15)*5 : di_count3 > 17 && di_count3 < 21 ? (di_count3-18)*6 : di_count3 > 20 && di_count3 < 24 ? (di_count3-21)*7 : di_count3 > 23 && di_count3 < 27 ? (di_count3-24)*8 : di_count3 > 26 && di_count3 < 30 ? (di_count3-27)*9 : di_count3 > 29 && di_count3 < 33 ? (di_count3-30)*10 : di_count3 > 32 && di_count3 < 36 ? (di_count3-33)*11 : di_count3 > 35 && di_count3 < 39 ? (di_count3-36)*12 : di_count3 > 38 && di_count3 < 42 ? (di_count3-39)*13 : di_count3 > 41 && di_count3 < 45 ? (di_count3-42)*14 : di_count3 > 44 && di_count3 < 48 ? (di_count3-45)*15 : di_count3 > 47 && di_count3 < 51 ? (di_count3-48)*16 : di_count3 > 50 && di_count3 < 54 ? (di_count3-51)*17 : di_count3 > 53 && di_count3 < 57 ? (di_count3-54)*18 : di_count3 > 56 && di_count3 < 60 ? (di_count3-57)*19 : di_count3 > 59 && di_count3 < 63 ? (di_count3-60)*20 : di_count3 > 62 && di_count3 < 66 ? (di_count3-63)*21 : di_count3 > 65 && di_count3 < 69 ? (di_count3-66)*22 : di_count3 > 68 && di_count3 < 72 ? (di_count3-69)*23 : di_count3 > 71 && di_count3 < 75 ? (di_count3-72)*24 : di_count3 > 74 && di_count3 < 78 ? (di_count3-75)*25 : di_count3 > 77 && di_count3 < 81 ? (di_count3-78)*26 : di_count3 > 80 && di_count3 < 84 ? (di_count3-81)*27 : di_count3 > 83 && di_count3 < 87 ? (di_count3-84)*28 : di_count3 > 86 && di_count3 < 90 ? (di_count3-87)*29 : di_count3 > 89 && di_count3 < 93 ? (di_count3-90)*30 : di_count3 > 92 && di_count3 < 96 ? (di_count3-93)*31 : di_count3 > 95 && di_count3 < 99 ? (di_count3-96)*32 : di_count3 > 98 && di_count3 < 102 ? (di_count3-99)*33 : di_count3 > 101 && di_count3 < 105 ? (di_count3-102)*34 : di_count3 > 104 && di_count3 < 108 ? (di_count3-105)*35 : di_count3 > 107 && di_count3 < 111 ? (di_count3-108)*36 : di_count3 > 110 && di_count3 < 114 ? (di_count3-111)*37 : di_count3 > 113 && di_count3 < 117 ? (di_count3-114)*38 : di_count3 > 116 && di_count3 < 120 ? (di_count3-117)*39 : di_count3 > 119 && di_count3 < 123 ? (di_count3-120)*40 : di_count3 > 122 && di_count3 < 126 ? (di_count3-123)*41 : di_count3 > 125 && di_count3 < 129 ? (di_count3-126)*42 : di_count3 > 128 && di_count3 < 132 ? (di_count3-129)*43 : di_count3 > 131 && di_count3 < 135 ? (di_count3-132)*44 : di_count3 > 134 && di_count3 < 138 ? (di_count3-135)*45 : di_count3 > 137 && di_count3 < 141 ? (di_count3-138)*46 : di_count3 > 140 && di_count3 < 144 ? (di_count3-141)*47 : di_count3 > 143 && di_count3 < 147 ? (di_count3-144)*48 : di_count3 > 146 && di_count3 < 150 ? (di_count3-147)*49 : di_count3 > 149 && di_count3 < 153 ? (di_count3-150)*50 : di_count3 > 152 && di_count3 < 156 ? (di_count3-153)*51 : di_count3 > 155 && di_count3 < 159 ? (di_count3-156)*52 : di_count3 > 158 && di_count3 < 162 ? (di_count3-159)*53 : di_count3 > 161 && di_count3 < 165 ? (di_count3-162)*54 : di_count3 > 164 && di_count3 < 168 ? (di_count3-165)*55 : di_count3 > 167 && di_count3 < 171 ? (di_count3-168)*56 : di_count3 > 170 && di_count3 < 174 ? (di_count3-171)*57 : di_count3 > 173 && di_count3 < 177 ? (di_count3-174)*58 : di_count3 > 176 && di_count3 < 180 ? (di_count3-177)*59 : di_count3 > 179 && di_count3 < 183 ? (di_count3-180)*60 : di_count3 > 182 && di_count3 < 186 ? (di_count3-183)*61 : di_count3 > 185 && di_count3 < 189 ? (di_count3-186)*62 : di_count3 > 188 && di_count3 < 192 ? (di_count3-189)*63 : 0 :
                    pow2 == 64 && FFT3_enable && pow3x5 == 9 ? di_count3 > 8 && di_count3 < 18 ? (di_count3-9) : di_count3 > 17 && di_count3 < 27 ? (di_count3-18)*2 : di_count3 > 26 && di_count3 < 36 ? (di_count3-27)*3 : di_count3 > 35 && di_count3 < 45 ? (di_count3-36)*4 : di_count3 > 44 && di_count3 < 54 ? (di_count3-45)*5 : di_count3 > 53 && di_count3 < 63 ? (di_count3-54)*6 : di_count3 > 62 && di_count3 < 72 ? (di_count3-63)*7 : di_count3 > 71 && di_count3 < 81 ? (di_count3-72)*8 : di_count3 > 80 && di_count3 < 90 ? (di_count3-81)*9 : di_count3 > 89 && di_count3 < 99 ? (di_count3-90)*10 : di_count3 > 98 && di_count3 < 108 ? (di_count3-99)*11 : di_count3 > 107 && di_count3 < 117 ? (di_count3-108)*12 : di_count3 > 116 && di_count3 < 126 ? (di_count3-117)*13 : di_count3 > 125 && di_count3 < 135 ? (di_count3-126)*14 : di_count3 > 134 && di_count3 < 144 ? (di_count3-135)*15 : di_count3 > 143 && di_count3 < 153 ? (di_count3-144)*16 : di_count3 > 152 && di_count3 < 162 ? (di_count3-153)*17 : di_count3 > 161 && di_count3 < 171 ? (di_count3-162)*18 : di_count3 > 170 && di_count3 < 180 ? (di_count3-171)*19 : di_count3 > 179 && di_count3 < 189 ? (di_count3-180)*20 : di_count3 > 188 && di_count3 < 198 ? (di_count3-189)*21 : di_count3 > 197 && di_count3 < 207 ? (di_count3-198)*22 : di_count3 > 206 && di_count3 < 216 ? (di_count3-207)*23 : di_count3 > 215 && di_count3 < 225 ? (di_count3-216)*24 : di_count3 > 224 && di_count3 < 234 ? (di_count3-225)*25 : di_count3 > 233 && di_count3 < 243 ? (di_count3-234)*26 : di_count3 > 242 && di_count3 < 252 ? (di_count3-243)*27 : di_count3 > 251 && di_count3 < 261 ? (di_count3-252)*28 : di_count3 > 260 && di_count3 < 270 ? (di_count3-261)*29 : di_count3 > 269 && di_count3 < 279 ? (di_count3-270)*30 : di_count3 > 278 && di_count3 < 288 ? (di_count3-279)*31 : di_count3 > 287 && di_count3 < 297 ? (di_count3-288)*32 : di_count3 > 296 && di_count3 < 306 ? (di_count3-297)*33 : di_count3 > 305 && di_count3 < 315 ? (di_count3-306)*34 : di_count3 > 314 && di_count3 < 324 ? (di_count3-315)*35 : di_count3 > 323 && di_count3 < 333 ? (di_count3-324)*36 : di_count3 > 332 && di_count3 < 342 ? (di_count3-333)*37 : di_count3 > 341 && di_count3 < 351 ? (di_count3-342)*38 : di_count3 > 350 && di_count3 < 360 ? (di_count3-351)*39 : di_count3 > 359 && di_count3 < 369 ? (di_count3-360)*40 : di_count3 > 368 && di_count3 < 378 ? (di_count3-369)*41 : di_count3 > 377 && di_count3 < 387 ? (di_count3-378)*42 : di_count3 > 386 && di_count3 < 396 ? (di_count3-387)*43 : di_count3 > 395 && di_count3 < 405 ? (di_count3-396)*44 : di_count3 > 404 && di_count3 < 414 ? (di_count3-405)*45 : di_count3 > 413 && di_count3 < 423 ? (di_count3-414)*46 : di_count3 > 422 && di_count3 < 432 ? (di_count3-423)*47 : di_count3 > 431 && di_count3 < 441 ? (di_count3-432)*48 : di_count3 > 440 && di_count3 < 450 ? (di_count3-441)*49 : di_count3 > 449 && di_count3 < 459 ? (di_count3-450)*50 : di_count3 > 458 && di_count3 < 468 ? (di_count3-459)*51 : di_count3 > 467 && di_count3 < 477 ? (di_count3-468)*52 : di_count3 > 476 && di_count3 < 486 ? (di_count3-477)*53 : di_count3 > 485 && di_count3 < 495 ? (di_count3-486)*54 : di_count3 > 494 && di_count3 < 504 ? (di_count3-495)*55 : di_count3 > 503 && di_count3 < 513 ? (di_count3-504)*56 : di_count3 > 512 && di_count3 < 522 ? (di_count3-513)*57 : di_count3 > 521 && di_count3 < 531 ? (di_count3-522)*58 : di_count3 > 530 && di_count3 < 540 ? (di_count3-531)*59 : di_count3 > 539 && di_count3 < 549 ? (di_count3-540)*60 : di_count3 > 548 && di_count3 < 558 ? (di_count3-549)*61 : di_count3 > 557 && di_count3 < 567 ? (di_count3-558)*62 : di_count3 > 566 && di_count3 < 576 ? (di_count3-567)*63 : 0 :
                    pow2 == 64 && FFT3_enable && pow3x5 == 15 ? di_count3 > 14 && di_count3 < 30 ? (di_count3-15) : di_count3 > 29 && di_count3 < 45 ? (di_count3-30)*2 : di_count3 > 44 && di_count3 < 60 ? (di_count3-45)*3 : di_count3 > 59 && di_count3 < 75 ? (di_count3-60)*4 : di_count3 > 74 && di_count3 < 90 ? (di_count3-75)*5 : di_count3 > 89 && di_count3 < 105 ? (di_count3-90)*6 : di_count3 > 104 && di_count3 < 120 ? (di_count3-105)*7 : di_count3 > 119 && di_count3 < 135 ? (di_count3-120)*8 : di_count3 > 134 && di_count3 < 150 ? (di_count3-135)*9 : di_count3 > 149 && di_count3 < 165 ? (di_count3-150)*10 : di_count3 > 164 && di_count3 < 180 ? (di_count3-165)*11 : di_count3 > 179 && di_count3 < 195 ? (di_count3-180)*12 : di_count3 > 194 && di_count3 < 210 ? (di_count3-195)*13 : di_count3 > 209 && di_count3 < 225 ? (di_count3-210)*14 : di_count3 > 224 && di_count3 < 240 ? (di_count3-225)*15 : di_count3 > 239 && di_count3 < 255 ? (di_count3-240)*16 : di_count3 > 254 && di_count3 < 270 ? (di_count3-255)*17 : di_count3 > 269 && di_count3 < 285 ? (di_count3-270)*18 : di_count3 > 284 && di_count3 < 300 ? (di_count3-285)*19 : di_count3 > 299 && di_count3 < 315 ? (di_count3-300)*20 : di_count3 > 314 && di_count3 < 330 ? (di_count3-315)*21 : di_count3 > 329 && di_count3 < 345 ? (di_count3-330)*22 : di_count3 > 344 && di_count3 < 360 ? (di_count3-345)*23 : di_count3 > 359 && di_count3 < 375 ? (di_count3-360)*24 : di_count3 > 374 && di_count3 < 390 ? (di_count3-375)*25 : di_count3 > 389 && di_count3 < 405 ? (di_count3-390)*26 : di_count3 > 404 && di_count3 < 420 ? (di_count3-405)*27 : di_count3 > 419 && di_count3 < 435 ? (di_count3-420)*28 : di_count3 > 434 && di_count3 < 450 ? (di_count3-435)*29 : di_count3 > 449 && di_count3 < 465 ? (di_count3-450)*30 : di_count3 > 464 && di_count3 < 480 ? (di_count3-465)*31 : di_count3 > 479 && di_count3 < 495 ? (di_count3-480)*32 : di_count3 > 494 && di_count3 < 510 ? (di_count3-495)*33 : di_count3 > 509 && di_count3 < 525 ? (di_count3-510)*34 : di_count3 > 524 && di_count3 < 540 ? (di_count3-525)*35 : di_count3 > 539 && di_count3 < 555 ? (di_count3-540)*36 : di_count3 > 554 && di_count3 < 570 ? (di_count3-555)*37 : di_count3 > 569 && di_count3 < 585 ? (di_count3-570)*38 : di_count3 > 584 && di_count3 < 600 ? (di_count3-585)*39 : di_count3 > 599 && di_count3 < 615 ? (di_count3-600)*40 : di_count3 > 614 && di_count3 < 630 ? (di_count3-615)*41 : di_count3 > 629 && di_count3 < 645 ? (di_count3-630)*42 : di_count3 > 644 && di_count3 < 660 ? (di_count3-645)*43 : di_count3 > 659 && di_count3 < 675 ? (di_count3-660)*44 : di_count3 > 674 && di_count3 < 690 ? (di_count3-675)*45 : di_count3 > 689 && di_count3 < 705 ? (di_count3-690)*46 : di_count3 > 704 && di_count3 < 720 ? (di_count3-705)*47 : di_count3 > 719 && di_count3 < 735 ? (di_count3-720)*48 : di_count3 > 734 && di_count3 < 750 ? (di_count3-735)*49 : di_count3 > 749 && di_count3 < 765 ? (di_count3-750)*50 : di_count3 > 764 && di_count3 < 780 ? (di_count3-765)*51 : di_count3 > 779 && di_count3 < 795 ? (di_count3-780)*52 : di_count3 > 794 && di_count3 < 810 ? (di_count3-795)*53 : di_count3 > 809 && di_count3 < 825 ? (di_count3-810)*54 : di_count3 > 824 && di_count3 < 840 ? (di_count3-825)*55 : di_count3 > 839 && di_count3 < 855 ? (di_count3-840)*56 : di_count3 > 854 && di_count3 < 870 ? (di_count3-855)*57 : di_count3 > 869 && di_count3 < 885 ? (di_count3-870)*58 : di_count3 > 884 && di_count3 < 900 ? (di_count3-885)*59 : di_count3 > 899 && di_count3 < 915 ? (di_count3-900)*60 : di_count3 > 914 && di_count3 < 930 ? (di_count3-915)*61 : di_count3 > 929 && di_count3 < 945 ? (di_count3-930)*62 : di_count3 > 944 && di_count3 < 960 ? (di_count3-945)*63 : 0 :
                    pow2 == 128 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : di_count3 > 11 && di_count3 < 15 ? (di_count3-12)*4 : di_count3 > 14 && di_count3 < 18 ? (di_count3-15)*5 : di_count3 > 17 && di_count3 < 21 ? (di_count3-18)*6 : di_count3 > 20 && di_count3 < 24 ? (di_count3-21)*7 : di_count3 > 23 && di_count3 < 27 ? (di_count3-24)*8 : di_count3 > 26 && di_count3 < 30 ? (di_count3-27)*9 : di_count3 > 29 && di_count3 < 33 ? (di_count3-30)*10 : di_count3 > 32 && di_count3 < 36 ? (di_count3-33)*11 : di_count3 > 35 && di_count3 < 39 ? (di_count3-36)*12 : di_count3 > 38 && di_count3 < 42 ? (di_count3-39)*13 : di_count3 > 41 && di_count3 < 45 ? (di_count3-42)*14 : di_count3 > 44 && di_count3 < 48 ? (di_count3-45)*15 : di_count3 > 47 && di_count3 < 51 ? (di_count3-48)*16 : di_count3 > 50 && di_count3 < 54 ? (di_count3-51)*17 : di_count3 > 53 && di_count3 < 57 ? (di_count3-54)*18 : di_count3 > 56 && di_count3 < 60 ? (di_count3-57)*19 : di_count3 > 59 && di_count3 < 63 ? (di_count3-60)*20 : di_count3 > 62 && di_count3 < 66 ? (di_count3-63)*21 : di_count3 > 65 && di_count3 < 69 ? (di_count3-66)*22 : di_count3 > 68 && di_count3 < 72 ? (di_count3-69)*23 : di_count3 > 71 && di_count3 < 75 ? (di_count3-72)*24 : di_count3 > 74 && di_count3 < 78 ? (di_count3-75)*25 : di_count3 > 77 && di_count3 < 81 ? (di_count3-78)*26 : di_count3 > 80 && di_count3 < 84 ? (di_count3-81)*27 : di_count3 > 83 && di_count3 < 87 ? (di_count3-84)*28 : di_count3 > 86 && di_count3 < 90 ? (di_count3-87)*29 : di_count3 > 89 && di_count3 < 93 ? (di_count3-90)*30 : di_count3 > 92 && di_count3 < 96 ? (di_count3-93)*31 : di_count3 > 95 && di_count3 < 99 ? (di_count3-96)*32 : di_count3 > 98 && di_count3 < 102 ? (di_count3-99)*33 : di_count3 > 101 && di_count3 < 105 ? (di_count3-102)*34 : di_count3 > 104 && di_count3 < 108 ? (di_count3-105)*35 : di_count3 > 107 && di_count3 < 111 ? (di_count3-108)*36 : di_count3 > 110 && di_count3 < 114 ? (di_count3-111)*37 : di_count3 > 113 && di_count3 < 117 ? (di_count3-114)*38 : di_count3 > 116 && di_count3 < 120 ? (di_count3-117)*39 : di_count3 > 119 && di_count3 < 123 ? (di_count3-120)*40 : di_count3 > 122 && di_count3 < 126 ? (di_count3-123)*41 : di_count3 > 125 && di_count3 < 129 ? (di_count3-126)*42 : di_count3 > 128 && di_count3 < 132 ? (di_count3-129)*43 : di_count3 > 131 && di_count3 < 135 ? (di_count3-132)*44 : di_count3 > 134 && di_count3 < 138 ? (di_count3-135)*45 : di_count3 > 137 && di_count3 < 141 ? (di_count3-138)*46 : di_count3 > 140 && di_count3 < 144 ? (di_count3-141)*47 : di_count3 > 143 && di_count3 < 147 ? (di_count3-144)*48 : di_count3 > 146 && di_count3 < 150 ? (di_count3-147)*49 : di_count3 > 149 && di_count3 < 153 ? (di_count3-150)*50 : di_count3 > 152 && di_count3 < 156 ? (di_count3-153)*51 : di_count3 > 155 && di_count3 < 159 ? (di_count3-156)*52 : di_count3 > 158 && di_count3 < 162 ? (di_count3-159)*53 : di_count3 > 161 && di_count3 < 165 ? (di_count3-162)*54 : di_count3 > 164 && di_count3 < 168 ? (di_count3-165)*55 : di_count3 > 167 && di_count3 < 171 ? (di_count3-168)*56 : di_count3 > 170 && di_count3 < 174 ? (di_count3-171)*57 : di_count3 > 173 && di_count3 < 177 ? (di_count3-174)*58 : di_count3 > 176 && di_count3 < 180 ? (di_count3-177)*59 : di_count3 > 179 && di_count3 < 183 ? (di_count3-180)*60 : di_count3 > 182 && di_count3 < 186 ? (di_count3-183)*61 : di_count3 > 185 && di_count3 < 189 ? (di_count3-186)*62 : di_count3 > 188 && di_count3 < 192 ? (di_count3-189)*63 : di_count3 > 191 && di_count3 < 195 ? (di_count3-192)*64 : di_count3 > 194 && di_count3 < 198 ? (di_count3-195)*65 : di_count3 > 197 && di_count3 < 201 ? (di_count3-198)*66 : di_count3 > 200 && di_count3 < 204 ? (di_count3-201)*67 : di_count3 > 203 && di_count3 < 207 ? (di_count3-204)*68 : di_count3 > 206 && di_count3 < 210 ? (di_count3-207)*69 : di_count3 > 209 && di_count3 < 213 ? (di_count3-210)*70 : di_count3 > 212 && di_count3 < 216 ? (di_count3-213)*71 : di_count3 > 215 && di_count3 < 219 ? (di_count3-216)*72 : di_count3 > 218 && di_count3 < 222 ? (di_count3-219)*73 : di_count3 > 221 && di_count3 < 225 ? (di_count3-222)*74 : di_count3 > 224 && di_count3 < 228 ? (di_count3-225)*75 : di_count3 > 227 && di_count3 < 231 ? (di_count3-228)*76 : di_count3 > 230 && di_count3 < 234 ? (di_count3-231)*77 : di_count3 > 233 && di_count3 < 237 ? (di_count3-234)*78 : di_count3 > 236 && di_count3 < 240 ? (di_count3-237)*79 : di_count3 > 239 && di_count3 < 243 ? (di_count3-240)*80 : di_count3 > 242 && di_count3 < 246 ? (di_count3-243)*81 : di_count3 > 245 && di_count3 < 249 ? (di_count3-246)*82 : di_count3 > 248 && di_count3 < 252 ? (di_count3-249)*83 : di_count3 > 251 && di_count3 < 255 ? (di_count3-252)*84 : di_count3 > 254 && di_count3 < 258 ? (di_count3-255)*85 : di_count3 > 257 && di_count3 < 261 ? (di_count3-258)*86 : di_count3 > 260 && di_count3 < 264 ? (di_count3-261)*87 : di_count3 > 263 && di_count3 < 267 ? (di_count3-264)*88 : di_count3 > 266 && di_count3 < 270 ? (di_count3-267)*89 : di_count3 > 269 && di_count3 < 273 ? (di_count3-270)*90 : di_count3 > 272 && di_count3 < 276 ? (di_count3-273)*91 : di_count3 > 275 && di_count3 < 279 ? (di_count3-276)*92 : di_count3 > 278 && di_count3 < 282 ? (di_count3-279)*93 : di_count3 > 281 && di_count3 < 285 ? (di_count3-282)*94 : di_count3 > 284 && di_count3 < 288 ? (di_count3-285)*95 : di_count3 > 287 && di_count3 < 291 ? (di_count3-288)*96 : di_count3 > 290 && di_count3 < 294 ? (di_count3-291)*97 : di_count3 > 293 && di_count3 < 297 ? (di_count3-294)*98 : di_count3 > 296 && di_count3 < 300 ? (di_count3-297)*99 : di_count3 > 299 && di_count3 < 303 ? (di_count3-300)*100 : di_count3 > 302 && di_count3 < 306 ? (di_count3-303)*101 : di_count3 > 305 && di_count3 < 309 ? (di_count3-306)*102 : di_count3 > 308 && di_count3 < 312 ? (di_count3-309)*103 : di_count3 > 311 && di_count3 < 315 ? (di_count3-312)*104 : di_count3 > 314 && di_count3 < 318 ? (di_count3-315)*105 : di_count3 > 317 && di_count3 < 321 ? (di_count3-318)*106 : di_count3 > 320 && di_count3 < 324 ? (di_count3-321)*107 : di_count3 > 323 && di_count3 < 327 ? (di_count3-324)*108 : di_count3 > 326 && di_count3 < 330 ? (di_count3-327)*109 : di_count3 > 329 && di_count3 < 333 ? (di_count3-330)*110 : di_count3 > 332 && di_count3 < 336 ? (di_count3-333)*111 : di_count3 > 335 && di_count3 < 339 ? (di_count3-336)*112 : di_count3 > 338 && di_count3 < 342 ? (di_count3-339)*113 : di_count3 > 341 && di_count3 < 345 ? (di_count3-342)*114 : di_count3 > 344 && di_count3 < 348 ? (di_count3-345)*115 : di_count3 > 347 && di_count3 < 351 ? (di_count3-348)*116 : di_count3 > 350 && di_count3 < 354 ? (di_count3-351)*117 : di_count3 > 353 && di_count3 < 357 ? (di_count3-354)*118 : di_count3 > 356 && di_count3 < 360 ? (di_count3-357)*119 : di_count3 > 359 && di_count3 < 363 ? (di_count3-360)*120 : di_count3 > 362 && di_count3 < 366 ? (di_count3-363)*121 : di_count3 > 365 && di_count3 < 369 ? (di_count3-366)*122 : di_count3 > 368 && di_count3 < 372 ? (di_count3-369)*123 : di_count3 > 371 && di_count3 < 375 ? (di_count3-372)*124 : di_count3 > 374 && di_count3 < 378 ? (di_count3-375)*125 : di_count3 > 377 && di_count3 < 381 ? (di_count3-378)*126 : di_count3 > 380 && di_count3 < 384 ? (di_count3-381)*127 : 0 :
                    pow2 == 128 && FFT3_enable && pow3x5 == 9 ? di_count3 > 8 && di_count3 < 18 ? (di_count3-9) : di_count3 > 17 && di_count3 < 27 ? (di_count3-18)*2 : di_count3 > 26 && di_count3 < 36 ? (di_count3-27)*3 : di_count3 > 35 && di_count3 < 45 ? (di_count3-36)*4 : di_count3 > 44 && di_count3 < 54 ? (di_count3-45)*5 : di_count3 > 53 && di_count3 < 63 ? (di_count3-54)*6 : di_count3 > 62 && di_count3 < 72 ? (di_count3-63)*7 : di_count3 > 71 && di_count3 < 81 ? (di_count3-72)*8 : di_count3 > 80 && di_count3 < 90 ? (di_count3-81)*9 : di_count3 > 89 && di_count3 < 99 ? (di_count3-90)*10 : di_count3 > 98 && di_count3 < 108 ? (di_count3-99)*11 : di_count3 > 107 && di_count3 < 117 ? (di_count3-108)*12 : di_count3 > 116 && di_count3 < 126 ? (di_count3-117)*13 : di_count3 > 125 && di_count3 < 135 ? (di_count3-126)*14 : di_count3 > 134 && di_count3 < 144 ? (di_count3-135)*15 : di_count3 > 143 && di_count3 < 153 ? (di_count3-144)*16 : di_count3 > 152 && di_count3 < 162 ? (di_count3-153)*17 : di_count3 > 161 && di_count3 < 171 ? (di_count3-162)*18 : di_count3 > 170 && di_count3 < 180 ? (di_count3-171)*19 : di_count3 > 179 && di_count3 < 189 ? (di_count3-180)*20 : di_count3 > 188 && di_count3 < 198 ? (di_count3-189)*21 : di_count3 > 197 && di_count3 < 207 ? (di_count3-198)*22 : di_count3 > 206 && di_count3 < 216 ? (di_count3-207)*23 : di_count3 > 215 && di_count3 < 225 ? (di_count3-216)*24 : di_count3 > 224 && di_count3 < 234 ? (di_count3-225)*25 : di_count3 > 233 && di_count3 < 243 ? (di_count3-234)*26 : di_count3 > 242 && di_count3 < 252 ? (di_count3-243)*27 : di_count3 > 251 && di_count3 < 261 ? (di_count3-252)*28 : di_count3 > 260 && di_count3 < 270 ? (di_count3-261)*29 : di_count3 > 269 && di_count3 < 279 ? (di_count3-270)*30 : di_count3 > 278 && di_count3 < 288 ? (di_count3-279)*31 : di_count3 > 287 && di_count3 < 297 ? (di_count3-288)*32 : di_count3 > 296 && di_count3 < 306 ? (di_count3-297)*33 : di_count3 > 305 && di_count3 < 315 ? (di_count3-306)*34 : di_count3 > 314 && di_count3 < 324 ? (di_count3-315)*35 : di_count3 > 323 && di_count3 < 333 ? (di_count3-324)*36 : di_count3 > 332 && di_count3 < 342 ? (di_count3-333)*37 : di_count3 > 341 && di_count3 < 351 ? (di_count3-342)*38 : di_count3 > 350 && di_count3 < 360 ? (di_count3-351)*39 : di_count3 > 359 && di_count3 < 369 ? (di_count3-360)*40 : di_count3 > 368 && di_count3 < 378 ? (di_count3-369)*41 : di_count3 > 377 && di_count3 < 387 ? (di_count3-378)*42 : di_count3 > 386 && di_count3 < 396 ? (di_count3-387)*43 : di_count3 > 395 && di_count3 < 405 ? (di_count3-396)*44 : di_count3 > 404 && di_count3 < 414 ? (di_count3-405)*45 : di_count3 > 413 && di_count3 < 423 ? (di_count3-414)*46 : di_count3 > 422 && di_count3 < 432 ? (di_count3-423)*47 : di_count3 > 431 && di_count3 < 441 ? (di_count3-432)*48 : di_count3 > 440 && di_count3 < 450 ? (di_count3-441)*49 : di_count3 > 449 && di_count3 < 459 ? (di_count3-450)*50 : di_count3 > 458 && di_count3 < 468 ? (di_count3-459)*51 : di_count3 > 467 && di_count3 < 477 ? (di_count3-468)*52 : di_count3 > 476 && di_count3 < 486 ? (di_count3-477)*53 : di_count3 > 485 && di_count3 < 495 ? (di_count3-486)*54 : di_count3 > 494 && di_count3 < 504 ? (di_count3-495)*55 : di_count3 > 503 && di_count3 < 513 ? (di_count3-504)*56 : di_count3 > 512 && di_count3 < 522 ? (di_count3-513)*57 : di_count3 > 521 && di_count3 < 531 ? (di_count3-522)*58 : di_count3 > 530 && di_count3 < 540 ? (di_count3-531)*59 : di_count3 > 539 && di_count3 < 549 ? (di_count3-540)*60 : di_count3 > 548 && di_count3 < 558 ? (di_count3-549)*61 : di_count3 > 557 && di_count3 < 567 ? (di_count3-558)*62 : di_count3 > 566 && di_count3 < 576 ? (di_count3-567)*63 : di_count3 > 575 && di_count3 < 585 ? (di_count3-576)*64 : di_count3 > 584 && di_count3 < 594 ? (di_count3-585)*65 : di_count3 > 593 && di_count3 < 603 ? (di_count3-594)*66 : di_count3 > 602 && di_count3 < 612 ? (di_count3-603)*67 : di_count3 > 611 && di_count3 < 621 ? (di_count3-612)*68 : di_count3 > 620 && di_count3 < 630 ? (di_count3-621)*69 : di_count3 > 629 && di_count3 < 639 ? (di_count3-630)*70 : di_count3 > 638 && di_count3 < 648 ? (di_count3-639)*71 : di_count3 > 647 && di_count3 < 657 ? (di_count3-648)*72 : di_count3 > 656 && di_count3 < 666 ? (di_count3-657)*73 : di_count3 > 665 && di_count3 < 675 ? (di_count3-666)*74 : di_count3 > 674 && di_count3 < 684 ? (di_count3-675)*75 : di_count3 > 683 && di_count3 < 693 ? (di_count3-684)*76 : di_count3 > 692 && di_count3 < 702 ? (di_count3-693)*77 : di_count3 > 701 && di_count3 < 711 ? (di_count3-702)*78 : di_count3 > 710 && di_count3 < 720 ? (di_count3-711)*79 : di_count3 > 719 && di_count3 < 729 ? (di_count3-720)*80 : di_count3 > 728 && di_count3 < 738 ? (di_count3-729)*81 : di_count3 > 737 && di_count3 < 747 ? (di_count3-738)*82 : di_count3 > 746 && di_count3 < 756 ? (di_count3-747)*83 : di_count3 > 755 && di_count3 < 765 ? (di_count3-756)*84 : di_count3 > 764 && di_count3 < 774 ? (di_count3-765)*85 : di_count3 > 773 && di_count3 < 783 ? (di_count3-774)*86 : di_count3 > 782 && di_count3 < 792 ? (di_count3-783)*87 : di_count3 > 791 && di_count3 < 801 ? (di_count3-792)*88 : di_count3 > 800 && di_count3 < 810 ? (di_count3-801)*89 : di_count3 > 809 && di_count3 < 819 ? (di_count3-810)*90 : di_count3 > 818 && di_count3 < 828 ? (di_count3-819)*91 : di_count3 > 827 && di_count3 < 837 ? (di_count3-828)*92 : di_count3 > 836 && di_count3 < 846 ? (di_count3-837)*93 : di_count3 > 845 && di_count3 < 855 ? (di_count3-846)*94 : di_count3 > 854 && di_count3 < 864 ? (di_count3-855)*95 : di_count3 > 863 && di_count3 < 873 ? (di_count3-864)*96 : di_count3 > 872 && di_count3 < 882 ? (di_count3-873)*97 : di_count3 > 881 && di_count3 < 891 ? (di_count3-882)*98 : di_count3 > 890 && di_count3 < 900 ? (di_count3-891)*99 : di_count3 > 899 && di_count3 < 909 ? (di_count3-900)*100 : di_count3 > 908 && di_count3 < 918 ? (di_count3-909)*101 : di_count3 > 917 && di_count3 < 927 ? (di_count3-918)*102 : di_count3 > 926 && di_count3 < 936 ? (di_count3-927)*103 : di_count3 > 935 && di_count3 < 945 ? (di_count3-936)*104 : di_count3 > 944 && di_count3 < 954 ? (di_count3-945)*105 : di_count3 > 953 && di_count3 < 963 ? (di_count3-954)*106 : di_count3 > 962 && di_count3 < 972 ? (di_count3-963)*107 : di_count3 > 971 && di_count3 < 981 ? (di_count3-972)*108 : di_count3 > 980 && di_count3 < 990 ? (di_count3-981)*109 : di_count3 > 989 && di_count3 < 999 ? (di_count3-990)*110 : di_count3 > 998 && di_count3 < 1008 ? (di_count3-999)*111 : di_count3 > 1007 && di_count3 < 1017 ? (di_count3-1008)*112 : di_count3 > 1016 && di_count3 < 1026 ? (di_count3-1017)*113 : di_count3 > 1025 && di_count3 < 1035 ? (di_count3-1026)*114 : di_count3 > 1034 && di_count3 < 1044 ? (di_count3-1035)*115 : di_count3 > 1043 && di_count3 < 1053 ? (di_count3-1044)*116 : di_count3 > 1052 && di_count3 < 1062 ? (di_count3-1053)*117 : di_count3 > 1061 && di_count3 < 1071 ? (di_count3-1062)*118 : di_count3 > 1070 && di_count3 < 1080 ? (di_count3-1071)*119 : di_count3 > 1079 && di_count3 < 1089 ? (di_count3-1080)*120 : di_count3 > 1088 && di_count3 < 1098 ? (di_count3-1089)*121 : di_count3 > 1097 && di_count3 < 1107 ? (di_count3-1098)*122 : di_count3 > 1106 && di_count3 < 1116 ? (di_count3-1107)*123 : di_count3 > 1115 && di_count3 < 1125 ? (di_count3-1116)*124 : di_count3 > 1124 && di_count3 < 1134 ? (di_count3-1125)*125 : di_count3 > 1133 && di_count3 < 1143 ? (di_count3-1134)*126 : di_count3 > 1142 && di_count3 < 1152 ? (di_count3-1143)*127 : 0 :
                    pow2 == 256 && FFT3_enable && pow3x5 == 3 ? di_count3 > 2 && di_count3 < 6 ? (di_count3-3) : di_count3 > 5 && di_count3 < 9 ? (di_count3-6)*2 : di_count3 > 8 && di_count3 < 12 ? (di_count3-9)*3 : di_count3 > 11 && di_count3 < 15 ? (di_count3-12)*4 : di_count3 > 14 && di_count3 < 18 ? (di_count3-15)*5 : di_count3 > 17 && di_count3 < 21 ? (di_count3-18)*6 : di_count3 > 20 && di_count3 < 24 ? (di_count3-21)*7 : di_count3 > 23 && di_count3 < 27 ? (di_count3-24)*8 : di_count3 > 26 && di_count3 < 30 ? (di_count3-27)*9 : di_count3 > 29 && di_count3 < 33 ? (di_count3-30)*10 : di_count3 > 32 && di_count3 < 36 ? (di_count3-33)*11 : di_count3 > 35 && di_count3 < 39 ? (di_count3-36)*12 : di_count3 > 38 && di_count3 < 42 ? (di_count3-39)*13 : di_count3 > 41 && di_count3 < 45 ? (di_count3-42)*14 : di_count3 > 44 && di_count3 < 48 ? (di_count3-45)*15 : di_count3 > 47 && di_count3 < 51 ? (di_count3-48)*16 : di_count3 > 50 && di_count3 < 54 ? (di_count3-51)*17 : di_count3 > 53 && di_count3 < 57 ? (di_count3-54)*18 : di_count3 > 56 && di_count3 < 60 ? (di_count3-57)*19 : di_count3 > 59 && di_count3 < 63 ? (di_count3-60)*20 : di_count3 > 62 && di_count3 < 66 ? (di_count3-63)*21 : di_count3 > 65 && di_count3 < 69 ? (di_count3-66)*22 : di_count3 > 68 && di_count3 < 72 ? (di_count3-69)*23 : di_count3 > 71 && di_count3 < 75 ? (di_count3-72)*24 : di_count3 > 74 && di_count3 < 78 ? (di_count3-75)*25 : di_count3 > 77 && di_count3 < 81 ? (di_count3-78)*26 : di_count3 > 80 && di_count3 < 84 ? (di_count3-81)*27 : di_count3 > 83 && di_count3 < 87 ? (di_count3-84)*28 : di_count3 > 86 && di_count3 < 90 ? (di_count3-87)*29 : di_count3 > 89 && di_count3 < 93 ? (di_count3-90)*30 : di_count3 > 92 && di_count3 < 96 ? (di_count3-93)*31 : di_count3 > 95 && di_count3 < 99 ? (di_count3-96)*32 : di_count3 > 98 && di_count3 < 102 ? (di_count3-99)*33 : di_count3 > 101 && di_count3 < 105 ? (di_count3-102)*34 : di_count3 > 104 && di_count3 < 108 ? (di_count3-105)*35 : di_count3 > 107 && di_count3 < 111 ? (di_count3-108)*36 : di_count3 > 110 && di_count3 < 114 ? (di_count3-111)*37 : di_count3 > 113 && di_count3 < 117 ? (di_count3-114)*38 : di_count3 > 116 && di_count3 < 120 ? (di_count3-117)*39 : di_count3 > 119 && di_count3 < 123 ? (di_count3-120)*40 : di_count3 > 122 && di_count3 < 126 ? (di_count3-123)*41 : di_count3 > 125 && di_count3 < 129 ? (di_count3-126)*42 : di_count3 > 128 && di_count3 < 132 ? (di_count3-129)*43 : di_count3 > 131 && di_count3 < 135 ? (di_count3-132)*44 : di_count3 > 134 && di_count3 < 138 ? (di_count3-135)*45 : di_count3 > 137 && di_count3 < 141 ? (di_count3-138)*46 : di_count3 > 140 && di_count3 < 144 ? (di_count3-141)*47 : di_count3 > 143 && di_count3 < 147 ? (di_count3-144)*48 : di_count3 > 146 && di_count3 < 150 ? (di_count3-147)*49 : di_count3 > 149 && di_count3 < 153 ? (di_count3-150)*50 : di_count3 > 152 && di_count3 < 156 ? (di_count3-153)*51 : di_count3 > 155 && di_count3 < 159 ? (di_count3-156)*52 : di_count3 > 158 && di_count3 < 162 ? (di_count3-159)*53 : di_count3 > 161 && di_count3 < 165 ? (di_count3-162)*54 : di_count3 > 164 && di_count3 < 168 ? (di_count3-165)*55 : di_count3 > 167 && di_count3 < 171 ? (di_count3-168)*56 : di_count3 > 170 && di_count3 < 174 ? (di_count3-171)*57 : di_count3 > 173 && di_count3 < 177 ? (di_count3-174)*58 : di_count3 > 176 && di_count3 < 180 ? (di_count3-177)*59 : di_count3 > 179 && di_count3 < 183 ? (di_count3-180)*60 : di_count3 > 182 && di_count3 < 186 ? (di_count3-183)*61 : di_count3 > 185 && di_count3 < 189 ? (di_count3-186)*62 : di_count3 > 188 && di_count3 < 192 ? (di_count3-189)*63 : di_count3 > 191 && di_count3 < 195 ? (di_count3-192)*64 : di_count3 > 194 && di_count3 < 198 ? (di_count3-195)*65 : di_count3 > 197 && di_count3 < 201 ? (di_count3-198)*66 : di_count3 > 200 && di_count3 < 204 ? (di_count3-201)*67 : di_count3 > 203 && di_count3 < 207 ? (di_count3-204)*68 : di_count3 > 206 && di_count3 < 210 ? (di_count3-207)*69 : di_count3 > 209 && di_count3 < 213 ? (di_count3-210)*70 : di_count3 > 212 && di_count3 < 216 ? (di_count3-213)*71 : di_count3 > 215 && di_count3 < 219 ? (di_count3-216)*72 : di_count3 > 218 && di_count3 < 222 ? (di_count3-219)*73 : di_count3 > 221 && di_count3 < 225 ? (di_count3-222)*74 : di_count3 > 224 && di_count3 < 228 ? (di_count3-225)*75 : di_count3 > 227 && di_count3 < 231 ? (di_count3-228)*76 : di_count3 > 230 && di_count3 < 234 ? (di_count3-231)*77 : di_count3 > 233 && di_count3 < 237 ? (di_count3-234)*78 : di_count3 > 236 && di_count3 < 240 ? (di_count3-237)*79 : di_count3 > 239 && di_count3 < 243 ? (di_count3-240)*80 : di_count3 > 242 && di_count3 < 246 ? (di_count3-243)*81 : di_count3 > 245 && di_count3 < 249 ? (di_count3-246)*82 : di_count3 > 248 && di_count3 < 252 ? (di_count3-249)*83 : di_count3 > 251 && di_count3 < 255 ? (di_count3-252)*84 : di_count3 > 254 && di_count3 < 258 ? (di_count3-255)*85 : di_count3 > 257 && di_count3 < 261 ? (di_count3-258)*86 : di_count3 > 260 && di_count3 < 264 ? (di_count3-261)*87 : di_count3 > 263 && di_count3 < 267 ? (di_count3-264)*88 : di_count3 > 266 && di_count3 < 270 ? (di_count3-267)*89 : di_count3 > 269 && di_count3 < 273 ? (di_count3-270)*90 : di_count3 > 272 && di_count3 < 276 ? (di_count3-273)*91 : di_count3 > 275 && di_count3 < 279 ? (di_count3-276)*92 : di_count3 > 278 && di_count3 < 282 ? (di_count3-279)*93 : di_count3 > 281 && di_count3 < 285 ? (di_count3-282)*94 : di_count3 > 284 && di_count3 < 288 ? (di_count3-285)*95 : di_count3 > 287 && di_count3 < 291 ? (di_count3-288)*96 : di_count3 > 290 && di_count3 < 294 ? (di_count3-291)*97 : di_count3 > 293 && di_count3 < 297 ? (di_count3-294)*98 : di_count3 > 296 && di_count3 < 300 ? (di_count3-297)*99 : di_count3 > 299 && di_count3 < 303 ? (di_count3-300)*100 : di_count3 > 302 && di_count3 < 306 ? (di_count3-303)*101 : di_count3 > 305 && di_count3 < 309 ? (di_count3-306)*102 : di_count3 > 308 && di_count3 < 312 ? (di_count3-309)*103 : di_count3 > 311 && di_count3 < 315 ? (di_count3-312)*104 : di_count3 > 314 && di_count3 < 318 ? (di_count3-315)*105 : di_count3 > 317 && di_count3 < 321 ? (di_count3-318)*106 : di_count3 > 320 && di_count3 < 324 ? (di_count3-321)*107 : di_count3 > 323 && di_count3 < 327 ? (di_count3-324)*108 : di_count3 > 326 && di_count3 < 330 ? (di_count3-327)*109 : di_count3 > 329 && di_count3 < 333 ? (di_count3-330)*110 : di_count3 > 332 && di_count3 < 336 ? (di_count3-333)*111 : di_count3 > 335 && di_count3 < 339 ? (di_count3-336)*112 : di_count3 > 338 && di_count3 < 342 ? (di_count3-339)*113 : di_count3 > 341 && di_count3 < 345 ? (di_count3-342)*114 : di_count3 > 344 && di_count3 < 348 ? (di_count3-345)*115 : di_count3 > 347 && di_count3 < 351 ? (di_count3-348)*116 : di_count3 > 350 && di_count3 < 354 ? (di_count3-351)*117 : di_count3 > 353 && di_count3 < 357 ? (di_count3-354)*118 : di_count3 > 356 && di_count3 < 360 ? (di_count3-357)*119 : di_count3 > 359 && di_count3 < 363 ? (di_count3-360)*120 : di_count3 > 362 && di_count3 < 366 ? (di_count3-363)*121 : di_count3 > 365 && di_count3 < 369 ? (di_count3-366)*122 : di_count3 > 368 && di_count3 < 372 ? (di_count3-369)*123 : di_count3 > 371 && di_count3 < 375 ? (di_count3-372)*124 : di_count3 > 374 && di_count3 < 378 ? (di_count3-375)*125 : di_count3 > 377 && di_count3 < 381 ? (di_count3-378)*126 : di_count3 > 380 && di_count3 < 384 ? (di_count3-381)*127 : di_count3 > 383 && di_count3 < 387 ? (di_count3-384)*128 : di_count3 > 386 && di_count3 < 390 ? (di_count3-387)*129 : di_count3 > 389 && di_count3 < 393 ? (di_count3-390)*130 : di_count3 > 392 && di_count3 < 396 ? (di_count3-393)*131 : di_count3 > 395 && di_count3 < 399 ? (di_count3-396)*132 : di_count3 > 398 && di_count3 < 402 ? (di_count3-399)*133 : di_count3 > 401 && di_count3 < 405 ? (di_count3-402)*134 : di_count3 > 404 && di_count3 < 408 ? (di_count3-405)*135 : di_count3 > 407 && di_count3 < 411 ? (di_count3-408)*136 : di_count3 > 410 && di_count3 < 414 ? (di_count3-411)*137 : di_count3 > 413 && di_count3 < 417 ? (di_count3-414)*138 : di_count3 > 416 && di_count3 < 420 ? (di_count3-417)*139 : di_count3 > 419 && di_count3 < 423 ? (di_count3-420)*140 : di_count3 > 422 && di_count3 < 426 ? (di_count3-423)*141 : di_count3 > 425 && di_count3 < 429 ? (di_count3-426)*142 : di_count3 > 428 && di_count3 < 432 ? (di_count3-429)*143 : di_count3 > 431 && di_count3 < 435 ? (di_count3-432)*144 : di_count3 > 434 && di_count3 < 438 ? (di_count3-435)*145 : di_count3 > 437 && di_count3 < 441 ? (di_count3-438)*146 : di_count3 > 440 && di_count3 < 444 ? (di_count3-441)*147 : di_count3 > 443 && di_count3 < 447 ? (di_count3-444)*148 : di_count3 > 446 && di_count3 < 450 ? (di_count3-447)*149 : di_count3 > 449 && di_count3 < 453 ? (di_count3-450)*150 : di_count3 > 452 && di_count3 < 456 ? (di_count3-453)*151 : di_count3 > 455 && di_count3 < 459 ? (di_count3-456)*152 : di_count3 > 458 && di_count3 < 462 ? (di_count3-459)*153 : di_count3 > 461 && di_count3 < 465 ? (di_count3-462)*154 : di_count3 > 464 && di_count3 < 468 ? (di_count3-465)*155 : di_count3 > 467 && di_count3 < 471 ? (di_count3-468)*156 : di_count3 > 470 && di_count3 < 474 ? (di_count3-471)*157 : di_count3 > 473 && di_count3 < 477 ? (di_count3-474)*158 : di_count3 > 476 && di_count3 < 480 ? (di_count3-477)*159 : di_count3 > 479 && di_count3 < 483 ? (di_count3-480)*160 : di_count3 > 482 && di_count3 < 486 ? (di_count3-483)*161 : di_count3 > 485 && di_count3 < 489 ? (di_count3-486)*162 : di_count3 > 488 && di_count3 < 492 ? (di_count3-489)*163 : di_count3 > 491 && di_count3 < 495 ? (di_count3-492)*164 : di_count3 > 494 && di_count3 < 498 ? (di_count3-495)*165 : di_count3 > 497 && di_count3 < 501 ? (di_count3-498)*166 : di_count3 > 500 && di_count3 < 504 ? (di_count3-501)*167 : di_count3 > 503 && di_count3 < 507 ? (di_count3-504)*168 : di_count3 > 506 && di_count3 < 510 ? (di_count3-507)*169 : di_count3 > 509 && di_count3 < 513 ? (di_count3-510)*170 : di_count3 > 512 && di_count3 < 516 ? (di_count3-513)*171 : di_count3 > 515 && di_count3 < 519 ? (di_count3-516)*172 : di_count3 > 518 && di_count3 < 522 ? (di_count3-519)*173 : di_count3 > 521 && di_count3 < 525 ? (di_count3-522)*174 : di_count3 > 524 && di_count3 < 528 ? (di_count3-525)*175 : di_count3 > 527 && di_count3 < 531 ? (di_count3-528)*176 : di_count3 > 530 && di_count3 < 534 ? (di_count3-531)*177 : di_count3 > 533 && di_count3 < 537 ? (di_count3-534)*178 : di_count3 > 536 && di_count3 < 540 ? (di_count3-537)*179 : di_count3 > 539 && di_count3 < 543 ? (di_count3-540)*180 : di_count3 > 542 && di_count3 < 546 ? (di_count3-543)*181 : di_count3 > 545 && di_count3 < 549 ? (di_count3-546)*182 : di_count3 > 548 && di_count3 < 552 ? (di_count3-549)*183 : di_count3 > 551 && di_count3 < 555 ? (di_count3-552)*184 : di_count3 > 554 && di_count3 < 558 ? (di_count3-555)*185 : di_count3 > 557 && di_count3 < 561 ? (di_count3-558)*186 : di_count3 > 560 && di_count3 < 564 ? (di_count3-561)*187 : di_count3 > 563 && di_count3 < 567 ? (di_count3-564)*188 : di_count3 > 566 && di_count3 < 570 ? (di_count3-567)*189 : di_count3 > 569 && di_count3 < 573 ? (di_count3-570)*190 : di_count3 > 572 && di_count3 < 576 ? (di_count3-573)*191 : di_count3 > 575 && di_count3 < 579 ? (di_count3-576)*192 : di_count3 > 578 && di_count3 < 582 ? (di_count3-579)*193 : di_count3 > 581 && di_count3 < 585 ? (di_count3-582)*194 : di_count3 > 584 && di_count3 < 588 ? (di_count3-585)*195 : di_count3 > 587 && di_count3 < 591 ? (di_count3-588)*196 : di_count3 > 590 && di_count3 < 594 ? (di_count3-591)*197 : di_count3 > 593 && di_count3 < 597 ? (di_count3-594)*198 : di_count3 > 596 && di_count3 < 600 ? (di_count3-597)*199 : di_count3 > 599 && di_count3 < 603 ? (di_count3-600)*200 : di_count3 > 602 && di_count3 < 606 ? (di_count3-603)*201 : di_count3 > 605 && di_count3 < 609 ? (di_count3-606)*202 : di_count3 > 608 && di_count3 < 612 ? (di_count3-609)*203 : di_count3 > 611 && di_count3 < 615 ? (di_count3-612)*204 : di_count3 > 614 && di_count3 < 618 ? (di_count3-615)*205 : di_count3 > 617 && di_count3 < 621 ? (di_count3-618)*206 : di_count3 > 620 && di_count3 < 624 ? (di_count3-621)*207 : di_count3 > 623 && di_count3 < 627 ? (di_count3-624)*208 : di_count3 > 626 && di_count3 < 630 ? (di_count3-627)*209 : di_count3 > 629 && di_count3 < 633 ? (di_count3-630)*210 : di_count3 > 632 && di_count3 < 636 ? (di_count3-633)*211 : di_count3 > 635 && di_count3 < 639 ? (di_count3-636)*212 : di_count3 > 638 && di_count3 < 642 ? (di_count3-639)*213 : di_count3 > 641 && di_count3 < 645 ? (di_count3-642)*214 : di_count3 > 644 && di_count3 < 648 ? (di_count3-645)*215 : di_count3 > 647 && di_count3 < 651 ? (di_count3-648)*216 : di_count3 > 650 && di_count3 < 654 ? (di_count3-651)*217 : di_count3 > 653 && di_count3 < 657 ? (di_count3-654)*218 : di_count3 > 656 && di_count3 < 660 ? (di_count3-657)*219 : di_count3 > 659 && di_count3 < 663 ? (di_count3-660)*220 : di_count3 > 662 && di_count3 < 666 ? (di_count3-663)*221 : di_count3 > 665 && di_count3 < 669 ? (di_count3-666)*222 : di_count3 > 668 && di_count3 < 672 ? (di_count3-669)*223 : di_count3 > 671 && di_count3 < 675 ? (di_count3-672)*224 : di_count3 > 674 && di_count3 < 678 ? (di_count3-675)*225 : di_count3 > 677 && di_count3 < 681 ? (di_count3-678)*226 : di_count3 > 680 && di_count3 < 684 ? (di_count3-681)*227 : di_count3 > 683 && di_count3 < 687 ? (di_count3-684)*228 : di_count3 > 686 && di_count3 < 690 ? (di_count3-687)*229 : di_count3 > 689 && di_count3 < 693 ? (di_count3-690)*230 : di_count3 > 692 && di_count3 < 696 ? (di_count3-693)*231 : di_count3 > 695 && di_count3 < 699 ? (di_count3-696)*232 : di_count3 > 698 && di_count3 < 702 ? (di_count3-699)*233 : di_count3 > 701 && di_count3 < 705 ? (di_count3-702)*234 : di_count3 > 704 && di_count3 < 708 ? (di_count3-705)*235 : di_count3 > 707 && di_count3 < 711 ? (di_count3-708)*236 : di_count3 > 710 && di_count3 < 714 ? (di_count3-711)*237 : di_count3 > 713 && di_count3 < 717 ? (di_count3-714)*238 : di_count3 > 716 && di_count3 < 720 ? (di_count3-717)*239 : di_count3 > 719 && di_count3 < 723 ? (di_count3-720)*240 : di_count3 > 722 && di_count3 < 726 ? (di_count3-723)*241 : di_count3 > 725 && di_count3 < 729 ? (di_count3-726)*242 : di_count3 > 728 && di_count3 < 732 ? (di_count3-729)*243 : di_count3 > 731 && di_count3 < 735 ? (di_count3-732)*244 : di_count3 > 734 && di_count3 < 738 ? (di_count3-735)*245 : di_count3 > 737 && di_count3 < 741 ? (di_count3-738)*246 : di_count3 > 740 && di_count3 < 744 ? (di_count3-741)*247 : di_count3 > 743 && di_count3 < 747 ? (di_count3-744)*248 : di_count3 > 746 && di_count3 < 750 ? (di_count3-747)*249 : di_count3 > 749 && di_count3 < 753 ? (di_count3-750)*250 : di_count3 > 752 && di_count3 < 756 ? (di_count3-753)*251 : di_count3 > 755 && di_count3 < 759 ? (di_count3-756)*252 : di_count3 > 758 && di_count3 < 762 ? (di_count3-759)*253 : di_count3 > 761 && di_count3 < 765 ? (di_count3-762)*254 : di_count3 > 764 && di_count3 < 768 ? (di_count3-765)*255 : 0 : 0 ;
Twiddle15 Twid15(
    .clk    (clk    ),  //  i
    .addr   (tw_addr5),  //  i
    .tw_re  (tw_re_temp1  ),  //  o
    .tw_im  (tw_im_temp1  )   //  o
);

Twiddle45 Twid45(
    .clk    (clk    ),  //  i
    .addr   (tw_addr5),  //  i
    .tw_re  (tw_re_temp2  ),  //  o
    .tw_im  (tw_im_temp2  )   //  o
);

Twiddle75 Twid75(
    .clk    (clk    ),  //  i
    .addr   (tw_addr5),  //  i
    .tw_re  (tw_re_temp3  ),  //  o
    .tw_im  (tw_im_temp3  )   //  o
);

Twiddle135 Twid135(
    .clk    (clk    ),  //  i
    .addr   (tw_addr5),  //  i
    .tw_re  (tw_re_temp4  ),  //  o
    .tw_im  (tw_im_temp4  )   //  o
);

Twiddle225 Twid225(
    .clk    (clk    ),  //  i
    .addr   (tw_addr5),  //  i
    .tw_re  (tw_re_temp5  ),  //  o
    .tw_im  (tw_im_temp5  )   //  o
);
assign Twid_re5 = pow3x5==15?tw_re_temp1:pow3x5==45?tw_re_temp2:pow3x5==75?tw_re_temp3:pow3x5==135?tw_re_temp4:pow3x5==225?tw_re_temp5:0;
assign Twid_im5 = pow3x5==15?tw_im_temp1:pow3x5==45?tw_im_temp2:pow3x5==75?tw_im_temp3:pow3x5==135?tw_im_temp4:pow3x5==225?tw_im_temp5:0;


Twiddle12 Twid12(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp6  ),  //  o
    .tw_im  (tw_im_temp6  )   //  o
);

Twiddle24 Twid24(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp7  ),  //  o
    .tw_im  (tw_im_temp7  )   //  o
);

Twiddle36 Twid36(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp8  ),  //  o
    .tw_im  (tw_im_temp8  )   //  o
);

Twiddle48 Twid48(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp9  ),  //  o
    .tw_im  (tw_im_temp9  )   //  o
);

Twiddle60 Twid60(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp10  ),  //  o
    .tw_im  (tw_im_temp10  )   //  o
);

Twiddle72 Twid72(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp11  ),  //  o
    .tw_im  (tw_im_temp11  )   //  o
);

Twiddle96 Twid96(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp12  ),  //  o
    .tw_im  (tw_im_temp12  )   //  o
);

Twiddle108 Twid108(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp13  ),  //  o
    .tw_im  (tw_im_temp13  )   //  o
);

Twiddle120 Twid120(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp14  ),  //  o
    .tw_im  (tw_im_temp14  )   //  o
);

Twiddle144 Twid144(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp15  ),  //  o
    .tw_im  (tw_im_temp15  )   //  o
);

Twiddle180 Twid180(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp16  ),  //  o
    .tw_im  (tw_im_temp16  )   //  o
);

Twiddle192 Twid192(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp17  ),  //  o
    .tw_im  (tw_im_temp17  )   //  o
);

Twiddle216 Twid216(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp18  ),  //  o
    .tw_im  (tw_im_temp18  )   //  o
);

Twiddle240 Twid240(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp19  ),  //  o
    .tw_im  (tw_im_temp19  )   //  o
);

Twiddle288 Twid288(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp20  ),  //  o
    .tw_im  (tw_im_temp20  )   //  o
);

Twiddle300 Twid300(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp21  ),  //  o
    .tw_im  (tw_im_temp21  )   //  o
);

Twiddle324 Twid324(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp22  ),  //  o
    .tw_im  (tw_im_temp22  )   //  o
);

Twiddle360 Twid360(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp23  ),  //  o
    .tw_im  (tw_im_temp23  )   //  o
);

Twiddle384 Twid384(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp24  ),  //  o
    .tw_im  (tw_im_temp24  )   //  o
);

Twiddle432 Twid432(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp25  ),  //  o
    .tw_im  (tw_im_temp25  )   //  o
);

Twiddle480 Twid480(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp26  ),  //  o
    .tw_im  (tw_im_temp26  )   //  o
);

Twiddle540 Twid540(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp27  ),  //  o
    .tw_im  (tw_im_temp27  )   //  o
);

Twiddle576 Twid576(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp28  ),  //  o
    .tw_im  (tw_im_temp28  )   //  o
);

Twiddle600 Twid600(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp29  ),  //  o
    .tw_im  (tw_im_temp29  )   //  o
);

Twiddle648 Twid648(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp30  ),  //  o
    .tw_im  (tw_im_temp30  )   //  o
);

Twiddle720 Twid720(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp31  ),  //  o
    .tw_im  (tw_im_temp31  )   //  o
);

Twiddle768 Twid768(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp32  ),  //  o
    .tw_im  (tw_im_temp32  )   //  o
);

Twiddle864 Twid864(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp33  ),  //  o
    .tw_im  (tw_im_temp33  )   //  o
);

Twiddle900 Twid900(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp34  ),  //  o
    .tw_im  (tw_im_temp34  )   //  o
);

Twiddle960 Twid960(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp35  ),  //  o
    .tw_im  (tw_im_temp35  )   //  o
);

Twiddle972 Twid972(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp36  ),  //  o
    .tw_im  (tw_im_temp36  )   //  o
);

Twiddle1080 Twid1080(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp37  ),  //  o
    .tw_im  (tw_im_temp37  )   //  o
);

Twiddle1152 Twid1152(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp38), //o
    .tw_im  (tw_im_temp38)  //o
);

Twiddle1200 Twid1200(
    .clk    (clk    ),  //  i
    .addr   (tw_addr3),  //  i
    .tw_re  (tw_re_temp39), //o
    .tw_im  (tw_im_temp39)  //o
);


assign Twid_re3 = pow2*pow3x5 == 12 ? tw_re_temp6 : pow2*pow3x5 == 24 ? tw_re_temp7:pow2*pow3x5 == 36 ? tw_re_temp8:pow2*pow3x5 == 48 ? tw_re_temp9:pow2*pow3x5 == 60 ? tw_re_temp10:pow2*pow3x5 == 72 ? tw_re_temp11:pow2*pow3x5 == 96 ? tw_re_temp12:pow2*pow3x5 == 108 ? tw_re_temp13:pow2*pow3x5 == 120 ? tw_re_temp14:pow2*pow3x5 == 144 ? tw_re_temp15:pow2*pow3x5 == 180 ? tw_re_temp16:pow2*pow3x5 == 192 ? tw_re_temp17:pow2*pow3x5 == 216 ? tw_re_temp18:pow2*pow3x5 == 240 ? tw_re_temp19:pow2*pow3x5 == 288 ? tw_re_temp20:pow2*pow3x5 == 300 ? tw_re_temp21:pow2*pow3x5 == 324 ? tw_re_temp22:pow2*pow3x5 == 360 ? tw_re_temp23:pow2*pow3x5 == 384 ? tw_re_temp24:pow2*pow3x5 == 432 ? tw_re_temp25:pow2*pow3x5 == 480 ? tw_re_temp26:pow2*pow3x5 == 540 ? tw_re_temp27:pow2*pow3x5 == 576 ? tw_re_temp28:pow2*pow3x5 == 600 ? tw_re_temp29:pow2*pow3x5 == 648 ? tw_re_temp30:pow2*pow3x5 == 720 ? tw_re_temp31:pow2*pow3x5 == 768 ? tw_re_temp32:pow2*pow3x5 == 864 ? tw_re_temp33:pow2*pow3x5 == 900 ? tw_re_temp34:pow2*pow3x5 == 960 ? tw_re_temp35:pow2*pow3x5 == 972 ? tw_re_temp36:pow2*pow3x5 == 1080 ? tw_re_temp37:pow2*pow3x5 == 1152 ? tw_re_temp38:pow2*pow3x5 == 1200 ? tw_re_temp39:0;
assign Twid_im3 = pow2*pow3x5 == 12 ? tw_im_temp6 : pow2*pow3x5 == 24 ? tw_im_temp7:pow2*pow3x5 == 36 ? tw_im_temp8:pow2*pow3x5 == 48 ? tw_im_temp9:pow2*pow3x5 == 60 ? tw_im_temp10:pow2*pow3x5 == 72 ? tw_im_temp11:pow2*pow3x5 == 96 ? tw_im_temp12:pow2*pow3x5 == 108 ? tw_im_temp13:pow2*pow3x5 == 120 ? tw_im_temp14:pow2*pow3x5 == 144 ? tw_im_temp15:pow2*pow3x5 == 180 ? tw_im_temp16:pow2*pow3x5 == 192 ? tw_im_temp17:pow2*pow3x5 == 216 ? tw_im_temp18:pow2*pow3x5 == 240 ? tw_im_temp19:pow2*pow3x5 == 288 ? tw_im_temp20:pow2*pow3x5 == 300 ? tw_im_temp21:pow2*pow3x5 == 324 ? tw_im_temp22:pow2*pow3x5 == 360 ? tw_im_temp23:pow2*pow3x5 == 384 ? tw_im_temp24:pow2*pow3x5 == 432 ? tw_im_temp25:pow2*pow3x5 == 480 ? tw_im_temp26:pow2*pow3x5 == 540 ? tw_im_temp27:pow2*pow3x5 == 576 ? tw_im_temp28:pow2*pow3x5 == 600 ? tw_im_temp29:pow2*pow3x5 == 648 ? tw_im_temp30:pow2*pow3x5 == 720 ? tw_im_temp31:pow2*pow3x5 == 768 ? tw_im_temp32:pow2*pow3x5 == 864 ? tw_im_temp33:pow2*pow3x5 == 900 ? tw_im_temp34:pow2*pow3x5 == 960 ? tw_im_temp35:pow2*pow3x5 == 972 ? tw_im_temp36:pow2*pow3x5 == 1080 ? tw_im_temp37:pow2*pow3x5 == 1152 ? tw_im_temp38:pow2*pow3x5 == 1200 ? tw_im_temp39:0;

assign Twid_re = FFT3_enable?Twid_re3:FFT5_enable?Twid_re5:0;
assign Twid_im = FFT3_enable?Twid_im3:FFT5_enable?Twid_im5:0;

Multiply #(.WIDTH(WIDTH)) MU (
    .a_re   (di_re     ),  //  i
    .a_im   (di_im     ),  //  i
    .b_re   (Twid_re  ),  //  i
    .b_im   (Twid_im  ),  //  i
    .m_re   (do_re     ),  //  o
    .m_im   (do_im     )   //  o
);

assign do5_re = FFT5_enable?do_re:0;
assign do5_im = FFT5_enable?do_im:0;
assign do3_re = FFT3_enable?do_re:0;
assign do3_im = FFT3_enable?do_im:0;

assign enable5=FFT5_enable;
assign enable3=FFT3_enable;

endmodule
