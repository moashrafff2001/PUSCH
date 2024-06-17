module memory1#(
    parameter WIDTH=18
    )(
    input clk,rst,
    input signed[WIDTH-1:0] in_re,in_im,
    input [10:0] address,
    input[8:0] pow2,
    input [7:0] pow3x5,
    input [4:0] pow5,
    input done,
    input fft_done,
    output reg signed [WIDTH-1:0] out_re,out_im,
    output reg read
);
reg [7:0] i,j;
reg [WIDTH-1:0] mem_re [0:255][0:242];
reg [WIDTH-1:0] mem_im [0:255][0:242];
reg [8:0] rows_read,rows_write;
reg [7:0] columns_read,columns_write;
reg saved,comp,idle,full2;
reg [5:0] fft_done_path2;
wire sig;
pulse_gen Pulse_in_mem(
    .bus_enable(fft_done),
    .clk(clk),
    .rst(rst),
    .enable(sig)
);
always@(posedge clk) begin
    if (sig) begin
        fft_done_path2<=fft_done_path2==pow5?0:fft_done_path2+1;
    end
    else if (!(columns_write!=pow3x5-1) && !( (|pow5)&&fft_done_path2==pow5-1))
        fft_done_path2<=fft_done_path2==pow5?0:fft_done_path2;
    else begin
        fft_done_path2<=fft_done_path2;
    end
end
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out_re<=0;
        out_im <= 0;
        rows_read<=0;
        rows_write<=0;
        columns_read<=0;
        columns_write<=0;
        saved<=0;
        comp<=0;
        read<=0;
        idle<=1;
        full2<=0;
        fft_done_path2=0;
        //  for (i = 0; i < 256; i = i + 1) begin
        //     for (j = 0; j < 225; j = j + 1) begin
        //         mem_re[i][j] <= {WIDTH{1'b0}};
        //         mem_im[i][j] <= {WIDTH{1'b0}};
 
        //     end
        // end
    end else begin
    if (done || comp) begin
        comp<=1; 
        idle<=0;
        fft_done_path2<=0;
        if(~(columns_read==pow3x5)) begin
            if (rows_read!=pow2-1 ) begin
                rows_read<=rows_read+1;
                columns_read<=columns_read;
                mem_re[rows_read][columns_read]<=in_re;
                mem_im[rows_read][columns_read]<=in_im;
            end
            else begin
                rows_read<=0;
                columns_read<=columns_read+1;
                mem_re[rows_read][columns_read]<=in_re;
                mem_im[rows_read][columns_read]<=in_im;
            end
        end
        else begin
            rows_read<=0;
            columns_read<=0;
            comp<=0;
            saved <=1;
            idle<=0;
            read <=1;
        end 
    end
    if (saved) begin
        if (~(rows_write==pow2-1 && columns_write==pow3x5-1)) begin
            if (columns_write!=pow3x5-1) begin
                columns_write<=columns_write+1;
                rows_write<=rows_write;
                read<=1;
                
            end
            else if (!(|pow5) && fft_done || (|pow5)&&fft_done_path2==pow5 )  begin
                columns_write<=0;
                rows_write<=rows_write+1;
                read<=1;
            end
            else begin
                columns_write<=columns_write;
                rows_write<=rows_write;
                read<=0;
                
        end
        end
        else begin
            saved<=0;
            rows_write<=0;
            columns_write<=0;
            read<=0;
            columns_read<=address;
    
    end 
    end
     if (fft_done && !full2 && !idle) begin
        mem_re[rows_read][address]<=in_re;
        mem_im[rows_read][address]<=in_im;
        if(~(rows_read == pow2-1 && columns_read==pow3x5-1)) begin
            if (columns_read!=pow3x5-1) begin
                rows_read<=rows_read;
                columns_read<=columns_read+1;
                
            end
            else begin
                rows_read<=rows_read+1;
                columns_read<=0;
            end
        end
        else begin
            rows_read<=0;
            columns_read<=0;
            comp<=0;
            saved <=0;
            full2<=1;
            read <=1;
        end 
    end
    if (full2) begin
        if (~(rows_write==pow2-1 && columns_write==pow3x5-1)) begin
            if (rows_write!=pow2-1) begin
                columns_write<=columns_write;
                rows_write<=rows_write+1;
                read<=1;
            end
            else if (fft_done)  begin
                rows_write<=0;
                columns_write<=columns_write+1;
                read<=1;

            end
            else begin
                columns_write<=columns_write;
                rows_write<=rows_write;
                read<=0;
                
        end
        end
        else begin
            saved<=0;
            rows_write<=0;
            columns_write<=0;
            full2<=0;
            read<=0;
            idle<=1;
            end 
end
end
end
always @ (*) begin
    
    out_re = saved || full2 ? mem_re[rows_write][columns_write]:0;
    out_im = saved || full2 ? mem_im[rows_write][columns_write]:0;
end

// always @(posedge clk) begin
//     read <= saved && columns_write<pow3x5 || fft_done && saved || fft_done && full2 ?1:0;
// end         
endmodule