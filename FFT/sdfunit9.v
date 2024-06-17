module SdfUnit9 #(
    parameter WIDTH=16
    )(
    input               clk,  //  Master Clock
    input               rst,  //  Active High Asynchronous Reset
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    input               on,
    output              do_en,  //  Output Data Enable
    output  [WIDTH-1:0] do_re,  //  Output Data (Real)
    output  [WIDTH-1:0] do_im   //  Output Data (Imag)

);

localparam  Stages=4'd4;  

// 1st Butterfly
reg [Stages-1:0] di_count;  //  Input Data Count
wire            bf1_enable; //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] bf1_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_x2_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x2_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf1_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y1_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] bf1_y2_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y2_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] db_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im;  //  Data to DelayBuffer (Imag)\
wire[WIDTH-1:0] db_di_re2;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im2;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_di_re3;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db_di_im3;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db_do_im;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re2;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db_do_im2;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db_do_re3;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db_do_im3;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] bf1_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf1_sp_im;  //  Single-Path Data Output (Imag)
reg             bf1_sp_en;  //  Single-Path Data Enable
reg [Stages-1:0] bf1_count;  //  Single-Path Data Count
wire            bf1_start;  //  Single-Path Output Trigger
wire            bf1_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf1_do_re;  //  1st Butterfly Output Data (Real)
reg [WIDTH-1:0] bf1_do_im;  //  1st Butterfly Output Data (Imag)
reg [3:0] counter ;

//  2nd Butterfly
reg [Stages-1:0] di_count2;  //  Input Data Count
reg             counter2;
reg             bf2_enable;     //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] bf2_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_x2_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x2_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf2_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y1_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] bf2_y2_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y2_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] db2_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db2_di_im;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db2_di_re2;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db2_di_im2;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db2_di_re3;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db2_di_im3;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db2_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db2_do_im;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db2_do_re2;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db2_do_im2;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db2_do_re3;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db2_do_im3;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] bf2_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf2_sp_im;  //  Single-Path Data Output (Imag)
reg             bf2_sp_en;  //  Single-Path Data Enable
reg  [Stages-1:0] bf2_count; //  Single-Path Data Count
reg             bf2_start;  //  Single-Path Output Trigger
wire            bf2_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf2_do_re;  //  2nd Butterfly Output Data (Real)
reg [WIDTH-1:0] bf2_do_im;  //  2nd Butterfly Output Data (Imag)
reg             bf2_do_en;  //  2nd Butterfly Output Data Enable

