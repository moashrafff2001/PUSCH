module SdfUnit128 #(
    parameter N=128,
    parameter TWIDDLE=128,
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

function integer log2;
    input integer x;
    integer value;
    begin
        value = x-1;
        for (log2=0; value>0; log2=log2+1)
            value = value>>1;
    end
endfunction

localparam  LOG_TWIDDLE = log2(TWIDDLE); 
localparam  Stages=log2(N);  
// 1st Butterfly
reg [Stages-1:0] di_count;   //  Input Data Count
wire            bf1_enable;     //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] bf1_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf1_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y1_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] db1_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db1_di_im;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db1_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db1_do_im;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] bf1_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf1_sp_im;  //  Single-Path Data Output (Imag)
reg             bf1_sp_en;  //  Single-Path Data Enable
reg [Stages-1:0] bf1_count;  //  Single-Path Data Count
wire            bf1_start;  //  Single-Path Output Trigger
wire            bf1_end;    //  End of Single-Path Data
wire            bf1_mj;     //  Twiddle (-j) Enable
reg [WIDTH-1:0] bf1_do_re;  //  1st Butterfly Output Data (Real)
reg [WIDTH-1:0] bf1_do_im;  //  1st Butterfly Output Data (Imag)

//  2nd Butterfly
reg             bf2_enable;     //  Butterfly Add/Sub Enable
wire[WIDTH-1:0] bf2_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf2_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y1_im;  //  Data #1 from Butterfly (Imag)
wire[WIDTH-1:0] db2_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db2_di_im;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db2_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db2_do_im;  //  Data from DelayBuffer (Imag)
wire[WIDTH-1:0] bf2_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf2_sp_im;  //  Single-Path Data Output (Imag)
reg             bf2_sp_en;  //  Single-Path Data Enable
reg [Stages-1:0] bf2_count;  //  Single-Path Data Count
reg             bf2_start;  //  Single-Path Output Trigger
wire            bf2_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf2_do_re;  //  2nd Butterfly Output Data (Real)
reg [WIDTH-1:0] bf2_do_im;  //  2nd Butterfly Output Data (Imag)
reg             bf2_do_en;  //  2nd Butterfly Output Data Enable

//  Multiplication
wire[1:0]       tw_sel;     //  Twiddle Select (2n/n/3n)
wire[Stages-3:0] tw_num;     //  Twiddle Number (n)
wire[6:0] tw_addr;    //  Twiddle Table Address
wire[WIDTH-1:0] tw_re;      //  Twiddle Factor (Real)
wire[WIDTH-1:0] tw_im;      //  Twiddle Factor (Imag)
reg             mu_en;      //  Multiplication Enable
wire[WIDTH-1:0] mu_a_re;    //  Multiplier Input (Real)
wire[WIDTH-1:0] mu_a_im;    //  Multiplier Input (Imag)
wire[WIDTH-1:0] mu_m_re;    //  Multiplier Output (Real)
wire[WIDTH-1:0] mu_m_im;    //  Multiplier Output (Imag)
reg [WIDTH-1:0] mu_do_re;   //  Multiplication Output Data (Real)
reg [WIDTH-1:0] mu_do_im;   //  Multiplication Output Data (Imag)
reg             mu_do_en;   //  Multiplication Output Data Enable

