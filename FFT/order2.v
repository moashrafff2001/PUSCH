module order2 #(parameter WIDTH=18)(
    input clk,rst,
    input [WIDTH-1:0] di_re,
    input [WIDTH-1:0] di_im,
    input di_en,
    input [3:0] Stages,
    output reg [WIDTH-1:0] do_re,do_im,
    output reg do_en
);
wire            su1_do_en;
wire[WIDTH-1:0] su1_do_re;
wire[WIDTH-1:0] su1_do_im;
wire            su2_do_en;
wire[WIDTH-1:0] su2_do_re;
wire[WIDTH-1:0] su2_do_im;
wire            su3_do_en;
wire[WIDTH-1:0] su3_do_re;
wire[WIDTH-1:0] su3_do_im;
wire            su4_do_en;
wire[WIDTH-1:0] su4_do_re;
wire[WIDTH-1:0] su4_do_im;
wire            su5_do_en;
wire[WIDTH-1:0] su5_do_re;
wire[WIDTH-1:0] su5_do_im;
wire            su6_do_en;
wire[WIDTH-1:0] su6_do_re;
wire[WIDTH-1:0] su6_do_im;
wire            su7_do_en;
wire[WIDTH-1:0] su7_do_re;
wire[WIDTH-1:0] su7_do_im;

reorder4 #(.WIDTH(WIDTH)) reorder4 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su1_do_re),
    .do_im(su1_do_im),
    .do_en(su1_do_en)
);

reorder8 #(.WIDTH(WIDTH)) reorder8 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su2_do_re),
    .do_im(su2_do_im),
    .do_en(su2_do_en)
);

reorder16 #(.WIDTH(WIDTH)) reorder16 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su3_do_re),
    .do_im(su3_do_im),
    .do_en(su3_do_en)
);

reorder32 #(.WIDTH(WIDTH)) reorder32 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su4_do_re),
    .do_im(su4_do_im),
    .do_en(su4_do_en)
);

reorder64 #(.WIDTH(WIDTH)) reorder64 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su5_do_re),
    .do_im(su5_do_im),
    .do_en(su5_do_en)
);

reorder128 #(.WIDTH(WIDTH)) reorder128 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su6_do_re),
    .do_im(su6_do_im),
    .do_en(su6_do_en)
);

reorder256 #(.WIDTH(WIDTH)) reorder256 (
    .clk(clk),
    .rst(rst),
    .di_re(di_re),
    .di_im(di_im),
    .di_en(di_en),
    .do_re(su7_do_re),
    .do_im(su7_do_im),
    .do_en(su7_do_en)
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
        3: begin
            do_en = su2_do_en;
            do_re = su2_do_re;
            do_im = su2_do_im;
        end
        4: begin
            do_en = su3_do_en;
            do_re = su3_do_re;
            do_im = su3_do_im;
        end
        5: begin
            do_en = su4_do_en;
            do_re = su4_do_re;
            do_im = su4_do_im;
        end
        6: begin
            do_en = su5_do_en;
            do_re = su5_do_re;
            do_im = su5_do_im;
        end
        7: begin
            do_en = su6_do_en;
            do_re = su6_do_re;
            do_im = su6_do_im;
        end
        8: begin
            do_en = su7_do_en;
            do_re = su7_do_re;
            do_im = su7_do_im;
        end
        default: begin
                    do_en=0;
                    do_re=0;
                    do_im=0;
                 end
    endcase
end
endmodule