////Multiplication
wire [WIDTH-1:0] temp1_re;
wire [WIDTH-1:0] temp1_im;
wire [WIDTH-1:0] bf1_boundary_re;
wire [WIDTH-1:0] bf1_boundary_im;
wire [3:0] tw_addr;
wire [WIDTH-1:0] tw_re;
wire [WIDTH-1:0] tw_im;
wire [WIDTH-1:0] stage1_re , stage1_im;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        di_count <= {Stages{1'b0}};
        counter <=0;
    end else begin
        di_count <= (di_en && on) ? (di_count + 1'b1) : {Stages{1'b0}};
        counter <= !bf1_enable ? (counter + 1'b1) : 0;
    end    
end
assign  bf1_enable = di_count == 6 || di_count == 7 || di_count == 8; 

assign  bf1_x0_re = bf1_enable ? db_do_re : {WIDTH{1'bx}};
assign  bf1_x0_im = bf1_enable ? db_do_im : {WIDTH{1'bx}};
assign  bf1_x1_re = bf1_enable ? db_do_re2 : {WIDTH{1'bx}};
assign  bf1_x1_im = bf1_enable ? db_do_im2 : {WIDTH{1'bx}};
assign  bf1_x2_re = bf1_enable ? di_re : {WIDTH{1'bx}};
assign  bf1_x2_im = bf1_enable ? di_im : {WIDTH{1'bx}};

Butterfly3 #(.WIDTH(WIDTH)) BF (
    .x0_re  (bf1_x0_re  ),  //  i
    .x0_im  (bf1_x0_im  ),  //  i
    .x1_re  (bf1_x1_re  ),  //  i
    .x1_im  (bf1_x1_im  ),  //  i
    .x2_re  (bf1_x2_re  ),  //  i
    .x2_im  (bf1_x2_im  ),  //  i
    .y0_re  (bf1_y0_re  ),  //  o
    .y0_im  (bf1_y0_im  ),  //  o
    .y1_re  (bf1_y1_re  ),  //  o
    .y1_im  (bf1_y1_im  ),   //  o
    .y2_re  (bf1_y2_re  ),  //  o
    .y2_im  (bf1_y2_im  )   //  o   
);

DelayBuffer #(.DEPTH(6),.WIDTH(WIDTH)) DB (
    .clk     (clk        ),  //  i
    .in_re   (db_di_re   ),  //  i
    .in_im   (db_di_im   ),  //  i
    .out_re  (db_do_re   ),  //  o
    .out_im  (db_do_im   )   //  o
);
DelayBuffer #(.DEPTH(3),.WIDTH(WIDTH)) DB1 (
    .clk     (clk         ),  //  i
    .in_re   (db_di_re2   ),  //  i
    .in_im   (db_di_im2   ),  //  i
    .out_re  (db_do_re2   ),  //  o
    .out_im  (db_do_im2   )   //  o
);


assign  db_di_re2 = bf1_enable ? bf1_y1_re : di_count<6 && di_count>2 ? di_re : 0;
assign  db_di_im2 = bf1_enable ? bf1_y1_im : di_count<6 && di_count>2 ? di_im : 0;
assign  db_di_re =  bf1_enable ? bf1_y2_re : di_count<3 ? di_re :  0;
assign  db_di_im =  bf1_enable ? bf1_y2_im : di_count<3 ? di_im :  0;
assign  bf1_sp_re = bf1_enable ? bf1_y0_re : counter<3 ? db_do_re2 : counter<6 ? db_do_re : 0;
assign  bf1_sp_im = bf1_enable ? bf1_y0_im : counter<3 ? db_do_im2 : counter<6 ? db_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf1_sp_en <= 1'b0;
        bf1_count <= {Stages{1'b0}};
    end else begin
        bf1_sp_en <= bf1_start ? 1'b1 : bf1_end ? 1'b0 : bf1_sp_en;
        bf1_count <= bf1_sp_en ? (bf1_count + 1'b1) : {Stages{1'b0}};
    end
end

assign  bf1_start = (di_count == 6);
assign  bf1_end = (bf1_count == 8); //adjust this and above

always @(posedge clk) begin
    bf1_do_re <= bf1_sp_re;
    bf1_do_im <= bf1_sp_im;
end

assign temp1_re = bf1_sp_en && (bf1_count == 4 || bf1_count == 5 || bf1_count == 7 || bf1_count == 8) ? bf1_do_re : 0;
assign temp1_im = bf1_sp_en && (bf1_count == 4 || bf1_count == 5 || bf1_count == 7 || bf1_count == 8) ? bf1_do_im : 0;

assign tw_addr = bf1_sp_en ? bf1_count == 4 ? 4'd1 : (bf1_count == 5 || bf1_count == 7) ? 4'd2 : bf1_count == 8 ? 4'd4 : 4'b0 : 4'b0;


Twiddle9 TW (
        .clk    (clk    ),  //  i
        .addr   (tw_addr),  //  i
        .tw_re  (tw_re  ),  //  o
        .tw_im  (tw_im  )   //  o
    );
Multiply #(.WIDTH(WIDTH)) U4(
        .a_re(temp1_re),
        .a_im(temp1_im),
        .b_re(tw_re),
        .b_im(tw_im),
        .m_re(bf1_boundary_re),
        .m_im(bf1_boundary_im)
    );

assign stage1_re = bf1_sp_en && (bf1_count == 4 || bf1_count == 5 || bf1_count == 7 || bf1_count == 8) ? bf1_boundary_re : bf1_do_re;
assign stage1_im = bf1_sp_en && (bf1_count == 4 || bf1_count == 5 || bf1_count == 7 || bf1_count == 8) ? bf1_boundary_im : bf1_do_im;
//----------------------------------------------------------------------
//  2nd Butterfly
//----------------------------------------------------------------------
always @(posedge clk) begin
    bf2_enable <= bf1_count==1 || bf1_count==4 || bf1_count==7;
    di_count2 <= bf1_sp_en ? (di_count2 + 1'b1) : 0;
    counter2 <= !bf2_enable ? (counter2 + 1'b1) : 0;
end

//  Set unknown value x for verification
assign  bf2_x0_re = bf2_enable ? db2_do_re : {WIDTH{1'bx}};
assign  bf2_x0_im = bf2_enable ? db2_do_im : {WIDTH{1'bx}};
assign  bf2_x1_re = bf2_enable ? db2_do_re2 : {WIDTH{1'bx}};
assign  bf2_x1_im = bf2_enable ? db2_do_im2 : {WIDTH{1'bx}};
assign  bf2_x2_re = bf2_enable ? stage1_re : {WIDTH{1'bx}};
assign  bf2_x2_im = bf2_enable ? stage1_im : {WIDTH{1'bx}};


Butterfly3 #(.WIDTH(WIDTH)) BF1 (
    .x0_re  (bf2_x0_re  ),  //  i
    .x0_im  (bf2_x0_im  ),  //  i
    .x1_re  (bf2_x1_re  ),  //  i
    .x1_im  (bf2_x1_im  ),  //  i
    .x2_re  (bf2_x2_re  ),  //  i
    .x2_im  (bf2_x2_im  ),  //  i
    .y0_re  (bf2_y0_re  ),  //  o
    .y0_im  (bf2_y0_im  ),  //  o
    .y1_re  (bf2_y1_re  ),  //  o
    .y1_im  (bf2_y1_im  ),   //  o
    .y2_re  (bf2_y2_re  ),  //  o
    .y2_im  (bf2_y2_im  )  //  o
    
);

DelayBuffer #(.DEPTH(2),.WIDTH(WIDTH)) DB3 (
    .clk     (clk        ),  //  i
    .in_re   (db2_di_re   ),  //  i
    .in_im   (db2_di_im   ),  //  i
    .out_re  (db2_do_re   ),  //  o
    .out_im  (db2_do_im   )   //  o
);
DelayBuffer #(.DEPTH(1),.WIDTH(WIDTH)) DB4 (
    .clk     (clk         ),  //  i
    .in_re   (db2_di_re2   ),  //  i
    .in_im   (db2_di_im2   ),  //  i
    .out_re  (db2_do_re2   ),  //  o
    .out_im  (db2_do_im2   )   //  o
);


assign  db2_di_re =  bf2_enable ? bf2_y2_re : (di_count2==0 || di_count2==3 || di_count2==6) ? stage1_re :  0;
assign  db2_di_im =  bf2_enable ? bf2_y2_im : (di_count2==0 || di_count2==3 || di_count2==6) ? stage1_im :  0;
assign  db2_di_re2 = bf2_enable ? bf2_y1_re : (di_count2==1 || di_count2==4 || di_count2==7) ? stage1_re :  0;
assign  db2_di_im2 = bf2_enable ? bf2_y1_im : (di_count2==1 || di_count2==4 || di_count2==7) ? stage1_im :  0;
assign  bf2_sp_re = bf2_enable ? bf2_y0_re : counter2==0 ? db2_do_re2 : counter2==1 ? db2_do_re : 0;
assign  bf2_sp_im = bf2_enable ? bf2_y0_im : counter2==0 ? db2_do_im2 : counter2==1 ? db2_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf2_sp_en <= 1'b0;
        bf2_count <= {Stages{1'b0}};
    end else begin
        bf2_sp_en <= bf2_start ? 1'b1 : bf2_end ? 1'b0 : bf2_sp_en;
        bf2_count <= bf2_sp_en ? (bf2_count + 1'b1) : {Stages{1'b0}};
    end
end

always @(posedge clk) begin
    bf2_start <= (bf1_count == 1) & bf1_sp_en;
end
assign  bf2_end = (bf2_count == 8);

always @(posedge clk) begin
    bf2_do_re <= bf2_sp_re;
    bf2_do_im <= bf2_sp_im;
end


assign  do_en = bf2_sp_en ;
assign  do_re = bf2_do_re ;
assign  do_im = bf2_do_im ;

endmodule