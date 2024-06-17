module SdfUnit27 #(
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

localparam  Stages=6'd6;  

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
reg [5:0] counter ;

//  2nd Butterfly
reg [Stages-1:0] di_count2;  //  Input Data Count
reg [5:0]             counter2;
wire             bf2_enable;     //  Butterfly Add/Sub Enable
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
wire             bf2_start;  //  Single-Path Output Trigger
wire            bf2_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf2_do_re;  //  2nd Butterfly Output Data (Real)
reg [WIDTH-1:0] bf2_do_im;  //  2nd Butterfly Output Data (Imag)
reg             bf2_do_en;  //  2nd Butterfly Output Data Enable

// 3rd Butterfly 
reg [Stages-1:0] di_count3;  //  Input Data Count
reg             counter3;
wire             bf3_enable;     //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] bf3_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf3_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf3_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf3_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf3_x2_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf3_x2_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf3_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf3_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf3_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf3_y1_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] bf3_y2_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf3_y2_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] db3_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db3_di_im;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db3_di_re2;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db3_di_im2;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db3_di_re3;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db3_di_im3;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db3_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db3_do_im;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db3_do_re2;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db3_do_im2;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db3_do_re3;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db3_do_im3;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] bf3_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf3_sp_im;  //  Single-Path Data Output (Imag)
reg             bf3_sp_en;  //  Single-Path Data Enable
reg  [Stages-1:0] bf3_count; //  Single-Path Data Count
wire             bf3_start;  //  Single-Path Output Trigger
wire            bf3_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf3_do_re;  //  2nd Butterfly Output Data (Real)
reg [WIDTH-1:0] bf3_do_im;  //  2nd Butterfly Output Data (Imag)
reg             bf3_do_en;  //  2nd Butterfly Output Data Enable

////Multiplication 1
wire [WIDTH-1:0] temp1_re;
wire [WIDTH-1:0] temp1_im;
wire [WIDTH-1:0] bf1_boundary_re;
wire [WIDTH-1:0] bf1_boundary_im;
wire [4:0] tw_addr;
wire [WIDTH-1:0] tw_re;
wire [WIDTH-1:0] tw_im;
wire [WIDTH-1:0] stage1_re , stage1_im;

///// Multiplication 2
wire [WIDTH-1:0] temp2_re;
wire [WIDTH-1:0] temp2_im;
wire [WIDTH-1:0] bf2_boundary_re;
wire [WIDTH-1:0] bf2_boundary_im;
wire [4:0] tw_addr2;
wire [WIDTH-1:0] tw_re2;
wire [WIDTH-1:0] tw_im2;
wire [WIDTH-1:0] stage2_re , stage2_im;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        di_count <= {Stages{1'b0}};
        counter <=0;
    end else begin
        di_count <= (di_en && on) ? (di_count + 1'b1) : {Stages{1'b0}};
        counter <= !bf1_enable ? (counter + 1'b1) : 0;
    end    
end
assign bf1_enable = (di_count > 17 && di_count < 27);

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

DelayBuffer #(.DEPTH(18),.WIDTH(WIDTH)) DB (
    .clk     (clk        ),  //  i
    .in_re   (db_di_re   ),  //  i
    .in_im   (db_di_im   ),  //  i
    .out_re  (db_do_re   ),  //  o
    .out_im  (db_do_im   )   //  o
);
DelayBuffer #(.DEPTH(9),.WIDTH(WIDTH)) DB1 (
    .clk     (clk         ),  //  i
    .in_re   (db_di_re2   ),  //  i
    .in_im   (db_di_im2   ),  //  i
    .out_re  (db_do_re2   ),  //  o
    .out_im  (db_do_im2   )   //  o
);

