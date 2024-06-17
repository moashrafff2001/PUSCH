module SdfUnit81 #(
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

localparam  Stages=7'd7;  
// 1st Butterfly
reg [Stages-1:0] di_count0;  //  Input Data Count
wire            bf0_enable; //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] bf0_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf0_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf0_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf0_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf0_x2_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf0_x2_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf0_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf0_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf0_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf0_y1_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] bf0_y2_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf0_y2_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] db0_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db0_di_im;  //  Data to DelayBuffer (Imag)\
wire[WIDTH-1:0] db0_di_re2;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db0_di_im2;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db0_di_re3;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db0_di_im3;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db0_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db0_do_im;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db0_do_re2;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db0_do_im2;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] db0_do_re3;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db0_do_im3;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] bf0_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf0_sp_im;  //  Single-Path Data Output (Imag)
reg             bf0_sp_en;  //  Single-Path Data Enable
reg [Stages-1:0] bf0_count;  //  Single-Path Data Count
wire            bf0_start;  //  Single-Path Output Trigger
wire            bf0_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf0_do_re;  //  1st Butterfly Output Data (Real)
reg [WIDTH-1:0] bf0_do_im;  //  1st Butterfly Output Data (Imag)
reg [5:0] counter0 ;
// 2nd Butterfly
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

//  3rd Butterfly
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

// 4th Butterfly 
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

////Multiplication 0
wire [WIDTH-1:0] temp0_re;
wire [WIDTH-1:0] temp0_im;
wire [WIDTH-1:0] bf0_boundary_re;
wire [WIDTH-1:0] bf0_boundary_im;
wire [6:0] tw_addr0;
wire [WIDTH-1:0] tw_re0;
wire [WIDTH-1:0] tw_im0;
wire [WIDTH-1:0] stage0_re , stage0_im;

////Multiplication 1
wire [WIDTH-1:0] temp1_re;
wire [WIDTH-1:0] temp1_im;
wire [WIDTH-1:0] bf1_boundary_re;
wire [WIDTH-1:0] bf1_boundary_im;
wire [6:0] tw_addr;
wire [WIDTH-1:0] tw_re;
wire [WIDTH-1:0] tw_im;
wire [WIDTH-1:0] stage1_re , stage1_im;

