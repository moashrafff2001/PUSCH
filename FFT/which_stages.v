module which_stages(
    input wire flag,
    input wire done,
    input wire reset,
    input wire clk,
    input wire [10:0] last_address,
    output reg [3:0] stages2,
    output reg [2:0] stages3,
    output reg [1:0] stages5,
    output reg [10:0] points
);

    reg [10:0] counter; // Adjusted counter size to reach 1200
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 1;
            stages2 <= 4'b0;
            stages3 <= 3'b0;
            stages5 <= 2'b0;
            points <= 0;
        end else if (flag && !done) begin
            counter <= counter + 1;
        end else if (done) begin
            case (last_address)
                    12: begin
                        stages2 <= 2;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 12;
                    end
                    24: begin
                        stages2 <= 3;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 24;
                    end
                    36: begin
                        stages2 <= 2;
                        stages3 <= 2;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 36;
                    end
                    48: begin
                        stages2 <= 4;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 48;
                    end
                    60: begin
                        stages2 <= 2;
                        stages3 <= 1;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 60;
                    end
                    72: begin
                        stages2 <= 3;
                        stages3 <= 2;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 72;
                    end
                    96: begin
                        stages2 <= 5;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 96;
                    end
                    108: begin
                        stages2 <= 2;
                        stages3 <= 3;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 108;
                    end
                    120: begin
                        stages2 <= 3;
                        stages3 <= 1;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 120;
                    end
                    144: begin
                        stages2 <= 4;
                        stages3 <= 2;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 144;
                    end
                    180: begin
                        stages2 <= 2;
                        stages3 <= 2;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 180;
                    end
                    192: begin
                        stages2 <= 6;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 192;
                    end
                    216: begin
                        stages2 <= 3;
                        stages3 <= 3;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 216;
                    end
                    240: begin
                        stages2 <= 4;
                        stages3 <= 1;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 240;
                    end
                    288: begin
                        stages2 <= 5;
                        stages3 <= 2;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 288;
                    end
                    300: begin
                        stages2 <= 2;
                        stages3 <= 1;
                        stages5 <= 2;
                        counter <= 1;
                        points <= 300;
                    end
                    324: begin
                        stages2 <= 2;
                        stages3 <= 4;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 324;
                    end
                    360: begin
                        stages2 <= 3;
                        stages3 <= 2;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 360;
                    end
                    384: begin
                        stages2 <= 7;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 384;
                    end
                    432: begin
                        stages2 <= 4;
                        stages3 <= 3;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 432;
                    end
                    480: begin
                        stages2 <= 5;
                        stages3 <= 1;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 480;
                    end
                    540: begin
                        stages2 <= 2;
                        stages3 <= 3;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 540;
                    end
                    576: begin
                        stages2 <= 6;
                        stages3 <= 2;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 576;
                    end
                    600: begin
                        stages2 <= 3;
                        stages3 <= 1;
                        stages5 <= 2;
                        counter <= 1;
                        points <= 600;
                    end
                    648: begin
                        stages2 <= 3;
                        stages3 <= 4;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 648;
                    end
                    720: begin
                        stages2 <= 4;
                        stages3 <= 2;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 720;
                    end
                    768: begin
                        stages2 <= 8;
                        stages3 <= 1;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 768;
                    end
                    864: begin
                        stages2 <= 5;
                        stages3 <= 3;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 864;
                    end
                    900: begin
                        stages2 <= 2;
                        stages3 <= 2;
                        stages5 <= 2;
                        counter <= 1;
                        points <= 900;
                    end
                    960: begin
                        stages2 <= 6;
                        stages3 <= 1;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 960;
                    end
                    972: begin
                        stages2 <= 2;
                        stages3 <= 5;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 972;
                    end
                    1080: begin
                        stages2 <= 3;
                        stages3 <= 3;
                        stages5 <= 1;
                        counter <= 1;
                        points <= 1080;
                    end
                    1152: begin
                        stages2 <= 7;
                        stages3 <= 2;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 1152;
                    end
                    1200: begin
                        stages2 <= 4;
                        stages3 <= 1;
                        stages5 <= 2;
                        counter <= 1;
                        points <= 1200;
                    end
                    default: begin
                        stages2 <= 0;
                        stages3 <= 0;
                        stages5 <= 0;
                        counter <= 1;
                        points <= 0;
                    end
                endcase

        end else begin 
            stages2 <=stages2;
            stages3<=stages3;
            stages5<=stages5;
            counter<=counter;
        end
    end        
endmodule