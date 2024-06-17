module FFT2 #(
    parameter   WIDTH = 18
)(
    input               clk,  //  Master clk
    input               rst,  //  Active High Asynchronous rst
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    input [3:0]         Stages,
    output           do_en,  //  Output Data Enable
    output   [WIDTH-1:0] do_re,  //  Output Data (Real)
    output   [WIDTH-1:0] do_im   //  Output Data (Imag)
    
);
wire              out_en;  //  Output Data Enable
wire  [WIDTH-1:0] out_re;  //  Output Data (Real)
wire  [WIDTH-1:0] out_im;   //  Output Data (Imag)
reg stages2, stages3, stages4, stages5, stages6, stages7, stages8;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stages2 <= 0;
        stages3 <= 0;
        stages4 <= 0;
        stages5 <= 0;
        stages6 <= 0;
        stages7 <= 0;
        stages8 <= 0;
    end else begin
        stages2 <= Stages[1] && !Stages[0] && !Stages[2] && !Stages[3];
        stages3 <= Stages[0] && Stages[1] && !Stages[2] && !Stages[3];
        stages4 <= Stages[2] && !Stages[3] && !Stages[0] && !Stages[1];
        stages5 <= Stages[2] && Stages[0] && !Stages[3] && !Stages[1];
        stages6 <= Stages[1] && Stages[2] && !Stages[3] && !Stages[0];
        stages7 <= Stages[0] && Stages[1] && Stages[2] && !Stages[3];
        stages8 <= Stages[3] && !Stages[2] && !Stages[1] && !Stages[0];
    end
    
end
reg            ord_do_en;
reg[WIDTH-1:0] ord_do_re;
reg[WIDTH-1:0] ord_do_im;

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
wire            su8_do_en;
wire[WIDTH-1:0] su8_do_re;
wire[WIDTH-1:0] su8_do_im;
wire            su9_do_en;
wire[WIDTH-1:0] su9_do_re;
wire[WIDTH-1:0] su9_do_im;
wire            su10_do_en;
wire[WIDTH-1:0] su10_do_re;
wire[WIDTH-1:0] su10_do_im;
wire            su11_do_en;
wire[WIDTH-1:0] su11_do_re;
wire[WIDTH-1:0] su11_do_im;
wire            su12_do_en;
wire[WIDTH-1:0] su12_do_re;
wire[WIDTH-1:0] su12_do_im;
wire            su13_do_en;
wire[WIDTH-1:0] su13_do_re;
wire[WIDTH-1:0] su13_do_im;
wire            su14_do_en;
wire[WIDTH-1:0] su14_do_re;
wire[WIDTH-1:0] su14_do_im;
wire            su15_do_en;
wire[WIDTH-1:0] su15_do_re;
wire[WIDTH-1:0] su15_do_im;
wire            su16_do_en;
wire[WIDTH-1:0] su16_do_re;
wire[WIDTH-1:0] su16_do_im;
wire            su17_do_en;
wire[WIDTH-1:0] su17_do_re;
wire[WIDTH-1:0] su17_do_im;
wire            su18_do_en;
wire[WIDTH-1:0] su18_do_re;
wire[WIDTH-1:0] su18_do_im;
wire            su19_do_en;
wire[WIDTH-1:0] su19_do_re;
wire[WIDTH-1:0] su19_do_im;

SdfUnit256 #(.N(256),.TWIDDLE(256),.WIDTH(WIDTH)) SDF_256_1 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages8),
    .do_en  (su1_do_en  ),  //  o
    .do_re  (su1_do_re  ),  //  o
    .do_im  (su1_do_im  )   //  o
);

SdfUnit256 #(.N(256),.TWIDDLE(64),.WIDTH(WIDTH)) SDF_256_2 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su1_do_en  ),  //  i
    .di_re  (su1_do_re  ),  //  i
    .di_im  (su1_do_im  ),  //  i
    .on     (stages8),
    .do_en  (su2_do_en  ),  //  o
    .do_re  (su2_do_re  ),  //  o
    .do_im  (su2_do_im  )   //  o
);

