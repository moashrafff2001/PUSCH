module reorder27 #(
    parameter WIDTH=18
)(
    input clk,rst,
    input signed [WIDTH-1:0] di_re,di_im,
    input di_en,
    output reg signed [WIDTH-1:0] do_re,do_im,
    output reg do_en
    
);
    reg [WIDTH-1:0] mem_re [0:26];
    reg [WIDTH-1:0] mem_im [0:26];
    reg done;
    wire[4:0] addr;
    reg [4:0] counter , di_count;


    assign addr =
           (di_count == 5'd0) ? 5'd0 :

           (di_count == 5'd1) ? 5'd9 :

           (di_count == 5'd2) ? 5'd18 :

           (di_count == 5'd3) ? 5'd3 :

           (di_count == 5'd4) ? 5'd12 :

           (di_count == 5'd5) ? 5'd21 :

           (di_count == 5'd6) ? 5'd6 :

           (di_count == 5'd7) ? 5'd15 :

           (di_count == 5'd8) ? 5'd24 :

           (di_count == 5'd9) ? 5'd1 :

           (di_count == 5'd10) ? 5'd10 :

           (di_count == 5'd11) ? 5'd19 :

           (di_count == 5'd12) ? 5'd4 :

           (di_count == 5'd13) ? 5'd13 :

           (di_count == 5'd14) ? 5'd22 :

           (di_count == 5'd15) ? 5'd7 :

           (di_count == 5'd16) ? 5'd16 :

           (di_count == 5'd17) ? 5'd25 :

           (di_count == 5'd18) ? 5'd2 :

           (di_count == 5'd19) ? 5'd11 :

           (di_count == 5'd20) ? 5'd20 :

           (di_count == 5'd21) ? 5'd5 :

           (di_count == 5'd22) ? 5'd14 :

           (di_count == 5'd23) ? 5'd23 :

           (di_count == 5'd24) ? 5'd8 :

           (di_count == 5'd25) ? 5'd17 :

           (di_count == 5'd26) ? 5'd26 :
           5'd0;

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
            done<=counter==26;
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