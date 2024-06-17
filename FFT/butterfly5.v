module Butterfly5 #(
    parameter WIDTH = 15
)(
    input  signed [WIDTH-1:0] x0_re,
    input  signed [WIDTH-1:0] x0_im,
    input  signed [WIDTH-1:0] x1_re,
    input  signed [WIDTH-1:0] x1_im,
    input  signed [WIDTH-1:0] x2_re,
    input  signed [WIDTH-1:0] x2_im,
    input  signed [WIDTH-1:0] x3_re,
    input  signed [WIDTH-1:0] x3_im,
    input  signed [WIDTH-1:0] x4_re,
    input  signed [WIDTH-1:0] x4_im,

    output signed [WIDTH-1:0] y0_re,
    output signed [WIDTH-1:0] y0_im,
    output signed [WIDTH-1:0] y1_re,
    output signed [WIDTH-1:0] y1_im,
    output signed [WIDTH-1:0] y2_re,
    output signed [WIDTH-1:0] y2_im, 
    output signed [WIDTH-1:0] y3_re,
    output signed [WIDTH-1:0] y3_im,
    output signed [WIDTH-1:0] y4_re,
    output signed [WIDTH-1:0] y4_im
   
);
    wire signed [WIDTH-1:0] b_re,b_im,c_re,c_im,d_re,d_im,e_re,e_im,b1_re,b1_im,c1_re,c1_im,d1_re,d1_im,e1_re,e1_im,b2_re,b2_im,c2_re,c2_im,d2_re,d2_im,e2_re,e2_im,b3_re,b3_im,c3_re,c3_im,d3_re,d3_im,e3_re,e3_im;
    wire[17:0]  wn_re[0:3];   //  Twiddle Table (Real)
    wire[17:0]  wn_im[0:3];   //  Twiddle Table (Imag)

    assign wn_re[0] = 18'b000000000100111100; assign wn_im[0] = 18'b111111110000110010; 
    assign wn_re[1] = 18'b111111110011000011; assign wn_im[1] = 18'b111111110110100110; 
    assign wn_re[2] = 18'b111111110011000011; assign wn_im[2] = 18'b000000001001011001; 
    assign wn_re[3] = 18'b000000000100111100; assign wn_im[3] = 18'b000000001111001101; 

    Multiply #(.WIDTH(WIDTH)) M0 (
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(wn_re[0]),
        .b_im(wn_im[0]),
        .m_re(b_re),
        .m_im(b_im)
    );
    Multiply #(.WIDTH(WIDTH)) M1 (
        .a_re(x2_re),
        .a_im(x2_im),
        .b_re(wn_re[1]),
        .b_im(wn_im[1]),
        .m_re(c_re),
        .m_im(c_im)
    );
    Multiply #(.WIDTH(WIDTH)) M2 (
        .a_re(x3_re),
        .a_im(x3_im),
        .b_re(wn_re[2]),
        .b_im(wn_im[2]),
        .m_re(d_re),
        .m_im(d_im)
    );
    Multiply #(.WIDTH(WIDTH)) M3 (
        .a_re(x4_re),
        .a_im(x4_im),
        .b_re(wn_re[3]),
        .b_im(wn_im[3]),
        .m_re(e_re),
        .m_im(e_im)
    );
    Multiply #(.WIDTH(WIDTH)) M4 (
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(wn_re[1]),
        .b_im(wn_im[1]),
        .m_re(b1_re),
        .m_im(b1_im)
    );
    Multiply #(.WIDTH(WIDTH)) M5 (
        .a_re(x2_re),
        .a_im(x2_im),
        .b_re(wn_re[3]),
        .b_im(wn_im[3]),
        .m_re(c1_re),
        .m_im(c1_im)
    );
    Multiply #(.WIDTH(WIDTH)) M6 (
        .a_re(x3_re),
        .a_im(x3_im),
        .b_re(wn_re[0]),
        .b_im(wn_im[0]),
        .m_re(d1_re),
        .m_im(d1_im)
    );
    Multiply #(.WIDTH(WIDTH)) M7 (
        .a_re(x4_re),
        .a_im(x4_im),
        .b_re(wn_re[2]),
        .b_im(wn_im[2]),
        .m_re(e1_re),
        .m_im(e1_im)
    );
    Multiply #(.WIDTH(WIDTH)) M8 (
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(wn_re[2]),
        .b_im(wn_im[2]),
        .m_re(b2_re),
        .m_im(b2_im)
    );
    Multiply #(.WIDTH(WIDTH)) M9 (
        .a_re(x2_re),
        .a_im(x2_im),
        .b_re(wn_re[0]),
        .b_im(wn_im[0]),
        .m_re(c2_re),
        .m_im(c2_im)
    );
    Multiply #(.WIDTH(WIDTH)) M10 (
        .a_re(x3_re),
        .a_im(x3_im),
        .b_re(wn_re[3]),
        .b_im(wn_im[3]),
        .m_re(d2_re),
        .m_im(d2_im)
    );
    Multiply #(.WIDTH(WIDTH)) M11 (
        .a_re(x4_re),
        .a_im(x4_im),
        .b_re(wn_re[1]),
        .b_im(wn_im[1]),
        .m_re(e2_re),
        .m_im(e2_im)
    );
    Multiply #(.WIDTH(WIDTH)) M12 (
        .a_re(x1_re),
        .a_im(x1_im),
        .b_re(wn_re[3]),
        .b_im(wn_im[3]),
        .m_re(b3_re),
        .m_im(b3_im)
    );
    Multiply #(.WIDTH(WIDTH)) M13 (
        .a_re(x2_re),
        .a_im(x2_im),
        .b_re(wn_re[2]),
        .b_im(wn_im[2]),
        .m_re(c3_re),
        .m_im(c3_im)
    );
    Multiply #(.WIDTH(WIDTH)) M14 (
        .a_re(x3_re),
        .a_im(x3_im),
        .b_re(wn_re[1]),
        .b_im(wn_im[1]),
        .m_re(d3_re),
        .m_im(d3_im)
    );
    Multiply #(.WIDTH(WIDTH)) M15 (
        .a_re(x4_re),
        .a_im(x4_im),
        .b_re(wn_re[0]),
        .b_im(wn_im[0]),
        .m_re(e3_re),
        .m_im(e3_im)
    );
    
    assign y0_re = x0_re + x1_re + x2_re + x3_re + x4_re;
    assign y0_im = x0_im + x1_im + x2_im + x3_im + x4_im;
    assign y1_re = x0_re + b_re + c_re + d_re + e_re;
    assign y1_im = x0_im + b_im + c_im + d_im + e_im;
    assign y2_re = x0_re + b1_re + c1_re + d1_re + e1_re;
    assign y2_im = x0_im + b1_im + c1_im + d1_im + e1_im;
    assign y3_re = x0_re + b2_re + c2_re + d2_re + e2_re;
    assign y3_im = x0_im + b2_im + c2_im + d2_im + e2_im;
    assign y4_re = x0_re + b3_re + c3_re + d3_re + e3_re;
    assign y4_im = x0_im + b3_im + c3_im + d3_im + e3_im;



  



endmodule