///// Multiplication 2
wire [WIDTH-1:0] temp2_re;
wire [WIDTH-1:0] temp2_im;
wire [WIDTH-1:0] bf2_boundary_re;
wire [WIDTH-1:0] bf2_boundary_im;
wire [6:0] tw_addr2;
wire [WIDTH-1:0] tw_re2;
wire [WIDTH-1:0] tw_im2;
wire [WIDTH-1:0] stage2_re , stage2_im;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        di_count0 <= {Stages{1'b0}};
        counter0 <=0;
    end else begin
        di_count0 <= (di_en && on) ? (di_count0 + 1'b1) : {Stages{1'b0}};
        counter0 <= !bf0_enable ? (counter0 + 1'b1) : 0;
    end    
end
//----------------------------------------------------------------------
//  1st Butterfly
//----------------------------------------------------------------------
assign bf0_enable = (di_count0 > 53 && di_count0 < 81);

assign  bf0_x0_re = bf0_enable ? db0_do_re : {WIDTH{1'bx}};
assign  bf0_x0_im = bf0_enable ? db0_do_im : {WIDTH{1'bx}};
assign  bf0_x1_re = bf0_enable ? db0_do_re2 : {WIDTH{1'bx}};
assign  bf0_x1_im = bf0_enable ? db0_do_im2 : {WIDTH{1'bx}};
assign  bf0_x2_re = bf0_enable ? di_re : {WIDTH{1'bx}};
assign  bf0_x2_im = bf0_enable ? di_im : {WIDTH{1'bx}};

Butterfly3 #(.WIDTH(WIDTH)) BF (
    .x0_re  (bf0_x0_re  ),  //  i
    .x0_im  (bf0_x0_im  ),  //  i
    .x1_re  (bf0_x1_re  ),  //  i
    .x1_im  (bf0_x1_im  ),  //  i
    .x2_re  (bf0_x2_re  ),  //  i
    .x2_im  (bf0_x2_im  ),  //  i
    .y0_re  (bf0_y0_re  ),  //  o
    .y0_im  (bf0_y0_im  ),  //  o
    .y1_re  (bf0_y1_re  ),  //  o
    .y1_im  (bf0_y1_im  ),   //  o
    .y2_re  (bf0_y2_re  ),  //  o
    .y2_im  (bf0_y2_im  )   //  o   
);

DelayBuffer #(.DEPTH(54),.WIDTH(WIDTH)) DB (
    .clk     (clk        ),  //  i
    .in_re   (db0_di_re   ),  //  i
    .in_im   (db0_di_im   ),  //  i
    .out_re  (db0_do_re   ),  //  o
    .out_im  (db0_do_im   )   //  o
);
DelayBuffer #(.DEPTH(27),.WIDTH(WIDTH)) DB1 (
    .clk     (clk         ),  //  i
    .in_re   (db0_di_re2   ),  //  i
    .in_im   (db0_di_im2   ),  //  i
    .out_re  (db0_do_re2   ),  //  o
    .out_im  (db0_do_im2   )   //  o
);



assign  db0_di_re2 = bf0_enable ? bf0_y1_re : di_count0<54 && di_count0>26 ? di_re : 0;
assign  db0_di_im2 = bf0_enable ? bf0_y1_im : di_count0<54 && di_count0>26 ? di_im : 0;
assign  db0_di_re = bf0_enable ? bf0_y2_re : di_count0<27 ? di_re : 0 ;
assign  db0_di_im = bf0_enable ? bf0_y2_im : di_count0<27 ? di_im : 0;
assign  bf0_sp_re = bf0_enable ? bf0_y0_re : counter0<27 ? db0_do_re2 : counter0<54 ? db0_do_re : 0;
assign  bf0_sp_im = bf0_enable ? bf0_y0_im : counter0<27 ? db0_do_im2 : counter0<54 ? db0_do_im : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf0_sp_en <= 1'b0;
        bf0_count <= {Stages{1'b0}};
    end else begin
        bf0_sp_en <= bf0_start ? 1'b1 : bf0_end ? 1'b0 : bf0_sp_en;
        bf0_count <= bf0_sp_en ? (bf0_count + 1'b1) : {Stages{1'b0}};
    end
end

assign  bf0_start = (di_count0 == 54);
assign  bf0_end = (bf0_count == 80); 

always @(posedge clk) begin
    bf0_do_re <= bf0_sp_re;
    bf0_do_im <= bf0_sp_im;
end

assign temp0_re = bf0_sp_en ? bf0_do_re : 0;
assign temp0_im = bf0_sp_en ? bf0_do_im : 0;

assign tw_addr0 = bf0_sp_en ? 
    (bf0_count == 8'd27 ? 8'd0 : 
    (bf0_count == 8'd28 ? 8'd1 : 
    (bf0_count == 8'd29 ? 8'd2 : 
    (bf0_count == 8'd30 ? 8'd3 : 
    (bf0_count == 8'd31 ? 8'd4 : 
    (bf0_count == 8'd32 ? 8'd5 : 
    (bf0_count == 8'd33 ? 8'd6 : 
    (bf0_count == 8'd34 ? 8'd7 : 
    (bf0_count == 8'd35 ? 8'd8 : 
    (bf0_count == 8'd36 ? 8'd9 : 
    (bf0_count == 8'd37 ? 8'd10 : 
    (bf0_count == 8'd38 ? 8'd11 : 
    (bf0_count == 8'd39 ? 8'd12 : 
    (bf0_count == 8'd40 ? 8'd13 : 
    (bf0_count == 8'd41 ? 8'd14 : 
    (bf0_count == 8'd42 ? 8'd15 : 
    (bf0_count == 8'd43 ? 8'd16 : 
    (bf0_count == 8'd44 ? 8'd17 : 
    (bf0_count == 8'd45 ? 8'd18 : 
    (bf0_count == 8'd46 ? 8'd19 : 
    (bf0_count == 8'd47 ? 8'd20 : 
    (bf0_count == 8'd48 ? 8'd21 : 
    (bf0_count == 8'd49 ? 8'd22 : 
    (bf0_count == 8'd50 ? 8'd23 : 
    (bf0_count == 8'd51 ? 8'd24 : 
    (bf0_count == 8'd52 ? 8'd25 : 
    (bf0_count == 8'd53 ? 8'd26 : 
    (bf0_count == 8'd54 ? 8'd0 : 
    (bf0_count == 8'd55 ? 8'd2 : 
    (bf0_count == 8'd56 ? 8'd4 : 
    (bf0_count == 8'd57 ? 8'd6 : 
    (bf0_count == 8'd58 ? 8'd8 : 
    (bf0_count == 8'd59 ? 8'd10 : 
    (bf0_count == 8'd60 ? 8'd12 : 
    (bf0_count == 8'd61 ? 8'd14 : 
    (bf0_count == 8'd62 ? 8'd16 : 
    (bf0_count == 8'd63 ? 8'd18 : 
    (bf0_count == 8'd64 ? 8'd20 : 
    (bf0_count == 8'd65 ? 8'd22 : 
    (bf0_count == 8'd66 ? 8'd24 : 
    (bf0_count == 8'd67 ? 8'd26 : 
    (bf0_count == 8'd68 ? 8'd28 : 
    (bf0_count == 8'd69 ? 8'd30 : 
    (bf0_count == 8'd70 ? 8'd32 : 
    (bf0_count == 8'd71 ? 8'd34 : 
    (bf0_count == 8'd72 ? 8'd36 : 
    (bf0_count == 8'd73 ? 8'd38 : 
    (bf0_count == 8'd74 ? 8'd40 : 
    (bf0_count == 8'd75 ? 8'd42 : 
    (bf0_count == 8'd76 ? 8'd44 : 
    (bf0_count == 8'd77 ? 8'd46 : 
    (bf0_count == 8'd78 ? 8'd48 : 
    (bf0_count == 8'd79 ? 8'd50 : 
    (bf0_count == 8'd80 ? 8'd52 : 8'd0)))))))))))))))))))))))))))))))))))))))))))))))))))))) : 8'd0;



Twiddle81 TW (
        .clk    (clk    ),  //  i
        .addr   (tw_addr0),  //  i
        .tw_re  (tw_re0  ),  //  o
        .tw_im  (tw_im0  )   //  o
    );
Multiply #(.WIDTH(WIDTH)) U1(
        .a_re(temp0_re),
        .a_im(temp0_im),
        .b_re(tw_re0),
        .b_im(tw_im0),
        .m_re(bf0_boundary_re),
        .m_im(bf0_boundary_im)
    );

assign stage0_re = bf0_boundary_re;
assign stage0_im = bf0_boundary_im;

//----------------------------------------------------------------------
//  2nd Butterfly
//----------------------------------------------------------------------
always @(posedge clk) begin
    if (rst) begin
        di_count <= {Stages{1'b0}};
        counter <=0;
    end else begin
    di_count <= bf0_sp_en ? di_count==26 ? 0 : (di_count + 1'b1) : 0;
    counter <= !bf1_enable ? (counter + 1'b1) : 0;
    end
end
assign bf1_enable = (di_count > 17 && di_count < 27);

assign  bf1_x0_re = bf1_enable ? db_do_re : {WIDTH{1'bx}};
assign  bf1_x0_im = bf1_enable ? db_do_im : {WIDTH{1'bx}};
assign  bf1_x1_re = bf1_enable ? db_do_re2 : {WIDTH{1'bx}};
assign  bf1_x1_im = bf1_enable ? db_do_im2 : {WIDTH{1'bx}};
assign  bf1_x2_re = bf1_enable ? stage0_re : {WIDTH{1'bx}};
assign  bf1_x2_im = bf1_enable ? stage0_im : {WIDTH{1'bx}};

Butterfly3 #(.WIDTH(WIDTH)) BF2 (
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

DelayBuffer #(.DEPTH(18),.WIDTH(WIDTH)) DB3 (
    .clk     (clk        ),  //  i
    .in_re   (db_di_re   ),  //  i
    .in_im   (db_di_im   ),  //  i
    .out_re  (db_do_re   ),  //  o
    .out_im  (db_do_im   )   //  o
);
DelayBuffer #(.DEPTH(9),.WIDTH(WIDTH)) DB4 (
    .clk     (clk         ),  //  i
    .in_re   (db_di_re2   ),  //  i
    .in_im   (db_di_im2   ),  //  i
    .out_re  (db_do_re2   ),  //  o
    .out_im  (db_do_im2   )   //  o
);


assign  db_di_re2 = bf1_enable ? bf1_y1_re : di_count<18 && di_count>8 ? stage0_re : 0;
assign  db_di_im2 = bf1_enable ? bf1_y1_im : di_count<18 && di_count>8 ? stage0_im : 0;
assign  db_di_re = bf1_enable ? bf1_y2_re : di_count<9 ? stage0_re : 0;
assign  db_di_im = bf1_enable ? bf1_y2_im : di_count<9 ? stage0_im : 0;
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
assign  bf1_end = (bf1_count == 80); 

always @(posedge clk) begin
    bf1_do_re <= bf1_sp_re;
    bf1_do_im <= bf1_sp_im;
end

assign temp1_re = bf1_sp_en ? bf1_do_re : 0;
assign temp1_im = bf1_sp_en ? bf1_do_im : 0;

assign tw_addr = bf1_sp_en ? 
    (bf1_count == 8'd10 ? 8'd3 : 
    (bf1_count == 8'd19 ? 8'd6 : 
    (bf1_count == 8'd11 ? 8'd6 : 
    (bf1_count == 8'd20 ? 8'd12 : 
    (bf1_count == 8'd12 ? 8'd9 : 
    (bf1_count == 8'd21 ? 8'd18 : 
    (bf1_count == 8'd13 ? 8'd12 : 
    (bf1_count == 8'd22 ? 8'd24 : 
    (bf1_count == 8'd14 ? 8'd15 : 
    (bf1_count == 8'd23 ? 8'd30 : 
    (bf1_count == 8'd15 ? 8'd18 : 
    (bf1_count == 8'd24 ? 8'd36 : 
    (bf1_count == 8'd16 ? 8'd21 : 
    (bf1_count == 8'd25 ? 8'd42 : 
    (bf1_count == 8'd17 ? 8'd24 : 
    (bf1_count == 8'd26 ? 8'd48 :
    (bf1_count == 8'd37 ? 8'd3 : 
    (bf1_count == 8'd46 ? 8'd6 : 
    (bf1_count == 8'd38 ? 8'd6 : 
    (bf1_count == 8'd47 ? 8'd12 : 
    (bf1_count == 8'd39 ? 8'd9 : 
    (bf1_count == 8'd48 ? 8'd18 : 
    (bf1_count == 8'd40 ? 8'd12 : 
    (bf1_count == 8'd49 ? 8'd24 : 
    (bf1_count == 8'd41 ? 8'd15 : 
    (bf1_count == 8'd50 ? 8'd30 : 
    (bf1_count == 8'd42 ? 8'd18 : 
    (bf1_count == 8'd51 ? 8'd36 : 
    (bf1_count == 8'd43 ? 8'd21 : 
    (bf1_count == 8'd52 ? 8'd42 : 
    (bf1_count == 8'd44 ? 8'd24 : 
    (bf1_count == 8'd53 ? 8'd48 : 
    (bf1_count == 8'd64 ? 8'd3 : 
    (bf1_count == 8'd73 ? 8'd6 : 
    (bf1_count == 8'd65 ? 8'd6 : 
    (bf1_count == 8'd74 ? 8'd12 : 
    (bf1_count == 8'd66 ? 8'd9 : 
    (bf1_count == 8'd75 ? 8'd18 : 
    (bf1_count == 8'd67 ? 8'd12 : 
    (bf1_count == 8'd76 ? 8'd24 : 
    (bf1_count == 8'd68 ? 8'd15 : 
    (bf1_count == 8'd77 ? 8'd30 : 
    (bf1_count == 8'd69 ? 8'd18 : 
    (bf1_count == 8'd78 ? 8'd36 : 
    (bf1_count == 8'd70 ? 8'd21 : 
    (bf1_count == 8'd79 ? 8'd42 : 
    (bf1_count == 8'd71 ? 8'd24 : 
    (bf1_count == 8'd80 ? 8'd48 :8'd0)))))))))))))))))))))))))))))))))))))))))))))))) : 8'd0;


Twiddle81 TW2 (
        .clk    (clk    ),  //  i
        .addr   (tw_addr),  //  i
        .tw_re  (tw_re  ),  //  o
        .tw_im  (tw_im  )   //  o
    );
Multiply #(.WIDTH(WIDTH)) U2(
        .a_re(temp1_re),
        .a_im(temp1_im),
        .b_re(tw_re),
        .b_im(tw_im),
        .m_re(bf1_boundary_re),
        .m_im(bf1_boundary_im)
    );

assign stage1_re = bf1_boundary_re;
assign stage1_im = bf1_boundary_im;
// localparam N=81;
// reg [WIDTH-1:0]	output_r [N-1:0]; 
// reg [WIDTH-1:0]	output_i [N-1:0];
// always @(*) begin
// wait(bf1_sp_en);
// for (int i = 0; i < N; i=i+1) begin
//             @(negedge clk);
//             output_r[i] = stage1_re;
//             output_i[i] = stage1_im;
           
//         end
// end
//----------------------------------------------------------------------
//  3rd Butterfly
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

assign  bf2_enable = di_count2>5 ? 1'b1 : 1'b0;
assign  bf2_x0_re = bf2_enable ? db2_do_re : {WIDTH{1'bx}};
assign  bf2_x0_im = bf2_enable ? db2_do_im : {WIDTH{1'bx}};
assign  bf2_x1_re = bf2_enable ? db2_do_re2 : {WIDTH{1'bx}};
assign  bf2_x1_im = bf2_enable ? db2_do_im2 : {WIDTH{1'bx}};
assign  bf2_x2_re = bf2_enable ? stage1_re : {WIDTH{1'bx}};
assign  bf2_x2_im = bf2_enable ? stage1_im : {WIDTH{1'bx}};

Butterfly3 #(.WIDTH(WIDTH)) BF3 (
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

DelayBuffer #(.DEPTH(6),.WIDTH(WIDTH)) DB6 (
    .clk     (clk        ),  //  i
    .in_re   (db2_di_re   ),  //  i
    .in_im   (db2_di_im   ),  //  i
    .out_re  (db2_do_re   ),  //  o
    .out_im  (db2_do_im   )   //  o
);
DelayBuffer #(.DEPTH(3),.WIDTH(WIDTH)) DB7 (
    .clk     (clk         ),  //  i
    .in_re   (db2_di_re2   ),  //  i
    .in_im   (db2_di_im2   ),  //  i
    .out_re  (db2_do_re2   ),  //  o
    .out_im  (db2_do_im2   )   //  o
);


assign  db2_di_re2 = bf2_enable ? bf2_y1_re : (di_count2<6 && di_count2>2)   ? stage1_re : 0;
assign  db2_di_im2 = bf2_enable ? bf2_y1_im : di_count2<6 && di_count2>2 ? stage1_im : 0;
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
assign  bf2_end = (bf2_count==80); //adjust this and above

always @(posedge clk) begin
    bf2_do_re <= bf2_sp_re;
    bf2_do_im <= bf2_sp_im;
end

assign temp2_re = bf2_sp_en ? bf2_do_re : 0;
assign temp2_im = bf2_sp_en ? bf2_do_im : 0;

assign tw_addr2 = bf2_sp_en ? (bf2_count == 4 || bf2_count == 13 || bf2_count == 22 || bf2_count == 31 || bf2_count == 40 || bf2_count == 49 || bf2_count == 58 || bf2_count == 67 || bf2_count == 76) ? 8'd9 
 : (bf2_count == 7 || bf2_count == 16 || bf2_count == 25 || bf2_count == 34 || bf2_count == 43 || bf2_count == 52 || bf2_count == 61 || bf2_count == 70 || bf2_count == 79) ? 8'd18 
 : (bf2_count == 5 || bf2_count == 14 || bf2_count == 23 || bf2_count == 32 || bf2_count == 41 || bf2_count == 50 || bf2_count == 59 || bf2_count == 68 || bf2_count == 77) ? 8'd18 
 : (bf2_count == 8 || bf2_count == 17 || bf2_count == 26 || bf2_count == 35 || bf2_count == 44 || bf2_count == 53 || bf2_count == 62 || bf2_count == 71 || bf2_count == 80) ? 8'd36 : 8'd0 : 8'd0;



Twiddle81 TW3 (
        .clk    (clk    ),  //  i
        .addr   (tw_addr2),  //  i
        .tw_re  (tw_re2  ),  //  o
        .tw_im  (tw_im2  )   //  o
    );
Multiply #(.WIDTH(WIDTH)) U3(
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
//  4th Butterfly
//----------------------------------------------------------------------
always @(posedge clk) begin
    
    di_count3 <= bf2_sp_en ? di_count3==2 ?0: (di_count3 + 1'b1) : 0;
    counter3 <= !bf3_enable ? (counter3 + 1'b1) : 0;
end

assign bf3_enable = di_count3==2 ? 1'b1 : 1'b0;
//  Set unknown value x for verification
assign  bf3_x0_re = bf3_enable ? db3_do_re : {WIDTH{1'bx}};
assign  bf3_x0_im = bf3_enable ? db3_do_im : {WIDTH{1'bx}};
assign  bf3_x1_re = bf3_enable ? db3_do_re2 : {WIDTH{1'bx}};
assign  bf3_x1_im = bf3_enable ? db3_do_im2 : {WIDTH{1'bx}};
assign  bf3_x2_re = bf3_enable ? stage2_re : {WIDTH{1'bx}};
assign  bf3_x2_im = bf3_enable ? stage2_im : {WIDTH{1'bx}};


Butterfly3 #(.WIDTH(WIDTH)) BF4 (
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

DelayBuffer #(.DEPTH(2),.WIDTH(WIDTH)) DB9 (
    .clk     (clk        ),  //  i
    .in_re   (db3_di_re   ),  //  i
    .in_im   (db3_di_im   ),  //  i
    .out_re  (db3_do_re   ),  //  o
    .out_im  (db3_do_im   )   //  o
);
DelayBuffer #(.DEPTH(1),.WIDTH(WIDTH)) DB10 (
    .clk     (clk         ),  //  i
    .in_re   (db3_di_re2   ),  //  i
    .in_im   (db3_di_im2   ),  //  i
    .out_re  (db3_do_re2   ),  //  o
    .out_im  (db3_do_im2   )   //  o
);



assign  db3_di_re = bf3_enable ? bf3_y2_re : (di_count3==0 ) ? stage2_re : 0;
assign  db3_di_im = bf3_enable ? bf3_y2_im : (di_count3==0 ) ? stage2_im : 0;
assign  db3_di_re2 = bf3_enable ? bf3_y1_re : (di_count3==1 ) ? stage2_re : 0;
assign  db3_di_im2 = bf3_enable ? bf3_y1_im : (di_count3==1 ) ? stage2_im : 0;
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

assign  bf3_end = (bf3_count == 80);

always @(posedge clk) begin
    bf3_do_re <= bf3_sp_re;
    bf3_do_im <= bf3_sp_im;
end


assign  do_en = bf3_sp_en ;
assign  do_re = bf3_do_re ;
assign  do_im = bf3_do_im ;

endmodule