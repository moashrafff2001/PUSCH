module Multiply #(
    parameter   WIDTH = 14
)(
    input   signed  [WIDTH-1:0] a_re,
    input   signed  [WIDTH-1:0] a_im,
    input   signed  [WIDTH-1:0] b_re,
    input   signed  [WIDTH-1:0] b_im,
    output  signed  [WIDTH-1:0] m_re,
    output  signed  [WIDTH-1:0] m_im
);

wire signed [WIDTH*2-1:0]   S1, S3,  S2,  S4,  S5;


//  Signed Multiplication
assign  S1 = a_re * b_re;
assign  S3 = (a_re + a_im) * (b_re + b_im);
assign  S2 = a_im * b_im;

assign S4=S1-S2;
assign S5=S3-S1-S2;


// assign  Stemp4 = S4 >> 8;
// assign  Stemp5 = S5 >> 8;

// round  #(.WIDTH(WIDTH)) U0 (
//     .num_in(Stemp4[WIDTH:0]),
//     .rounded_out(m_re)
// );

// round  #(.WIDTH(WIDTH)) U1(
//     .num_in(Stemp5[WIDTH:0]),
//     .rounded_out(m_im)
// );
assign  m_re = S4 >>> 10 ;
assign  m_im = S5 >>> 10;
endmodule