module Butterfly2 #(
    parameter WIDTH=14
) (
    input   signed  [WIDTH-1:0] x0_re,  //  Input Data #0 (Real)
    input   signed  [WIDTH-1:0] x0_im,  //  Input Data #0 (Imag)
    input   signed  [WIDTH-1:0] x1_re,  //  Input Data #1 (Real)
    input   signed  [WIDTH-1:0] x1_im,  //  Input Data #1 (Imag)
    output  signed  [WIDTH-1:0] y0_re,  //  Output Data #0 (Real)
    output  signed  [WIDTH-1:0] y0_im,  //  Output Data #0 (Imag)
    output  signed  [WIDTH-1:0] y1_re,  //  Output Data #1 (Real)
    output  signed  [WIDTH-1:0] y1_im   //  Output Data #1 (Imag)
);

wire signed [WIDTH-1:0]   add_re, add_im, sub_re, sub_im;


assign  add_re = x0_re + x1_re;
assign  add_im = x0_im + x1_im;
assign  sub_re = x0_re - x1_re;
assign  sub_im = x0_im - x1_im;

// round  #(.WIDTH(WIDTH)) U0(
//     .num_in(add_re),
//     .rounded_out(y0_re)
// );

// round  #(.WIDTH(WIDTH)) U1(
//     .num_in(add_im),
//     .rounded_out(y0_im)
// );
// round  #(.WIDTH(WIDTH)) U2(
//     .num_in(sub_re),
//     .rounded_out(y1_re)
// );
// round  #(.WIDTH(WIDTH)) U3(
//     .num_in(sub_im),
//     .rounded_out(y1_im)
// );
assign  y0_re = add_re;
assign  y0_im = add_im;
assign  y1_re = sub_re;
assign  y1_im = sub_im;

endmodule
