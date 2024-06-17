module Special5 #(
    parameter WIDTH=15
)(
    input signed [WIDTH-1:0] a_re,
    input signed [WIDTH-1:0] a_im,
    input signed [WIDTH-1:0] b_re,
    input signed [WIDTH-1:0] b_im,
    input signed [WIDTH-1:0] c_re,
    input signed [WIDTH-1:0] c_im,
    input signed [WIDTH-1:0] d_re,
    input signed [WIDTH-1:0] d_im,

    output signed [WIDTH-1:0] l_re,
    output signed [WIDTH-1:0] l_im,
    output signed [WIDTH-1:0] m_re,
    output signed [WIDTH-1:0] m_im,
    output signed [WIDTH-1:0] n_re,
    output signed [WIDTH-1:0] n_im,
    output signed [WIDTH-1:0] o_re,
    output signed [WIDTH-1:0] o_im
);

assign l_re = (a_re / 4 +  a_re / 32 + a_re / 64 + a_re / 128 + a_re / 256 + a_re / 4096 + a_re / 8192 + a_re / 32768) + (a_im / 2 + a_im / 4 + a_im / 8 + a_im / 16 + a_im / 128 + a_im / 256 +  a_im / 1024 + a_im / 2048 + a_im / 4096 + a_im / 8192 );
assign l_im = (a_im / 4 +  a_im / 32 + a_im / 64 + a_im / 128 + a_im / 256 + a_im / 4096 + a_im / 8192 + a_im / 32768) - (a_re / 2 + a_re / 4 + a_re / 8 + a_re / 16 + a_re / 128 + a_re / 256 +  a_re / 1024 + a_re / 2048 + a_re / 4096 + a_re / 8192 );
assign m_re = -(b_re / 2 + b_re / 4 + b_re / 32 + b_re / 64 + b_re / 128 + b_re / 256  + b_re / 4096 + b_re / 8192 + b_re / 16384) + (b_im / 2  + b_im / 16 + b_im / 64 + b_im / 128 + b_im / 1024 + b_im / 2048 + b_im / 4096 + b_im / 8192 );
assign m_im = -(b_im / 2 + b_im / 4 + b_im / 32 + b_im / 64 + b_im / 128 + b_im / 256  + b_im / 4096 + b_im / 8192 + b_im / 16384) - (b_re / 2  + b_re / 16 + b_re / 64 + b_re / 128 + b_re / 1024 + b_re / 2048 + b_re / 4096 + b_re / 8192 );
assign n_re = -(c_re / 2 + c_re / 4 + c_re / 32 + c_re / 64 + c_re / 128 + c_re / 256  + c_re / 4096 + c_re / 8192 + c_re / 16384) - (c_im / 2  + c_im / 16 + c_im / 64 + c_im / 128 + c_im / 1024 + c_im / 2048 + c_im / 4096 + c_im / 8192 );
assign n_im = -(c_im / 2 + c_im / 4 + c_im / 32 + c_im / 64 + c_im / 128 + c_im / 256  + c_im / 4096 + c_im / 8192 + c_im / 16384) + (c_re / 2  + c_re / 16 + c_re / 64 + c_re / 128 + c_re / 1024 + c_re / 2048 + c_re / 4096 + c_re / 8192 );
assign o_re = (d_re / 4 +  d_re / 32 + d_re / 64 + d_re / 128 + d_re / 256 + d_re / 4096 + d_re / 16384 + d_re / 32768) - (d_im / 2 + d_im / 4 + d_im / 8 + d_im / 16 + d_im / 128 + d_im / 256 +  d_im / 1024 + d_im / 2048 + d_im / 4096 + d_im / 8192 );
assign o_im = (d_im / 4 +  d_im / 32 + d_im / 64 + d_im / 128 + d_im / 256 + d_im / 4096 + d_im / 16384 + d_re / 32768) + (d_re / 2 + d_re / 4 + d_re / 8 + d_re / 16 + d_re / 128 + d_re / 256 +  d_re / 1024 + d_re / 2048 + d_re / 4096 + d_re / 8192 );


endmodule