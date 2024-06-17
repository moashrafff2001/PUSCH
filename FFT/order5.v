module order5 #(parameter WIDTH=18)(
    input clk,rst,
    input [WIDTH-1:0] di_re,
    input [WIDTH-1:0] di_im,
    input di_en,
    input [1:0] Stages,
    output reg [WIDTH-1:0] do_re,do_im,
    output reg do_en
);
wire            su1_do_en;
wire[WIDTH-1:0] su1_do_re;
wire[WIDTH-1:0] su1_do_im;


reorder25 #(.WIDTH(WIDTH)) reorder25 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su1_do_re),
    .do_im(su1_do_im),
    .do_en(su1_do_en)
);

always @(*) begin
    case (Stages)
        0: begin
            do_en = 0;
            do_re = 0;
            do_im = 0;
        end
        1: begin
            do_en = di_en;
            do_re = di_re;
            do_im = di_im;
        end

        2: begin
            do_en = su1_do_en;
            do_re = su1_do_re;
            do_im = su1_do_im;
        end
        
        default: begin
                    do_en=0;
                    do_re=0;
                    do_im=0;
                 end
    endcase
end
endmodule