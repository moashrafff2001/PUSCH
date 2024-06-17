module SdfUnit3 #(
    parameter   WIDTH = 14 //  Data Bit Length
)(
    input                   clk,  //  Master clk
    input                   rst,  //  Active High Asynchronous rst
    input                   di_en,  //  Input Data Enable
    input       [WIDTH-1:0] di_re,  //  Input Data (Real)
    input       [WIDTH-1:0] di_im,  //  Input Data (Imag)
    input on,
    output  reg             do_en,  //  Output Data Enable
    output  reg [WIDTH-1:0] do_re,  //  Output Data (Real)
    output  reg [WIDTH-1:0] do_im   //  Output Data (Imag)
);

//----------------------------------------------------------------------
//  Internal Regs and Nets
//----------------------------------------------------------------------
reg             bf_en;      //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] x0_re;      //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] x0_im;      //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] x1_re;      //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] x1_im;      //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] x2_re;
wire[WIDTH-1:0] x2_im;
wire[WIDTH-1:0] y0_re;      //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] y0_im;      //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] y1_re;      //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] y1_im;      //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] y2_re;
wire[WIDTH-1:0] y2_im;
wire[WIDTH-1:0] db_di_re;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_di_re2;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im2;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_di_re3;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im3;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re;   //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db_do_im;   //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re2;   //  Data from DelayBuffer2 (Real)
wire[WIDTH-1:0] db_do_im2;   //  Data from DelayBuffer2 (Imag)
wire[WIDTH-1:0] db_do_re3;   //  Data from DelayBuffer2 (Real)
wire[WIDTH-1:0] db_do_im3;   //  Data from DelayBuffer2 (Imag)
wire[WIDTH-1:0] bf_sp_re;   //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf_sp_im;   //  Single-Path Data Output (Imag)
reg             bf_sp_en;   //  Single-Path Data Enable
reg counter;
reg delay;
//----------------------------------------------------------------------
//  Butterfly Add/Sub
//----------------------------------------------------------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf_en <= 1'b0;
        counter <= 2'b00;
    end else begin
        counter <= di_en && on ? counter + 1 :2'b00;
        bf_en <= di_en && on && counter==1 ? ~bf_en : 1'b0;
    end
end


//  Set unknown value x for verification
assign  x0_re = bf_en ? db_do_re : {WIDTH{1'bx}};
assign  x0_im = bf_en ? db_do_im : {WIDTH{1'bx}};
assign  x1_re = bf_en ? db_do_re2 : {WIDTH{1'bx}};
assign  x1_im = bf_en ? db_do_im2 : {WIDTH{1'bx}};
assign  x2_re = bf_en ? di_re : {WIDTH{1'bx}};
assign  x2_im = bf_en ? di_im : {WIDTH{1'bx}};

Butterfly3 #(.WIDTH(WIDTH)) BF (
    .x0_re  (x0_re  ),  //  i
    .x0_im  (x0_im  ),  //  i
    .x1_re  (x1_re  ),  //  i
    .x1_im  (x1_im  ),  //  i
    .x2_re  (x2_re  ),  //  i
    .x2_im  (x2_im  ),  //  i
    .y0_re  (y0_re  ),  //  o
    .y0_im  (y0_im  ),  //  o
    .y1_re  (y1_re  ),  //  o
    .y1_im  (y1_im  ),   //  o
    .y2_re  (y2_re  ),  //  o
    .y2_im  (y2_im  )   //  o
);

DelayBuffer #(.DEPTH(2),.WIDTH(WIDTH)) DB1 (
    .clk     (clk        ),  //  i
    .in_re   (db_di_re   ),  //  i
    .in_im   (db_di_im   ),  //  i
    .out_re  (db_do_re   ),  //  o
    .out_im  (db_do_im   )   //  o
);
DelayBuffer #(.DEPTH(1),.WIDTH(WIDTH)) DB2 (
    .clk     (clk         ),  //  i
    .in_re   (db_di_re2   ),  //  i
    .in_im   (db_di_im2   ),  //  i
    .out_re  (db_do_re2   ),  //  o
    .out_im  (db_do_im2   )   //  o
);

assign  db_di_re2 = bf_en ? y1_re : counter==1 ? di_re : 0;
assign  db_di_im2 = bf_en ? y1_im : counter==1 ? di_im : 0;
assign  db_di_re = !bf_en && counter==0 ? di_re : bf_en ? y2_re : 0 ;
assign  db_di_im = !bf_en && counter==0 ? di_im : bf_en ? y2_im : 0 ;
assign  bf_sp_re = bf_en ? y0_re : counter==0 ? db_do_re : counter==1 ? db_do_re2 : 0;
assign  bf_sp_im = bf_en ? y0_im : counter==0 ? db_do_im : counter==1 ? db_do_im2 : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf_sp_en <= 1'b0;
        do_en <= 1'b0;
        delay <=0;
    end else begin
        bf_sp_en <= di_en;
        delay <= bf_sp_en;
        do_en <= delay;
    end
end

always @(posedge clk) begin
    do_re <= bf_sp_re;
    do_im <= bf_sp_im;
end

endmodule