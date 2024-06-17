module reorder81 #(
    parameter WIDTH=18
)(
    input clk,rst,
    input signed [WIDTH-1:0] di_re,di_im,
    input di_en,
    output reg signed [WIDTH-1:0] do_re,do_im,
    output reg do_en
    
);
    reg [WIDTH-1:0] mem_re [0:80];
    reg [WIDTH-1:0] mem_im [0:80];
    reg done;
    wire[6:0] addr;
    reg [6:0] counter , di_count;


    assign addr = (di_count == 7'd0) ? 7'd0 :

           (di_count == 7'd1) ? 7'd27 :

           (di_count == 7'd2) ? 7'd54 :

           (di_count == 7'd3) ? 7'd9 :

           (di_count == 7'd4) ? 7'd36 :

           (di_count == 7'd5) ? 7'd63 :

           (di_count == 7'd6) ? 7'd18 :

           (di_count == 7'd7) ? 7'd45 :

           (di_count == 7'd8) ? 7'd72 :

           (di_count == 7'd9) ? 7'd3 :

           (di_count == 7'd10) ? 7'd30 :

           (di_count == 7'd11) ? 7'd57 :

           (di_count == 7'd12) ? 7'd12 :

           (di_count == 7'd13) ? 7'd39 :

           (di_count == 7'd14) ? 7'd66 :

           (di_count == 7'd15) ? 7'd21 :

           (di_count == 7'd16) ? 7'd48 :

           (di_count == 7'd17) ? 7'd75 :

           (di_count == 7'd18) ? 7'd6 :

           (di_count == 7'd19) ? 7'd33 :

           (di_count == 7'd20) ? 7'd60 :

           (di_count == 7'd21) ? 7'd15 :

           (di_count == 7'd22) ? 7'd42 :

           (di_count == 7'd23) ? 7'd69 :

           (di_count == 7'd24) ? 7'd24 :

           (di_count == 7'd25) ? 7'd51 :

           (di_count == 7'd26) ? 7'd78 :

           (di_count == 7'd27) ? 7'd1 :

           (di_count == 7'd28) ? 7'd28 :

           (di_count == 7'd29) ? 7'd55 :

           (di_count == 7'd30) ? 7'd10 :

           (di_count == 7'd31) ? 7'd37 :

           (di_count == 7'd32) ? 7'd64 :

           (di_count == 7'd33) ? 7'd19 :

           (di_count == 7'd34) ? 7'd46 :

           (di_count == 7'd35) ? 7'd73 :

           (di_count == 7'd36) ? 7'd4 :

           (di_count == 7'd37) ? 7'd31 :

           (di_count == 7'd38) ? 7'd58 :

           (di_count == 7'd39) ? 7'd13 :

           (di_count == 7'd40) ? 7'd40 :

           (di_count == 7'd41) ? 7'd67 :

           (di_count == 7'd42) ? 7'd22 :

           (di_count == 7'd43) ? 7'd49 :

           (di_count == 7'd44) ? 7'd76 :

           (di_count == 7'd45) ? 7'd7 :

           (di_count == 7'd46) ? 7'd34 :

           (di_count == 7'd47) ? 7'd61 :

           (di_count == 7'd48) ? 7'd16 :

           (di_count == 7'd49) ? 7'd43 :

           (di_count == 7'd50) ? 7'd70 :

           (di_count == 7'd51) ? 7'd25 :

           (di_count == 7'd52) ? 7'd52 :

           (di_count == 7'd53) ? 7'd79 :

           (di_count == 7'd54) ? 7'd2 :

           (di_count == 7'd55) ? 7'd29 :

           (di_count == 7'd56) ? 7'd56 :

           (di_count == 7'd57) ? 7'd11 :

           (di_count == 7'd58) ? 7'd38 :

           (di_count == 7'd59) ? 7'd65 :

           (di_count == 7'd60) ? 7'd20 :

           (di_count == 7'd61) ? 7'd47 :

           (di_count == 7'd62) ? 7'd74 :

           (di_count == 7'd63) ? 7'd5 :

           (di_count == 7'd64) ? 7'd32 :

           (di_count == 7'd65) ? 7'd59 :

           (di_count == 7'd66) ? 7'd14 :

           (di_count == 7'd67) ? 7'd41 :

           (di_count == 7'd68) ? 7'd68 :

           (di_count == 7'd69) ? 7'd23 :

           (di_count == 7'd70) ? 7'd50 :

           (di_count == 7'd71) ? 7'd77 :

           (di_count == 7'd72) ? 7'd8 :

           (di_count == 7'd73) ? 7'd35 :

           (di_count == 7'd74) ? 7'd62 :

           (di_count == 7'd75) ? 7'd17 :

           (di_count == 7'd76) ? 7'd44 :

           (di_count == 7'd77) ? 7'd71 :

           (di_count == 7'd78) ? 7'd26 :

           (di_count == 7'd79) ? 7'd53 :

           (di_count == 7'd80) ? 7'd80 :
           7'd0;

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
            done<=counter==80;
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