SdfUnit256 #(.N(256),.TWIDDLE(16),.WIDTH(WIDTH)) SDF_256_3 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su2_do_en  ),  //  i
    .di_re  (su2_do_re  ),  //  i
    .di_im  (su2_do_im  ),  //  i
    .on     (stages8),
    .do_en  (su3_do_en  ),  //  o
    .do_re  (su3_do_re  ),  //  o
    .do_im  (su3_do_im  )   //  o
);

SdfUnit256 #(.N(256),.TWIDDLE(4),.WIDTH(WIDTH)) SDF_256_4 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su3_do_en  ),  //  i
    .di_re  (su3_do_re  ),  //  i
    .di_im  (su3_do_im  ),  //  i
    .on     (stages8),
    .do_en  (su4_do_en      ),  //  o
    .do_re  (su4_do_re      ),  //  o
    .do_im  (su4_do_im      )   //  o
);

///////////////////////////////////////////////
SdfUnit128 #(.N(128),.TWIDDLE(128),.WIDTH(WIDTH)) SDF_128_1 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
     .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages7),
    .do_en  (su5_do_en  ),  //  o
    .do_re  (su5_do_re  ),  //  o
    .do_im  (su5_do_im)
);

SdfUnit128 #(.N(128),.TWIDDLE(32),.WIDTH(WIDTH)) SDF_128_2 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su5_do_en  ),  //  i
    .di_re  (su5_do_re  ),  //  i
    .di_im  (su5_do_im  ),  //  i
    .on     (stages7),
    .do_en  (su6_do_en  ),  //  o
    .do_re  (su6_do_re  ),  //  o
    .do_im  (su6_do_im  )   //  o
);

SdfUnit128 #(.N(128),.TWIDDLE(8),.WIDTH(WIDTH)) SDF_128_3 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su6_do_en  ),  //  i
    .di_re  (su6_do_re  ),  //  i
    .di_im  (su6_do_im  ),  //  i
    .on     (stages7),
    .do_en  (su7_do_en  ),  //  o
    .do_re  (su7_do_re  ),  //  o
    .do_im  (su7_do_im  )   //  o
);

SdfUnit2 #(.WIDTH(WIDTH)) SDF_128_4 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su7_do_en  ),  //  i
    .di_re  (su7_do_re  ),  //  i
    .di_im  (su7_do_im  ),  //  i
    .on     (stages7),
    .do_en  (su8_do_en      ),  //  o
    .do_re  (su8_do_re      ),  //  o
    .do_im  (su8_do_im      )   //  o
);
//////////////////////////////////////
SdfUnit64 #(.N(64),.TWIDDLE(64),.WIDTH(WIDTH)) SDF_64_1 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
     .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages6),
    .do_en  (su9_do_en  ),  //  o
    .do_re  (su9_do_re  ),  //  o
    .do_im  (su9_do_im  )   //  o
);

SdfUnit64 #(.N(64),.TWIDDLE(16),.WIDTH(WIDTH)) SDF_64_2 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su9_do_en  ),  //  i
    .di_re  (su9_do_re  ),  //  i
    .di_im  (su9_do_im  ),  //  i
    .on     (stages6),
    .do_en  (su10_do_en  ),  //  o
    .do_re  (su10_do_re  ),  //  o
    .do_im  (su10_do_im  )   //  o
);

