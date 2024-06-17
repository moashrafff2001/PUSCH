module DelayBuffer #(
    parameter   DEPTH = 128,
    parameter   WIDTH = 14
)(
    input clk,  
    input   [WIDTH-1:0] in_re,  //  Data Input (Real)
    input   [WIDTH-1:0] in_im,  //  Data Input (Imag)
    output  [WIDTH-1:0] out_re,  //  Data Output (Real)
    output  [WIDTH-1:0] out_im   //  Data Output (Imag)
);

reg [WIDTH-1:0] buf_re[0:DEPTH-1];
reg [WIDTH-1:0] buf_im[0:DEPTH-1];
integer n;

always @(posedge clk) begin
    for (n = DEPTH-1; n > 0; n = n - 1) begin
        buf_re[n] <= buf_re[n-1];
        buf_im[n] <= buf_im[n-1];
    end
    buf_re[0] <= in_re;
    buf_im[0] <= in_im;
end

assign  out_re = buf_re[DEPTH-1];
assign  out_im = buf_im[DEPTH-1];

endmodule