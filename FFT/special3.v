module Special3 #(
    parameter WIDTH=15
)(
    input signed [WIDTH-1:0] a_re,
    input signed [WIDTH-1:0] a_im,
    input signed [WIDTH-1:0] b_re,
    input signed [WIDTH-1:0] b_im,
    output signed [WIDTH-1:0] m_re,
    output signed [WIDTH-1:0] m_im,
    output signed [WIDTH-1:0] n_re,
    output signed [WIDTH-1:0] n_im
);

assign m_re = -(a_re/2) + ((a_im/2) + (a_im/4) + (a_im/16) + (a_im/32) + (a_im/64) + (a_im/256) + (a_im/512) + (a_im/2048) + (a_im/4096) + (a_im/16384));
assign m_im = -(a_im/2) - ((a_re/2) + (a_re/4) + (a_re/16) + (a_re/32) + (a_re/64) + (a_re/256) + (a_re/512) + (a_re/2048) + (a_re/4096) + (a_re/16384));
assign n_re = -(b_re/2) - ((b_im/2) + (b_im/4) + (b_im/16) + (b_im/32) + (b_im/64) + (b_im/256) + (b_im/512) + (b_im/2048) + (b_im/4096) + (b_im/16384));
assign n_im = -(b_im/2) + ((b_re/2) + (b_re/4) + (b_re/16) + (b_re/32) + (b_re/64) + (b_re/256) + (b_re/512) + (b_re/2048) + (b_re/4096) + (b_re/16384));

endmodule