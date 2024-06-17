module FFT3 #(
    parameter   WIDTH = 18
)(
   input               clk,  //  Master clk
    input               rst,  //  Active High Asynchronous rst
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    input [2:0]         Stages,
    output           do_en,  //  Output Data Enable
    output   [WIDTH-1:0] do_re,  //  Output Data (Real)
    output   [WIDTH-1:0] do_im   //  Output Data (Imag)
    
);
wire              out_en;  //  Output Data Enable
wire  [WIDTH-1:0] out_re;  //  Output Data (Real)
wire  [WIDTH-1:0] out_im;   //  Output Data (Imag)
reg stages1, stages2, stages3, stages4, stages5;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stages1 <= 0;
        stages2 <= 0;
        stages3 <= 0;
        stages4 <= 0;
        stages5 <= 0;

    end else begin
        stages1 <= Stages[0] && !Stages[1] && !Stages[2] ;
        stages2 <= Stages[1] && !Stages[0] && !Stages[2] ;
        stages3 <= Stages[0] && Stages[1] && !Stages[2] ;
        stages4 <= Stages[2] && !Stages[0] && !Stages[1];
        stages5 <= Stages[2] && Stages[0]  && !Stages[1];
    
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


SdfUnit243 #(.WIDTH(WIDTH)) SDF_243 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages5),
    .do_en  (su1_do_en  ),  //  o
    .do_re  (su1_do_re  ),  //  o
    .do_im  (su1_do_im  )   //  o
);


///////////////////////////////////////////////
SdfUnit81 #(.WIDTH(WIDTH)) SDF_81 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
     .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages4),
    .do_en  (su2_do_en  ),  //  o
    .do_re  (su2_do_re  ),  //  o
    .do_im  (su2_do_im)
);

//////////////////////////////////////
SdfUnit27 #(.WIDTH(WIDTH)) SDF_27 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
     .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages3),
    .do_en  (su3_do_en  ),  //  o
    .do_re  (su3_do_re  ),  //  o
    .do_im  (su3_do_im  )   //  o
);

////////////////////////////////////////////////////
SdfUnit9 #(.WIDTH(WIDTH)) SDF_9 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages2),
    .do_en  (su4_do_en      ),  //  o
    .do_re  (su4_do_re      ),  //  o
    .do_im  (su4_do_im      )   //  o
);
///////////////////////////////////////////////
SdfUnit3 #(.WIDTH(WIDTH)) SDF_3 (
    .clk  (clk      ),  //  i
    .rst  (rst      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .on     (stages1),
    .do_en  (su5_do_en      ),  //  o
    .do_re  (su5_do_re      ),  //  o
    .do_im  (su5_do_im      )   //  o
);


always @(*) begin
    case (Stages)
        0: begin
            ord_do_en = 0;
            ord_do_re = 0;
            ord_do_im = 0;
        end
        1: begin
            ord_do_en = su5_do_en;
            ord_do_re = su5_do_re;
            ord_do_im = su5_do_im;
        end

        2: begin
            ord_do_en = su4_do_en;
            ord_do_re = su4_do_re;
            ord_do_im = su4_do_im;
        end
        3: begin
            ord_do_en = su3_do_en;
            ord_do_re = su3_do_re;
            ord_do_im = su3_do_im;
        end
        4: begin
            ord_do_en = su2_do_en;
            ord_do_re = su2_do_re;
            ord_do_im = su2_do_im;
        end
        5: begin
            ord_do_en = su1_do_en;
            ord_do_re = su1_do_re;
            ord_do_im = su1_do_im;
        end
        default: begin
                    ord_do_en=0;
                    ord_do_re=0;
                    ord_do_im=0;
                 end
    endcase
end
order3 #(.WIDTH(WIDTH)) order3 (
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