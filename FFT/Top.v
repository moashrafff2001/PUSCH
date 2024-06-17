module Top #(

    parameter WIDTH=18

    )(

        input clk,

        input rst,

        input [WIDTH-1:0] di_re,

        input [WIDTH-1:0] di_im,

        input Flag,done,

        output  [WIDTH-1:0] do_re,

        output  [WIDTH-1:0] do_im,

        output do_en,

        output [10:0] address,

        output Finish

    );

///Which_stages module///

wire [3:0] stage2;

wire [2:0] stage3;

wire [1:0] stage5;
wire [10:0] points;

////////Calc module/////

wire [8:0] pow2;

wire [7:0] pow3;

wire [4:0] pow5;

wire [7:0] pow3x5;

/////Memory1/////

wire read_m1;

wire [WIDTH-1:0] mem1_out_im,mem1_out_re;

wire [WIDTH-1:0] mem1_in_re,mem1_in_im;

/////demux1///////

wire select1;

wire [WIDTH-1:0] fft_not2_re,fft_not5_re;

wire [WIDTH-1:0] fft_not2_im,fft_not5_im;

wire read1_to_mixed,read1_to_not_mixed;

/////Memory2//////

wire [WIDTH-1:0] mem2_out_re,mem2_out_im;

wire read_m2;

wire [WIDTH-1:0] mem2_in_re,mem2_in_im;

/////demux2///////

wire select2;

wire [WIDTH-1:0] fft5_di_re,fft3_di_re_from5;

wire [WIDTH-1:0] fft5_di_im,fft3_di_im_from5;

wire read2_to_fft5,read2_to_fft3;

///////FFT5//////

wire fft5_do_en;

wire [WIDTH-1:0] fft5_do_re,fft5_do_im;

/////Pulse Gen2///

wire pulse2;

///////InterFFT//////

wire do_enable3,do_enable5;

wire [WIDTH-1:0] fft5_do_re_after_bound,fft3_do_re_after_bound;

wire [WIDTH-1:0] fft5_do_im_after_bound,fft3_do_im_after_bound;

wire [WIDTH-1:0] in_re,in_im;

///////FFT3//////

wire fft3_do_en;

wire [WIDTH-1:0] fft3_do_re,fft3_do_im;

wire fft3_di_en;

wire [WIDTH-1:0] fft3_di_re,fft3_di_im;

/////Pulse Gen1////

wire pulse1;

///////demux3///////

wire select3;

wire [WIDTH-1:0] fft3_di_re_from2,fft2_di_re;

wire [WIDTH-1:0] fft3_di_im_from2,fft2_di_im;

wire read1_to_fft2,read1_to_fft3;

///////mux///////

wire select4;





wire fft3_5_done;

reg [10:0] fft3_5_counter;

wire fft_done1;



wire do_enable33;

wire [WIDTH-1:0] mem3_out_re,mem3_out_im;



wire fft3_row_done;

reg [10:0] fft3_row_done_counter;



wire fft_done2;

wire fft2_di_en;

wire fft_from5_to3;

reg [7:0] fft_from5_to3_counter;



wire pulse3;

which_stages which_stage(

    .flag(Flag),

    .done(done),

    .reset(rst),

    .clk(clk),

    .stages2(stage2),

    .stages3(stage3),

    .stages5(stage5),

    .points(points)

);



calc calc1(

    .stage2(stage2),

    .stage3(stage3),

    .stage5(stage5),

    .pow2(pow2),

    .pow3(pow3),

    .pow5(pow5),

    .pow3x5(pow3x5)

);



assign mem1_in_re=do_enable3?fft3_do_re_after_bound:di_re;

assign mem1_in_im=do_enable3?fft3_do_im_after_bound:di_im;



reg buffered_done;

always@(posedge clk or posedge rst)begin

    if(rst)begin

        buffered_done<=0;

    end else begin

        buffered_done<=done;

    end

end



    

reg [10:0] address_temp1;

reg [10:0] x1;

reg[10:0] counter1;

wire [10:0] address_m1;

always @(posedge clk or posedge rst) begin

    if(rst) begin

        address_temp1<=0;

        x1<=0;

        counter1<=0;

    end else if(do_enable3 && |pow5) begin

        counter1<=counter1==pow3-1?0:counter1+1;

        x1<=counter1==pow3-1?address_m1==(pow3x5)-1?0:x1+1:x1;

        address_temp1<=counter1==pow3-1?0:address_temp1+pow5;    

    end else if(do_enable3 && !(|pow5)) begin

        x1<=0;

        counter1<=0;

        address_temp1<=address_m1==pow3-1?0:address_temp1+1;

    end else if (done) begin
	address_temp1<=0;

        x1<=0;

        counter1<=0;
