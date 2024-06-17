module FFT5 #(
    parameter   WIDTH = 18
)(
    input               clk,  //  Master clk
    input               rst,  //  Active High Asynchronous rst
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    input [1:0]         Stages,
    output           do_en,  //  Output Data Enable
    output   [WIDTH-1:0] do_re,  //  Output Data (Real)
    output   [WIDTH-1:0] do_im   //  Output Data (Imag)

);
wire              out_en;  //  Output Data Enable
wire  [WIDTH-1:0] out_re;  //  Output Data (Real)
wire  [WIDTH-1:0] out_im;   //  Output Data (Imag)
reg stages1, stages2;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stages1 = 0;
        stages2 = 0;

    end else begin
        stages1 = Stages[0] && !Stages[1] ;
        stages2 = Stages[1] && !Stages[0] ;
    end
    
end
wire            su1_do_en;
wire[WIDTH-1:0] su1_do_re;
wire[WIDTH-1:0] su1_do_im;
wire            su2_do_en;
wire[WIDTH-1:0] su2_do_re;
wire[WIDTH-1:0] su2_do_im;

reg            ord_do_en;
reg[WIDTH-1:0] ord_do_re;
reg[WIDTH-1:0] ord_do_im;

SdfUnit25 #(.WIDTH(WIDTH)) SDF_25 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages2),
    .do_en  (su1_do_en  ),  //  o
    .do_re  (su1_do_re  ),  //  o
    .do_im  (su1_do_im  )   //  o
);


///////////////////////////////////////////////
SdfUnit5 #(.WIDTH(WIDTH)) SDF_5 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
     .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages1),
    .do_en  (su2_do_en  ),  //  o
    .do_re  (su2_do_re  ),  //  o
    .do_im  (su2_do_im)
);


always @(*) begin
    case (Stages)
        0: begin
            ord_do_en = 0;
            ord_do_re = 0;
            ord_do_im = 0;
        end
        2: begin
            ord_do_en = su1_do_en;
            ord_do_re = su1_do_re;
            ord_do_im = su1_do_im;
        end

        1: begin
            ord_do_en = su2_do_en;
            ord_do_re = su2_do_re;
            ord_do_im = su2_do_im;
        end
        default: begin
                 ord_do_en = 0;
                 ord_do_re = 0;
                 ord_do_im = 0;
                end   
    endcase
end

order5 #(.WIDTH(WIDTH)) ORDER_5 (
    .clk(clk),
    .rst(rst),
    .di_re(ord_do_re),
    .di_im(ord_do_im),
    .di_en(ord_do_en),
    .Stages(Stages),
    .do_re(out_re),
    .do_im(out_im),
    .do_en(out_en)
);

assign do_en = out_en;
assign do_re = out_re;
assign do_im = out_im;
endmodule