always @(posedge clk or posedge rst) begin
    if (rst) begin
        di_count <= {Stages{1'b0}};
    end else begin
        di_count <= (di_en && on) ? (di_count + 1'b1) : {Stages{1'b0}};
    end    
end
assign  bf1_enable = di_count[LOG_TWIDDLE-1]; 

assign  bf1_x0_re = bf1_enable ? db1_do_re : {WIDTH{1'bx}};
assign  bf1_x0_im = bf1_enable ? db1_do_im : {WIDTH{1'bx}};
assign  bf1_x1_re = bf1_enable ? di_re : {WIDTH{1'bx}};
assign  bf1_x1_im = bf1_enable ? di_im : {WIDTH{1'bx}};

Butterfly2 #(.WIDTH(WIDTH)) BF1 (
    .x0_re  (bf1_x0_re  ),  //  i
    .x0_im  (bf1_x0_im  ),  //  i
    .x1_re  (bf1_x1_re  ),  //  i
    .x1_im  (bf1_x1_im  ),  //  i
    .y0_re  (bf1_y0_re  ),  //  o
    .y0_im  (bf1_y0_im  ),  //  o
    .y1_re  (bf1_y1_re  ),  //  o
    .y1_im  (bf1_y1_im  )   //  o
);

DelayBuffer #(.DEPTH(2**(LOG_TWIDDLE-1)),.WIDTH(WIDTH)) DB1 (
    .clk    (clk        ),  //  i
    .in_re  (db1_di_re  ),  //  i
    .in_im  (db1_di_im  ),  //  i
    .out_re  (db1_do_re  ),  //  o
    .out_im  (db1_do_im  )   //  o
);

assign  db1_di_re = bf1_enable ? bf1_y1_re : di_re;
assign  db1_di_im = bf1_enable ? bf1_y1_im : di_im;
assign  bf1_sp_re = bf1_enable ? bf1_y0_re : bf1_mj ?  db1_do_im : db1_do_re;
assign  bf1_sp_im = bf1_enable ? bf1_y0_im : bf1_mj ? -db1_do_re : db1_do_im;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf1_sp_en <= 1'b0;
        bf1_count <= {Stages{1'b0}};
    end else begin
        bf1_sp_en <= bf1_start ? 1'b1 : bf1_end ? 1'b0 : bf1_sp_en;
        bf1_count <= bf1_sp_en ? (bf1_count + 1'b1) : {Stages{1'b0}};
    end
end

assign  bf1_start = (di_count == (2**(LOG_TWIDDLE-1)-1));
assign  bf1_end = (bf1_count == (2**Stages-1));
assign  bf1_mj = (bf1_count[LOG_TWIDDLE-1:LOG_TWIDDLE-2] == 2'd3);

always @(posedge clk) begin
    bf1_do_re <= bf1_sp_re;
    bf1_do_im <= bf1_sp_im;
end


//----------------------------------------------------------------------
//  2nd Butterfly
//----------------------------------------------------------------------
always @(posedge clk) begin
    bf2_enable <= bf1_count[LOG_TWIDDLE-2];
end

//  Set unknown value x for verification
assign  bf2_x0_re = bf2_enable ? db2_do_re : {WIDTH{1'bx}};
assign  bf2_x0_im = bf2_enable ? db2_do_im : {WIDTH{1'bx}};
assign  bf2_x1_re = bf2_enable ? bf1_do_re : {WIDTH{1'bx}};
assign  bf2_x1_im = bf2_enable ? bf1_do_im : {WIDTH{1'bx}};


Butterfly2 #(.WIDTH(WIDTH)) BF2 (
    .x0_re  (bf2_x0_re  ),  //  i
    .x0_im  (bf2_x0_im  ),  //  i
    .x1_re  (bf2_x1_re  ),  //  i
    .x1_im  (bf2_x1_im  ),  //  i
    .y0_re  (bf2_y0_re  ),  //  o
    .y0_im  (bf2_y0_im  ),  //  o
    .y1_re  (bf2_y1_re  ),  //  o
    .y1_im  (bf2_y1_im  )   //  o
);

DelayBuffer #(.DEPTH(2**(LOG_TWIDDLE-2)),.WIDTH(WIDTH)) DB2 (
    .clk    (clk      ),  //  i
    .in_re  (db2_di_re  ),  //  i
    .in_im  (db2_di_im  ),  //  i
    .out_re  (db2_do_re  ),  //  o
    .out_im  (db2_do_im  )   //  o
);

assign  db2_di_re = bf2_enable ? bf2_y1_re : bf1_do_re;
assign  db2_di_im = bf2_enable ? bf2_y1_im : bf1_do_im;
assign  bf2_sp_re = bf2_enable ? bf2_y0_re : db2_do_re;
assign  bf2_sp_im = bf2_enable ? bf2_y0_im : db2_do_im;

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
    bf2_start <= (bf1_count == (2**(LOG_TWIDDLE-2)-1)) & bf1_sp_en;
end
assign  bf2_end = (bf2_count == (2**Stages-1));

always @(posedge clk) begin
    bf2_do_re <= bf2_sp_re;
    bf2_do_im <= bf2_sp_im;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bf2_do_en <= 1'b0;
    end else begin
        bf2_do_en <= bf2_sp_en;
    end
end

//----------------------------------------------------------------------
//  Multiplication
//----------------------------------------------------------------------
assign  tw_sel[1] = bf2_count[LOG_TWIDDLE-2];
assign  tw_sel[0] = bf2_count[LOG_TWIDDLE-1];
assign  tw_num = bf2_count << (Stages-LOG_TWIDDLE);
assign  tw_addr = tw_num * tw_sel;

Twiddle128 TW (
    .clk    (clk    ),  //  i
    .addr   (tw_addr),  //  i
    .tw_re  (tw_re  ),  //  o
    .tw_im  (tw_im  )   //  o
);

//  Multiplication is bypassed when twiddle address is 0.
always @(posedge clk) begin
    mu_en <= (tw_addr != {Stages{1'b0}});
end
//  Set unknown value x for verification
assign  mu_a_re = mu_en ? bf2_do_re : {WIDTH{1'bx}};
assign  mu_a_im = mu_en ? bf2_do_im : {WIDTH{1'bx}};

Multiply #(.WIDTH(WIDTH)) MU (
    .a_re   (mu_a_re),  //  i
    .a_im   (mu_a_im),  //  i
    .b_re   (tw_re  ),  //  i
    .b_im   (tw_im  ),  //  i
    .m_re   (mu_m_re),  //  o
    .m_im   (mu_m_im)   //  o
);

always @(posedge clk) begin
    mu_do_re <= mu_en ? mu_m_re : bf2_do_re;
    mu_do_im <= mu_en ? mu_m_im : bf2_do_im;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mu_do_en <= 1'b0;
    end else begin
        mu_do_en <= bf2_do_en;
    end
end

//  No multiplication required at final stage
assign  do_en = (LOG_TWIDDLE == 2) ? bf2_do_en : mu_do_en;
assign  do_re = (LOG_TWIDDLE == 2) ? bf2_do_re : mu_do_re;
assign  do_im = (LOG_TWIDDLE == 2) ? bf2_do_im : mu_do_im;

endmodule