end

end



assign address_m1=rst?0:address_temp1+x1;

assign fft_done1=fft3_5_done?do_en:do_enable3;

memory1 #(.WIDTH(WIDTH)) M1(
    .clk(clk),
    .rst(rst),
    .in_re(mem1_in_re),
    .in_im(mem1_in_im),
    .address(address_m1),
    .pow2(pow2),
    .pow3x5(pow3x5),
    .pow5(pow5),
    .done(buffered_done),
    .fft_done(fft_done1),
    .out_re(mem1_out_re),
    .out_im(mem1_out_im),
    .read(read_m1)
);





wire [10:0] number;

assign number=pow2*pow5;

always @(posedge clk or posedge rst) begin

    if(rst) begin

        fft3_5_counter<=0;

    end else if(pulse1) begin

        fft3_5_counter<=|stage5 ? fft3_5_counter==number? 1:fft3_5_counter+1: fft3_5_counter==pow2?1:fft3_5_counter+1;

    end else if (done) begin
	fft3_5_counter<=0;
    end
	else begin
	fft3_5_counter<=fft3_5_counter;
end

end



assign fft3_5_done=done ? 0: |stage5?(fft3_5_counter==pow2*pow5)&&fft3_do_en==0?1:0:(fft3_5_counter==pow2) && fft3_do_en==0 ?1:0;

assign select1= |stage5  ? fft3_5_done ?1:0 :1 ;



demux #(.WIDTH(WIDTH)) dmx1_r(

    .sel(select1),

    .in(mem1_out_re),

    .out0(fft_not2_re),

    .out1(fft_not5_re)

);  

demux #(.WIDTH(WIDTH)) dmx1_i(

    .sel(select1),

    .in(mem1_out_im),

    .out0(fft_not2_im),

    .out1(fft_not5_im)

); 

demux #(.WIDTH(1)) dmx1_en(

    .sel(select1),

    .in(read_m1),

    .out0(read1_to_mixed),

    .out1(read1_to_not_mixed)

); 



assign mem2_in_re=do_enable5?fft5_do_re_after_bound:read_m1?fft_not2_re:0;

assign mem2_in_im=do_enable5?fft5_do_im_after_bound:read_m1?fft_not2_im:0;



assign fft_done2= fft_from5_to3?do_enable3:do_enable5;

memory2 #(.WIDTH(WIDTH)) M2(

    .clk(clk),

    .rst(rst),

    .in_re(mem2_in_re),

    .in_im(mem2_in_im),

    .pow5(pow5),

    .pow3(pow3),

    .done(read1_to_mixed),

    .fft_done(fft_done2),

    .out_re(mem2_out_re),

    .out_im(mem2_out_im),

    .read(read_m2)

);





reg [10:0] fft_from3_to5_counter;

always @(posedge clk or posedge rst) begin

    if(rst ) begin

        fft_from5_to3_counter<=0;

        fft_from3_to5_counter<=0;

    end else if(pulse2) begin

        fft_from5_to3_counter<=fft_from5_to3_counter==pow3?1:fft_from5_to3_counter+1;

        fft_from3_to5_counter<=0;

    end else if (pulse3)begin

        fft_from3_to5_counter<=fft_from3_to5_counter==pow5?1:fft_from3_to5_counter+1;

    end else if (done) begin
	fft_from5_to3_counter<=0;

        fft_from3_to5_counter<=0;

    end else begin
	fft_from5_to3_counter<=fft_from5_to3_counter;

        fft_from3_to5_counter<=fft_from3_to5_counter;
    end
end



assign fft_from5_to3=done ? 0:(fft_from5_to3_counter==pow3)&&fft5_do_en==0?(fft_from3_to5_counter==pow5)&&fft3_do_en==0?0:1:0;

assign select2= fft_from5_to3 ? 1 : 0;



demux #(.WIDTH(WIDTH)) dmx2_r(

    .sel(select2),

    .in(mem2_out_re),

    .out0(fft5_di_re),

    .out1(fft3_di_re_from5)

);  

demux #(.WIDTH(WIDTH)) dmx2_i(

    .sel(select2),

    .in(mem2_out_im),

    .out0(fft5_di_im),

    .out1(fft3_di_im_from5)

);

demux #(.WIDTH(1)) dmx2_en(

    .sel(select2),

    .in(read_m2),

    .out0(read2_to_fft5),

    .out1(read2_to_fft3)

);  



FFT5 #(.WIDTH(WIDTH))FFT5(

    .clk(clk),

    .rst(rst),

    .di_en(read2_to_fft5),

    .di_re(fft5_di_re),

    .di_im(fft5_di_im),

    .Stages(stage5),

    .do_re(fft5_do_re),

    .do_im(fft5_do_im),

    .do_en(fft5_do_en)

);