assign  db_di_re2 = bf1_enable ? bf1_y1_re : di_count<18 && di_count>8 ? di_re : 0;
assign  db_di_im2 = bf1_enable ? bf1_y1_im : di_count<18 && di_count>8 ? di_im : 0;
assign  db_di_re = bf1_enable ? bf1_y2_re : di_count<9 ? di_re :  0;
assign  db_di_im = bf1_enable ? bf1_y2_im : di_count<9 ? di_im :  0;
assign  bf1_sp_re = bf1_enable ? bf1_y0_re : counter<9 ? db_do_re2 : counter<18 ? db_do_re : 0;
assign  bf1_sp_im = bf1_enable ? bf1_y0_im : counter<9 ? db_do_im2 : counter<18 ? db_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf1_sp_en <= 1'b0;
        bf1_count <= {Stages{1'b0}};
    end else begin
        bf1_sp_en <= bf1_start ? 1'b1 : bf1_end ? 1'b0 : bf1_sp_en;
        bf1_count <= bf1_sp_en ? (bf1_count + 1'b1) : {Stages{1'b0}};
    end
end

assign  bf1_start = (di_count == 18);
assign  bf1_end = (bf1_count == 26); //adjust this and above

always @(posedge clk) begin
    bf1_do_re <= bf1_sp_re;
    bf1_do_im <= bf1_sp_im;
end

assign temp1_re = bf1_sp_en ? bf1_do_re : 0;
assign temp1_im = bf1_sp_en ? bf1_do_im : 0;

assign tw_addr = bf1_sp_en ? 
    (bf1_count == 6'd10 ? 7'd1 : 
    (bf1_count == 6'd19 ? 7'd2 : 
    (bf1_count == 6'd11 ? 7'd2 : 
    (bf1_count == 6'd20 ? 7'd4 : 
    (bf1_count == 6'd12 ? 7'd3 : 
    (bf1_count == 6'd21 ? 7'd6 : 
    (bf1_count == 6'd13 ? 7'd4 : 
    (bf1_count == 6'd22 ? 7'd8 : 
    (bf1_count == 6'd14 ? 7'd5 : 
    (bf1_count == 6'd23 ? 7'd10 : 
    (bf1_count == 6'd15 ? 7'd6 : 
    (bf1_count == 6'd24 ? 7'd12 : 
    (bf1_count == 6'd16 ? 7'd7 : 
    (bf1_count == 6'd25 ? 7'd14 : 
    (bf1_count == 6'd17 ? 7'd8 : 
    (bf1_count == 6'd26 ? 7'd16 : 7'd0)))))))))))))))) : 7'd0;




Twiddle27 TW (
        .clk    (clk    ),  //  i
        .addr   (tw_addr),  //  i
        .tw_re  (tw_re  ),  //  o
        .tw_im  (tw_im  )   //  o
    );
Multiply #(.WIDTH(WIDTH)) U1(
        .a_re(temp1_re),
        .a_im(temp1_im),
        .b_re(tw_re),
        .b_im(tw_im),
        .m_re(bf1_boundary_re),
        .m_im(bf1_boundary_im)
    );

assign stage1_re = bf1_boundary_re;
assign stage1_im = bf1_boundary_im;
//----------------------------------------------------------------------
//  2nd Butterfly
//----------------------------------------------------------------------
always @(posedge clk) begin
    if (rst) begin
        di_count2 <= {Stages{1'b0}};
        counter2 <=0;
    end else begin
    di_count2 <= bf1_sp_en ? di_count2==8 ? 0 : (di_count2 + 1'b1) : 0;
    counter2 <= !bf2_enable ? (counter2 + 1'b1) : 0;
    end
end

assign  bf2_enable = (bf1_count == 6 || bf1_count == 7 || bf1_count == 8 || bf1_count == 15 || bf1_count == 16 || bf1_count == 17 || bf1_count == 24 || bf1_count == 25 || bf1_count == 26) ? 1'b1 : 1'b0;
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
    .y2_im  (bf2_y2_im  )   //  o   
);

DelayBuffer #(.DEPTH(6),.WIDTH(WIDTH)) DB3 (
    .clk     (clk        ),  //  i
    .in_re   (db2_di_re   ),  //  i
    .in_im   (db2_di_im   ),  //  i
    .out_re  (db2_do_re   ),  //  o
    .out_im  (db2_do_im   )   //  o
);
DelayBuffer #(.DEPTH(3),.WIDTH(WIDTH)) DB4 (
    .clk     (clk         ),  //  i
    .in_re   (db2_di_re2   ),  //  i
    .in_im   (db2_di_im2   ),  //  i
    .out_re  (db2_do_re2   ),  //  o
    .out_im  (db2_do_im2   )   //  o
);


assign  db2_di_re2 = bf2_enable ? bf2_y1_re : (di_count2<6 && di_count2>2) ? stage1_re : 0;
assign  db2_di_im2 = bf2_enable ? bf2_y1_im : (di_count2<6 && di_count2>2) ? stage1_im : 0;
assign  db2_di_re = bf2_enable ? bf2_y2_re : di_count2<3 ? stage1_re :  0;
assign  db2_di_im = bf2_enable ? bf2_y2_im : di_count2<3 ? stage1_im :  0;
assign  bf2_sp_re = bf2_enable ? bf2_y0_re : counter2<3 ? db2_do_re2 : counter2<6 ? db2_do_re : 0;
assign  bf2_sp_im = bf2_enable ? bf2_y0_im : counter2<3 ? db2_do_im2 : counter2<6 ? db2_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf2_sp_en <= 1'b0;
        bf2_count <= {Stages{1'b0}};
    end else begin
        bf2_sp_en <= bf2_start ? 1'b1 : bf2_end ? 1'b0 : bf2_sp_en;
        bf2_count <= bf2_sp_en ? (bf2_count + 1'b1) : 0;
    end
end

assign  bf2_start = (di_count2 == 6) ;
assign  bf2_end = (bf2_count==26); //adjust this and above

always @(posedge clk) begin
    bf2_do_re <= bf2_sp_re;
    bf2_do_im <= bf2_sp_im;
end

assign temp2_re = bf2_sp_en ? bf2_do_re : 0;
assign temp2_im = bf2_sp_en ? bf2_do_im : 0;

assign tw_addr2 = bf2_sp_en ? (bf2_count == 4 || bf2_count == 13 || bf2_count == 22) ? 6'd3 : (bf2_count== 7 || bf2_count == 16 || bf2_count == 25) ? 6'd6 : (bf2_count == 5 || bf2_count == 14 || bf2_count == 23) ? 6'd6 : (bf2_count == 8 || bf2_count == 17 || bf2_count == 26) ? 6'd12 : 0 : 0;



Twiddle27 TW1 (
        .clk    (clk    ),  //  i
        .addr   (tw_addr2),  //  i
        .tw_re  (tw_re2  ),  //  o
        .tw_im  (tw_im2  )   //  o
    );
Multiply #(.WIDTH(WIDTH)) U2(
        .a_re(temp2_re),
        .a_im(temp2_im),
        .b_re(tw_re2),
        .b_im(tw_im2),
        .m_re(bf2_boundary_re),
        .m_im(bf2_boundary_im)
    );

assign stage2_re = bf2_boundary_re ;
assign stage2_im =  bf2_boundary_im ;
//----------------------------------------------------------------------
//  3rd Butterfly
//----------------------------------------------------------------------
always @(posedge clk) begin
    
    di_count3 <= bf2_sp_en ? di_count3==2 ?0: (di_count3 + 1'b1) : 0;
    counter3 <= !bf3_enable ? (counter3 + 1'b1) : 0;
end

assign bf3_enable = (bf2_count == 2 || bf2_count == 5 || bf2_count == 8 || bf2_count == 11 || bf2_count == 14 || bf2_count == 17 || bf2_count == 20 || bf2_count == 23 || bf2_count == 26) ? 1'b1 : 1'b0;
//  Set unknown value x for verification
assign  bf3_x0_re = bf3_enable ? db3_do_re : {WIDTH{1'bx}};
assign  bf3_x0_im = bf3_enable ? db3_do_im : {WIDTH{1'bx}};
assign  bf3_x1_re = bf3_enable ? db3_do_re2 : {WIDTH{1'bx}};
assign  bf3_x1_im = bf3_enable ? db3_do_im2 : {WIDTH{1'bx}};
assign  bf3_x2_re = bf3_enable ? stage2_re : {WIDTH{1'bx}};
assign  bf3_x2_im = bf3_enable ? stage2_im : {WIDTH{1'bx}};


Butterfly3 #(.WIDTH(WIDTH)) BF2 (
    .x0_re  (bf3_x0_re  ),  //  i
    .x0_im  (bf3_x0_im  ),  //  i
    .x1_re  (bf3_x1_re  ),  //  i
    .x1_im  (bf3_x1_im  ),  //  i
    .x2_re  (bf3_x2_re  ),  //  i
    .x2_im  (bf3_x2_im  ),  //  i
    .y0_re  (bf3_y0_re  ),  //  o
    .y0_im  (bf3_y0_im  ),  //  o
    .y1_re  (bf3_y1_re  ),  //  o
    .y1_im  (bf3_y1_im  ),   //  o
    .y2_re  (bf3_y2_re  ),  //  o
    .y2_im  (bf3_y2_im  )  //  o
    
);

DelayBuffer #(.DEPTH(2),.WIDTH(WIDTH)) DB6 (
    .clk     (clk        ),  //  i
    .in_re   (db3_di_re   ),  //  i
    .in_im   (db3_di_im   ),  //  i
    .out_re  (db3_do_re   ),  //  o
    .out_im  (db3_do_im   )   //  o
);
DelayBuffer #(.DEPTH(1),.WIDTH(WIDTH)) DB7 (
    .clk     (clk         ),  //  i
    .in_re   (db3_di_re2   ),  //  i
    .in_im   (db3_di_im2   ),  //  i
    .out_re  (db3_do_re2   ),  //  o
    .out_im  (db3_do_im2   )   //  o
);

assign  db3_di_re = bf3_enable ? bf3_y2_re : (di_count3==0 || di_count3==3 || di_count3==6) ? stage2_re :  0;
assign  db3_di_im = bf3_enable ? bf3_y2_im : (di_count3==0 || di_count3==3 || di_count3==6) ? stage2_im :  0;
assign  db3_di_re2 = bf3_enable ? bf3_y1_re : (di_count3==1 || di_count3==4 || di_count3==7) ? stage2_re : 0;
assign  db3_di_im2 = bf3_enable ? bf3_y1_im : (di_count3==1 || di_count3==4 || di_count3==7) ? stage2_im : 0;
assign  bf3_sp_re = bf3_enable ? bf3_y0_re : counter3==0 ? db3_do_re2 : counter3==1 ? db3_do_re : 0;
assign  bf3_sp_im = bf3_enable ? bf3_y0_im : counter3==0 ? db3_do_im2 : counter3==1 ? db3_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf3_sp_en <= 1'b0;
        bf3_count <= {Stages{1'b0}};
    end else begin
        bf3_sp_en <= bf3_start ? 1'b1 : bf3_end ? 1'b0 : bf3_sp_en;
        bf3_count <= bf3_sp_en ? (bf3_count + 1'b1) : {Stages{1'b0}};
    end
end


assign bf3_start = (di_count3 == 2);

assign  bf3_end = (bf3_count == 26);

always @(posedge clk) begin
    bf3_do_re <= bf3_sp_re;
    bf3_do_im <= bf3_sp_im;
end


assign  do_en = bf3_sp_en ;
assign  do_re = bf3_do_re ;
assign  do_im = bf3_do_im ;

endmodule