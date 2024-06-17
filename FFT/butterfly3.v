module Butterfly3 #(
    parameter WIDTH = 15
)(
    input  signed [WIDTH-1:0] x0_re,
    input  signed [WIDTH-1:0] x0_im,
    input  signed [WIDTH-1:0] x1_re,
    input  signed [WIDTH-1:0] x1_im,
    input  signed [WIDTH-1:0] x2_re,
    input  signed [WIDTH-1:0] x2_im,

    output signed [WIDTH-1:0] y0_re,
    output signed [WIDTH-1:0] y0_im,
    output signed [WIDTH-1:0] y1_re,
    output signed [WIDTH-1:0] y1_im,
    output signed [WIDTH-1:0] y2_re,
    output signed [WIDTH-1:0] y2_im
   
);
    wire signed [WIDTH-1:0] b_re, b_im,c_re,c_im,b1_re,b1_im,c1_re,c1_im;
    wire[17:0]  wn_re[0:1];   
    wire[17:0]  wn_im[0:1];   
    assign wn_re[0] = 18'b111111111000000000; assign wn_im[0] = 18'b111111110010001001; 
    assign wn_re[1] = 18'b111111110111111111; assign wn_im[1] = 18'b000000001101110110; 

    Multiply #(WIDTH) M1(
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(wn_re[0]),
        .b_im(wn_im[0]),
        .m_re(b_re),
        .m_im(b_im)
    );
    Multiply #(WIDTH) M2(
        .a_re(x2_re),
        .a_im(x2_im),
        .b_re(wn_re[1]),
        .b_im(wn_im[1]),
        .m_re(c_re),
        .m_im(c_im)
    );
    Multiply #(WIDTH) M3(
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(wn_re[1]),
        .b_im(wn_im[1]),
        .m_re(b1_re),
        .m_im(b1_im)
    );
    Multiply #(WIDTH) M4(
        .a_re(x2_re),
        .a_im(x2_im),
        .b_re(wn_re[0]),
        .b_im(wn_im[0]),
        .m_re(c1_re),
        .m_im(c1_im)
    );
   
    assign y0_re = x0_re + x1_re + x2_re;
    assign y0_im = x0_im + x1_im + x2_im;
    assign y1_re = x0_re + b_re + c_re;
    assign y1_im = x0_im + b_im + c_im;
    assign y2_re = x0_re + b1_re + c1_re;
    assign y2_im = x0_im + b1_im + c1_im;




  



endmodule