SdfUnit64 #(.N(64),.TWIDDLE(4),.WIDTH(WIDTH)) SDF_64_3 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su10_do_en  ),  //  i
    .di_re  (su10_do_re  ),  //  i
    .di_im  (su10_do_im  ),  //  i
    .on     (stages6),
    .do_en  (su11_do_en      ),  //  o
    .do_re  (su11_do_re      ),  //  o
    .do_im  (su11_do_im      )   //  o
);
////////////////////////////////////////////////////
SdfUnit32 #(.N(32),.TWIDDLE(32),.WIDTH(WIDTH)) SDF_32_1 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages5),
    .do_en  (su12_do_en      ),  //  o
    .do_re  (su12_do_re      ),  //  o
    .do_im  (su12_do_im      )   //  o
);
SdfUnit32 #(.N(32),.TWIDDLE(8),.WIDTH(WIDTH)) SDF_32_2 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su12_do_en  ),  //  i
    .di_re  (su12_do_re  ),  //  i
    .di_im  (su12_do_im  ),  //  i
    .on     (stages5),
    .do_en  (su13_do_en      ),  //  o
    .do_re  (su13_do_re      ),  //  o
    .do_im  (su13_do_im      )   //  o
);
SdfUnit2 #(.WIDTH(WIDTH)) SDF_32_3 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su13_do_en  ),  //  i
    .di_re  (su13_do_re  ),  //  i
    .di_im  (su13_do_im  ),  //  i
    .on     (stages5),
    .do_en  (su14_do_en      ),  //  o
    .do_re  (su14_do_re      ),  //  o
    .do_im  (su14_do_im      )   //  o
);
///////////////////////////////////////////////
SdfUnit16 #(.N(16),.TWIDDLE(16),.WIDTH(WIDTH)) SDF_16_1 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages4),
    .do_en  (su15_do_en      ),  //  o
    .do_re  (su15_do_re      ),  //  o
    .do_im  (su15_do_im      )   //  o
);

SdfUnit16 #(.N(16),.TWIDDLE(4),.WIDTH(WIDTH)) SDF_16_2 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su15_do_en  ),  //  i
    .di_re  (su15_do_re  ),  //  i
    .di_im  (su15_do_im  ),  //  i
    .on     (stages4),
    .do_en  (su16_do_en      ),  //  o
    .do_re  (su16_do_re      ),  //  o
    .do_im  (su16_do_im      )   //  o
);
//////////////////////////////////////////////////
SdfUnit8 #(.N(8),.TWIDDLE(8),.WIDTH(WIDTH)) SDF_8_1 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages3),
    .do_en  (su17_do_en      ),  //  o
    .do_re  (su17_do_re      ),  //  o
    .do_im  (su17_do_im      )   //  o
);
SdfUnit2 #(.WIDTH(WIDTH)) SDF_8_2 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (su17_do_en  ),  //  i
    .di_re  (su17_do_re  ),  //  i
    .di_im  (su17_do_im  ),  //  i
    .on     (stages3),
    .do_en  (su18_do_en      ),  //  o
    .do_re  (su18_do_re      ),  //  o
    .do_im  (su18_do_im      )   //  o
);
//////////////////////////////////////////////////
SdfUnit4 #(.N(4),.TWIDDLE(4),.WIDTH(WIDTH)) SDF_4 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages2),
    .do_en  (su19_do_en      ),  //  o
    .do_re  (su19_do_re      ),  //  o
    .do_im  (su19_do_im      )   //  o
);

always @(*) begin
    case (Stages)
        2: begin
            ord_do_en = su19_do_en;
            ord_do_re = su19_do_re;
            ord_do_im = su19_do_im;
        end
        3: begin
            ord_do_en = su18_do_en;
            ord_do_re = su18_do_re;
            ord_do_im = su18_do_im;
        end
        4: begin
            ord_do_en = su16_do_en;
            ord_do_re = su16_do_re;
            ord_do_im = su16_do_im;
        end
        5: begin
            ord_do_en = su14_do_en;
            ord_do_re = su14_do_re;
            ord_do_im = su14_do_im;
        end
        6: begin
            ord_do_en = su11_do_en;
            ord_do_re = su11_do_re;
            ord_do_im = su11_do_im;
        end
        7: begin
            ord_do_en = su8_do_en;
            ord_do_re = su8_do_re;
            ord_do_im = su8_do_im;
        end
        8: begin
            ord_do_en = su4_do_en;
            ord_do_re = su4_do_re;
            ord_do_im = su4_do_im;
        end
        default: begin
                    ord_do_en=0;
                    ord_do_re=0;
                    ord_do_im=0;
                 end
    endcase
end
order2 #(.WIDTH(WIDTH)) order2 (
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