pulse_gen Pulse2(

    .bus_enable(fft5_do_en),

    .clk(clk),

    .rst(rst),

    .enable(pulse2)

);



assign in_re=fft5_do_en?fft5_do_re:fft3_do_en?fft3_do_re:0;

assign in_im=fft5_do_en?fft5_do_im:fft3_do_en?fft3_do_im:0;



InterFFT #(.WIDTH(WIDTH)) InterFFT(

    .clk(clk),

    .rst(rst),

    .di_re(in_re),

    .di_im(in_im),

    .address(address_m1),

    .pow5(pow5),

    .pow2(pow2),

    .pow3x5(pow3x5),

    .FFT3_enable(fft3_do_en),

    .FFT5_enable(fft5_do_en),

    .enable5(do_enable5),

    .do5_re(fft5_do_re_after_bound),

    .do5_im(fft5_do_im_after_bound),

    .enable3(do_enable3),

    .do3_re(fft3_do_re_after_bound),

    .do3_im(fft3_do_im_after_bound)

);

pulse_gen Pulse3(

    .bus_enable(fft3_do_en),

    .clk(clk),

    .rst(rst),

    .enable(pulse3)

);



reg in=0;

always@(*) begin

    if(rst || done)begin

        fft3_row_done_counter=0;

    end else if(pulse3) begin

        fft3_row_done_counter=fft3_row_done_counter==pow5?0:fft3_row_done_counter+1;

        in=1;

    end

end



assign fft3_row_done=done ? 0:in&fft3_row_done_counter==pow5&&fft3_do_en==0?1:0;



FFT3 #(.WIDTH(WIDTH)) FFT3(

    .clk(clk),

    .rst(rst),

    .di_en(fft3_di_en),

    .di_re(fft3_di_re),

    .di_im(fft3_di_im),

    .Stages(stage3),

    .do_re(fft3_do_re),

    .do_im(fft3_do_im),

    .do_en(fft3_do_en)

);



pulse_gen Pulse1(

    .bus_enable(fft3_do_en),

    .clk(clk),

    .rst(rst),

    .enable(pulse1)

);



assign select3=fft3_5_done;



demux #(.WIDTH(WIDTH)) dmx3_r(

    .sel(select3),

    .in(fft_not5_re),

    .out0(fft3_di_re_from2),

    .out1(fft2_di_re)

);  

demux #(.WIDTH(WIDTH)) dmx3_i(

    .sel(select3),

    .in(fft_not5_im),

    .out0(fft3_di_im_from2),

    .out1(fft2_di_im)

);

demux #(.WIDTH(1)) dmx3_en(

    .sel(select3),

    .in(read1_to_not_mixed),

    .out0(read1_to_fft3),

    .out1(fft2_di_en)

);  



assign select4=~(|stage5);



mux #(.WIDTH(WIDTH)) mx_re(

    .input_0(fft3_di_re_from5),

    .input_1(fft3_di_re_from2),

    .select(select4),

    .out(fft3_di_re)

);



mux #(.WIDTH(WIDTH)) mx_im(

    .input_0(fft3_di_im_from5),

    .input_1(fft3_di_im_from2),

    .select(select4),

    .out(fft3_di_im)

);



mux #(.WIDTH(1)) mx_en(

    .input_0(read2_to_fft3),

    .input_1(read1_to_fft3),

    .select(select4),

    .out(fft3_di_en)

);



FFT2 #(.WIDTH(WIDTH)) FFT2(

    .clk(clk),

    .rst(rst),

    .di_en(fft2_di_en),

    .di_re(fft2_di_re),

    .di_im(fft2_di_im),

    .Stages(stage2),

    .do_re(do_re),

    .do_im(do_im),

    .do_en(do_en)

);



reg [10:0] address_temp;

reg [10:0] x;

reg[10:0] counter;

always @(posedge clk or posedge rst) begin

    if(rst) begin

        address_temp<=0;

        x<=0;

        counter<=0;

    end else if(do_en) begin

        counter<=counter==pow2-1?0:counter+1;

        x<=counter==pow2-1?address==(pow2*pow3x5)-1?0:x+1:x;

        address_temp<=counter==pow2-1?0:address_temp+pow3x5;    
        
    end

end
reg [11:0] last;
always@(posedge clk or posedge rst) begin
    if (rst) 
    last<=0;
    else if(do_en)begin
    last<=last==points-1?0:last+1;
    end
end

assign Finish=last==points-1?1:0;
assign address=rst?0:address_temp+x;



endmodule
