module SdfUnit5 #(
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
wire[WIDTH-1:0] x3_re;
wire[WIDTH-1:0] x3_im;
wire[WIDTH-1:0] x4_re;
wire[WIDTH-1:0] x4_im;
wire[WIDTH-1:0] y0_re;      //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] y0_im;      //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] y1_re;      //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] y1_im;      //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] y2_re;
wire[WIDTH-1:0] y2_im;
wire[WIDTH-1:0] y3_re;
wire[WIDTH-1:0] y3_im;
wire[WIDTH-1:0] y4_re;
wire[WIDTH-1:0] y4_im;
wire[WIDTH-1:0] db_di_re;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_di_re2;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im2;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_di_re3;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im3;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_di_re4;   //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im4;   //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re;   //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db_do_im;   //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re2;   //  Data from DelayBuffer2 (Real)
wire[WIDTH-1:0] db_do_im2;   //  Data from DelayBuffer2 (Imag)
wire[WIDTH-1:0] db_do_re3;   //  Data from DelayBuffer2 (Real)
wire[WIDTH-1:0] db_do_im3;   //  Data from DelayBuffer2 (Imag)
wire[WIDTH-1:0] db_do_re4;   //  Data from DelayBuffer2 (Real)
wire[WIDTH-1:0] db_do_im4;   //  Data from DelayBuffer2 (Imag)
wire[WIDTH-1:0] bf_sp_re;   //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf_sp_im;   //  Single-Path Data Output (Imag)
reg             bf_sp_en;   //  Single-Path Data Enable
reg [2:0] counter;
reg [2:0] counter2;
wire bf_start , bf_end;
//----------------------------------------------------------------------
//  Butterfly Add/Sub
//----------------------------------------------------------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf_en <= 1'b0;
        counter <= 3'b00;
        counter2 <= 3'b0;
    end else begin
        counter <= di_en && on ? counter == 3'd5 ? 3'b0 : counter + 1 :3'b00;
        bf_en <= di_en && on && counter==4'd3 ? ~bf_en : 1'b0;
        counter2 <= !bf_en ? counter2 +  1 : 3'b0 ;
    end
end


//  Set unknown value x for verification
assign  x0_re = bf_en ? db_do_re : {WIDTH{1'bx}};
assign  x0_im = bf_en ? db_do_im : {WIDTH{1'bx}};
assign  x1_re = bf_en ? db_do_re2 : {WIDTH{1'bx}};
assign  x1_im = bf_en ? db_do_im2 : {WIDTH{1'bx}};
assign  x2_re = bf_en ? db_do_re3 : {WIDTH{1'bx}};
assign  x2_im = bf_en ? db_do_im3 : {WIDTH{1'bx}};
assign  x3_re = bf_en ? db_do_re4 : {WIDTH{1'bx}};
assign  x3_im = bf_en ? db_do_im4 : {WIDTH{1'bx}};
assign  x4_re = bf_en ? di_re : {WIDTH{1'bx}};
assign  x4_im = bf_en ? di_im : {WIDTH{1'bx}};

Butterfly5 #(.WIDTH(WIDTH)) BF (
    .x0_re  (x0_re  ),  //  i
    .x0_im  (x0_im  ),  //  i
    .x1_re  (x1_re  ),  //  i
    .x1_im  (x1_im  ),  //  i
    .x2_re  (x2_re  ),  //  i
    .x2_im  (x2_im  ),  //  i
    .x3_re  (x3_re  ),  //  i
    .x3_im  (x3_im  ),  //  i
    .x4_re  (x4_re  ),  //  i
    .x4_im  (x4_im  ),  //  i
    .y0_re  (y0_re  ),  //  o
    .y0_im  (y0_im  ),  //  o
    .y1_re  (y1_re  ),  //  o
    .y1_im  (y1_im  ),   //  o
    .y2_re  (y2_re  ),  //  o
    .y2_im  (y2_im  ),   //  o
    .y3_re  (y3_re  ),  //  o
    .y3_im  (y3_im  ),   //  o
    .y4_re  (y4_re  ),  //  o
    .y4_im  (y4_im  )   //  o
);

DelayBuffer #(.DEPTH(4),.WIDTH(WIDTH)) DB1 (
    .clk     (clk        ),  //  i
    .in_re   (db_di_re   ),  //  i
    .in_im   (db_di_im   ),  //  i
    .out_re  (db_do_re   ),  //  o
    .out_im  (db_do_im   )   //  o
);
DelayBuffer #(.DEPTH(3),.WIDTH(WIDTH)) DB2 (
    .clk     (clk         ),  //  i
    .in_re   (db_di_re2   ),  //  i
    .in_im   (db_di_im2   ),  //  i
    .out_re  (db_do_re2   ),  //  o
    .out_im  (db_do_im2   )   //  o
);
DelayBuffer #(.DEPTH(2),.WIDTH(WIDTH)) DB3 (
    .clk     (clk        ),  //  i
    .in_re   (db_di_re3   ),  //  i
    .in_im   (db_di_im3   ),  //  i
    .out_re  (db_do_re3   ),  //  o
    .out_im  (db_do_im3   )   //  o
);
DelayBuffer #(.DEPTH(1),.WIDTH(WIDTH)) DB4 (
    .clk     (clk         ),  //  i
    .in_re   (db_di_re4   ),  //  i
    .in_im   (db_di_im4   ),  //  i
    .out_re  (db_do_re4   ),  //  o
    .out_im  (db_do_im4   )   //  o
);


assign  db_di_re = bf_en ? y4_re : counter==0 ? di_re : 0;
assign  db_di_im = bf_en ? y4_im : counter==0 ? di_im : 0;
assign  db_di_re2 = bf_en ? y3_re : counter==1 ? di_re : 0;
assign  db_di_im2 = bf_en ? y3_im : counter==1 ? di_im : 0;
assign  db_di_re3 = bf_en ? y2_re : counter==2 ? di_re : 0;
assign  db_di_im3 = bf_en ? y2_im : counter==2 ? di_im : 0;
assign  db_di_re4 = bf_en ? y1_re : counter==3 ? di_re : 0;
assign  db_di_im4 = bf_en ? y1_im : counter==3 ? di_im : 0;
assign  bf_sp_re = bf_en ? y0_re : counter2==0 ? db_do_re4 : counter2==1 ? db_do_re3 : counter2==2 ? db_do_re2 : counter2==3 ? db_do_re : 0;
assign  bf_sp_im = bf_en ? y0_im : counter2==0 ? db_do_im4 : counter2==1 ? db_do_im3 : counter2==2 ? db_do_im2 : counter2==3 ? db_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf_sp_en <= 1'b0;
        do_en <= 1'b0;
    end else begin
        bf_sp_en <= bf_start ? 1'b1 : bf_end ? 1'b0 : bf_sp_en;
        do_en <= bf_sp_en;
    end
end
assign bf_start = counter == 3'd3;
assign bf_end = counter2 == 3'd3;

always @(posedge clk) begin
    do_re <= bf_sp_re;
    do_im <= bf_sp_im;
end

endmodule