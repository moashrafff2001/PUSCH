module Twiddle12 #(
    parameter   TW_FF = 0   //  Use Output Register
)(
    input           clk,  //  Master Clock
    input   [10:0]   addr,   //  Twiddle Factor Number
    output  [17:0]  tw_re,  //  Twiddle Factor (Real)
    output  [17:0]  tw_im   //  Twiddle Factor (Imag)
);

wire[17:0]  wn_re[0:11];   //  Twiddle Table (Real)
wire[17:0]  wn_im[0:11];   //  Twiddle Table (Imag)
wire[17:0]  mx_re;          //  Multiplexer output (Real)
wire[17:0]  mx_im;          //  Multiplexer output (Imag)
reg [17:0]  ff_re;          //  Register output (Real)
reg [17:0]  ff_im;          //  Register output (Imag)

assign  mx_re = addr<12 ? wn_re[addr] : 0;
assign  mx_im = addr<12 ? wn_im[addr] : 0;

always @(posedge clk) begin
    ff_re <= mx_re;
    ff_im <= mx_im;
end

assign  tw_re = TW_FF ? ff_re : mx_re;
assign  tw_im = TW_FF ? ff_im : mx_im;
assign wn_re[0] = 18'b000000010000000000; assign wn_im[0] = 18'b000000000000000000; 
assign wn_re[1] = 18'b000000001101110110; assign wn_im[1] = 18'b111111111000000000; 
assign wn_re[2] = 18'b000000001000000000; assign wn_im[2] = 18'b111111110010001001; 
assign wn_re[3] = 18'b000000000000000000; assign wn_im[3] = 18'b111111110000000000; 
assign wn_re[4] = 18'b111111111000000000; assign wn_im[4] = 18'b111111110010001001; 
assign wn_re[5] = 18'b111111110010001001; assign wn_im[5] = 18'b111111110111111111; 
assign wn_re[6] = 18'b111111110000000000; assign wn_im[6] = 18'b111111111111111111; 
assign wn_re[7] = 18'b111111110010001001; assign wn_im[7] = 18'b000000000111111111; 
assign wn_re[8] = 18'b111111110111111111; assign wn_im[8] = 18'b000000001101110110; 
assign wn_re[9] = 18'b111111111111111111; assign wn_im[9] = 18'b000000010000000000; 
assign wn_re[10] = 18'b000000000111111111; assign wn_im[10] = 18'b000000001101110110; 
assign wn_re[11] = 18'b000000001101110110; assign wn_im[11] = 18'b000000001000000000; 

endmodule
