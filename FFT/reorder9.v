module reorder9 #(
    parameter WIDTH=18
)(
    input clk,rst,
    input signed [WIDTH-1:0] di_re,di_im,
    input di_en,
    output reg signed [WIDTH-1:0] do_re,do_im,
    output reg do_en
    
);
    reg [WIDTH-1:0] mem_re [0:8];
    reg [WIDTH-1:0] mem_im [0:8];
    reg done;
    wire[3:0] addr;
    reg [3:0] counter , di_count;


    assign addr = 
           (di_count == 4'd0) ? 4'd0 :

           (di_count == 4'd1) ? 4'd3 :

           (di_count == 4'd2) ? 4'd6 :

           (di_count == 4'd3) ? 4'd1 :

           (di_count == 4'd4) ? 4'd4 :

           (di_count == 4'd5) ? 4'd7 :

           (di_count == 4'd6) ? 4'd2 :

           (di_count == 4'd7) ? 4'd5 :

           (di_count == 4'd8) ? 4'd8 :
           4'd0;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            di_count <=0;
            done <=1;
            do_en<=0;
            do_im<=0;
            do_re<=0;
        end
        else if (di_en) begin
            di_count <=di_count+1;
            mem_re[addr] <= di_re;
            mem_im[addr] <= di_im;
            do_re<=0;
            do_im<=0;
            done<=0;
            do_en <=0;
        end
        else if (!done) begin
            do_re <= mem_re[counter];
            do_im <= mem_im[counter];
            do_en <=1;
            counter <= counter+1;
            done<=counter==8;
        end else begin
            do_re <= 0;
            do_im <= 0;
            di_count <= 0;
            counter <= 0;
            done <= 1;
            do_en <=0;
        end
    end
endmodule