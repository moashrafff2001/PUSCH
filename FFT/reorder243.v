module reorder243 #(
    parameter WIDTH=18
)(
    input clk,rst,
    input signed [WIDTH-1:0] di_re,di_im,
    input di_en,
    output reg signed [WIDTH-1:0] do_re,do_im,
    output reg do_en
    
);
    reg [WIDTH-1:0] mem_re [0:242];
    reg [WIDTH-1:0] mem_im [0:242];
    reg done;
    wire[7:0] addr;
    reg [7:0] counter , di_count;


    assign addr = (di_count == 8'd0) ? 8'd0 :

           (di_count == 8'd1) ? 8'd81 :

           (di_count == 8'd2) ? 8'd162 :

           (di_count == 8'd3) ? 8'd27 :

           (di_count == 8'd4) ? 8'd108 :

           (di_count == 8'd5) ? 8'd189 :

           (di_count == 8'd6) ? 8'd54 :

           (di_count == 8'd7) ? 8'd135 :

           (di_count == 8'd8) ? 8'd216 :

           (di_count == 8'd9) ? 8'd9 :

           (di_count == 8'd10) ? 8'd90 :

           (di_count == 8'd11) ? 8'd171 :

           (di_count == 8'd12) ? 8'd36 :

           (di_count == 8'd13) ? 8'd117 :

           (di_count == 8'd14) ? 8'd198 :

           (di_count == 8'd15) ? 8'd63 :

           (di_count == 8'd16) ? 8'd144 :

           (di_count == 8'd17) ? 8'd225 :

           (di_count == 8'd18) ? 8'd18 :

           (di_count == 8'd19) ? 8'd99 :

           (di_count == 8'd20) ? 8'd180 :

           (di_count == 8'd21) ? 8'd45 :

           (di_count == 8'd22) ? 8'd126 :

           (di_count == 8'd23) ? 8'd207 :

           (di_count == 8'd24) ? 8'd72 :

           (di_count == 8'd25) ? 8'd153 :

           (di_count == 8'd26) ? 8'd234 :

           (di_count == 8'd27) ? 8'd3 :

           (di_count == 8'd28) ? 8'd84 :

           (di_count == 8'd29) ? 8'd165 :

           (di_count == 8'd30) ? 8'd30 :

           (di_count == 8'd31) ? 8'd111 :

           (di_count == 8'd32) ? 8'd192 :

           (di_count == 8'd33) ? 8'd57 :

           (di_count == 8'd34) ? 8'd138 :

           (di_count == 8'd35) ? 8'd219 :

           (di_count == 8'd36) ? 8'd12 :

           (di_count == 8'd37) ? 8'd93 :

           (di_count == 8'd38) ? 8'd174 :

           (di_count == 8'd39) ? 8'd39 :

           (di_count == 8'd40) ? 8'd120 :

           (di_count == 8'd41) ? 8'd201 :

           (di_count == 8'd42) ? 8'd66 :

           (di_count == 8'd43) ? 8'd147 :

           (di_count == 8'd44) ? 8'd228 :

           (di_count == 8'd45) ? 8'd21 :

           (di_count == 8'd46) ? 8'd102 :

           (di_count == 8'd47) ? 8'd183 :

           (di_count == 8'd48) ? 8'd48 :

           (di_count == 8'd49) ? 8'd129 :

           (di_count == 8'd50) ? 8'd210 :

           (di_count == 8'd51) ? 8'd75 :

           (di_count == 8'd52) ? 8'd156 :

           (di_count == 8'd53) ? 8'd237 :

           (di_count == 8'd54) ? 8'd6 :

           (di_count == 8'd55) ? 8'd87 :

           (di_count == 8'd56) ? 8'd168 :

           (di_count == 8'd57) ? 8'd33 :

           (di_count == 8'd58) ? 8'd114 :

           (di_count == 8'd59) ? 8'd195 :

           (di_count == 8'd60) ? 8'd60 :

           (di_count == 8'd61) ? 8'd141 :

           (di_count == 8'd62) ? 8'd222 :

           (di_count == 8'd63) ? 8'd15 :

           (di_count == 8'd64) ? 8'd96 :

           (di_count == 8'd65) ? 8'd177 :

           (di_count == 8'd66) ? 8'd42 :

           (di_count == 8'd67) ? 8'd123 :

           (di_count == 8'd68) ? 8'd204 :

           (di_count == 8'd69) ? 8'd69 :

           (di_count == 8'd70) ? 8'd150 :

           (di_count == 8'd71) ? 8'd231 :

           (di_count == 8'd72) ? 8'd24 :

           (di_count == 8'd73) ? 8'd105 :

           (di_count == 8'd74) ? 8'd186 :

           (di_count == 8'd75) ? 8'd51 :

           (di_count == 8'd76) ? 8'd132 :

           (di_count == 8'd77) ? 8'd213 :

           (di_count == 8'd78) ? 8'd78 :

           (di_count == 8'd79) ? 8'd159 :

           (di_count == 8'd80) ? 8'd240 :

           (di_count == 8'd81) ? 8'd1 :

           (di_count == 8'd82) ? 8'd82 :

           (di_count == 8'd83) ? 8'd163 :

           (di_count == 8'd84) ? 8'd28 :

           (di_count == 8'd85) ? 8'd109 :

           (di_count == 8'd86) ? 8'd190 :

           (di_count == 8'd87) ? 8'd55 :

           (di_count == 8'd88) ? 8'd136 :

           (di_count == 8'd89) ? 8'd217 :

           (di_count == 8'd90) ? 8'd10 :

           (di_count == 8'd91) ? 8'd91 :

           (di_count == 8'd92) ? 8'd172 :

           (di_count == 8'd93) ? 8'd37 :

           (di_count == 8'd94) ? 8'd118 :

           (di_count == 8'd95) ? 8'd199 :

           (di_count == 8'd96) ? 8'd64 :

           (di_count == 8'd97) ? 8'd145 :

           (di_count == 8'd98) ? 8'd226 :

           (di_count == 8'd99) ? 8'd19 :

           (di_count == 8'd100) ? 8'd100 :

           (di_count == 8'd101) ? 8'd181 :

           (di_count == 8'd102) ? 8'd46 :

           (di_count == 8'd103) ? 8'd127 :

           (di_count == 8'd104) ? 8'd208 :

           (di_count == 8'd105) ? 8'd73 :

           (di_count == 8'd106) ? 8'd154 :

           (di_count == 8'd107) ? 8'd235 :

           (di_count == 8'd108) ? 8'd4 :

           (di_count == 8'd109) ? 8'd85 :

           (di_count == 8'd110) ? 8'd166 :

           (di_count == 8'd111) ? 8'd31 :

           (di_count == 8'd112) ? 8'd112 :

           (di_count == 8'd113) ? 8'd193 :

           (di_count == 8'd114) ? 8'd58 :

           (di_count == 8'd115) ? 8'd139 :

           (di_count == 8'd116) ? 8'd220 :

           (di_count == 8'd117) ? 8'd13 :

           (di_count == 8'd118) ? 8'd94 :

           (di_count == 8'd119) ? 8'd175 :

           (di_count == 8'd120) ? 8'd40 :

           (di_count == 8'd121) ? 8'd121 :

           (di_count == 8'd122) ? 8'd202 :

           (di_count == 8'd123) ? 8'd67 :

           (di_count == 8'd124) ? 8'd148 :

           (di_count == 8'd125) ? 8'd229 :

           (di_count == 8'd126) ? 8'd22 :

           (di_count == 8'd127) ? 8'd103 :

           (di_count == 8'd128) ? 8'd184 :

           (di_count == 8'd129) ? 8'd49 :

           (di_count == 8'd130) ? 8'd130 :

           (di_count == 8'd131) ? 8'd211 :

           (di_count == 8'd132) ? 8'd76 :

           (di_count == 8'd133) ? 8'd157 :

           (di_count == 8'd134) ? 8'd238 :

           (di_count == 8'd135) ? 8'd7 :

           (di_count == 8'd136) ? 8'd88 :

           (di_count == 8'd137) ? 8'd169 :

           (di_count == 8'd138) ? 8'd34 :

           (di_count == 8'd139) ? 8'd115 :

           (di_count == 8'd140) ? 8'd196 :

           (di_count == 8'd141) ? 8'd61 :

           (di_count == 8'd142) ? 8'd142 :

           (di_count == 8'd143) ? 8'd223 :

           (di_count == 8'd144) ? 8'd16 :

           (di_count == 8'd145) ? 8'd97 :

           (di_count == 8'd146) ? 8'd178 :

           (di_count == 8'd147) ? 8'd43 :

           (di_count == 8'd148) ? 8'd124 :

           (di_count == 8'd149) ? 8'd205 :

           (di_count == 8'd150) ? 8'd70 :

           (di_count == 8'd151) ? 8'd151 :

           (di_count == 8'd152) ? 8'd232 :

           (di_count == 8'd153) ? 8'd25 :

           (di_count == 8'd154) ? 8'd106 :

           (di_count == 8'd155) ? 8'd187 :

           (di_count == 8'd156) ? 8'd52 :

           (di_count == 8'd157) ? 8'd133 :

           (di_count == 8'd158) ? 8'd214 :

           (di_count == 8'd159) ? 8'd79 :

           (di_count == 8'd160) ? 8'd160 :

           (di_count == 8'd161) ? 8'd241 :

           (di_count == 8'd162) ? 8'd2 :

           (di_count == 8'd163) ? 8'd83 :

           (di_count == 8'd164) ? 8'd164 :

           (di_count == 8'd165) ? 8'd29 :

           (di_count == 8'd166) ? 8'd110 :

           (di_count == 8'd167) ? 8'd191 :

           (di_count == 8'd168) ? 8'd56 :

           (di_count == 8'd169) ? 8'd137 :

           (di_count == 8'd170) ? 8'd218 :

           (di_count == 8'd171) ? 8'd11 :

           (di_count == 8'd172) ? 8'd92 :

           (di_count == 8'd173) ? 8'd173 :

           (di_count == 8'd174) ? 8'd38 :

           (di_count == 8'd175) ? 8'd119 :

           (di_count == 8'd176) ? 8'd200 :

           (di_count == 8'd177) ? 8'd65 :

           (di_count == 8'd178) ? 8'd146 :

           (di_count == 8'd179) ? 8'd227 :

           (di_count == 8'd180) ? 8'd20 :

           (di_count == 8'd181) ? 8'd101 :

           (di_count == 8'd182) ? 8'd182 :

           (di_count == 8'd183) ? 8'd47 :

           (di_count == 8'd184) ? 8'd128 :

           (di_count == 8'd185) ? 8'd209 :

           (di_count == 8'd186) ? 8'd74 :

           (di_count == 8'd187) ? 8'd155 :

           (di_count == 8'd188) ? 8'd236 :

           (di_count == 8'd189) ? 8'd5 :

           (di_count == 8'd190) ? 8'd86 :

           (di_count == 8'd191) ? 8'd167 :

           (di_count == 8'd192) ? 8'd32 :

           (di_count == 8'd193) ? 8'd113 :

           (di_count == 8'd194) ? 8'd194 :

           (di_count == 8'd195) ? 8'd59 :

           (di_count == 8'd196) ? 8'd140 :

           (di_count == 8'd197) ? 8'd221 :

           (di_count == 8'd198) ? 8'd14 :

           (di_count == 8'd199) ? 8'd95 :

           (di_count == 8'd200) ? 8'd176 :

           (di_count == 8'd201) ? 8'd41 :

           (di_count == 8'd202) ? 8'd122 :

           (di_count == 8'd203) ? 8'd203 :

           (di_count == 8'd204) ? 8'd68 :

           (di_count == 8'd205) ? 8'd149 :

           (di_count == 8'd206) ? 8'd230 :

           (di_count == 8'd207) ? 8'd23 :

           (di_count == 8'd208) ? 8'd104 :

           (di_count == 8'd209) ? 8'd185 :

           (di_count == 8'd210) ? 8'd50 :

           (di_count == 8'd211) ? 8'd131 :

           (di_count == 8'd212) ? 8'd212 :

           (di_count == 8'd213) ? 8'd77 :

           (di_count == 8'd214) ? 8'd158 :

           (di_count == 8'd215) ? 8'd239 :

           (di_count == 8'd216) ? 8'd8 :

           (di_count == 8'd217) ? 8'd89 :

           (di_count == 8'd218) ? 8'd170 :

           (di_count == 8'd219) ? 8'd35 :

           (di_count == 8'd220) ? 8'd116 :

           (di_count == 8'd221) ? 8'd197 :

           (di_count == 8'd222) ? 8'd62 :

           (di_count == 8'd223) ? 8'd143 :

           (di_count == 8'd224) ? 8'd224 :

           (di_count == 8'd225) ? 8'd17 :

           (di_count == 8'd226) ? 8'd98 :

           (di_count == 8'd227) ? 8'd179 :

           (di_count == 8'd228) ? 8'd44 :

           (di_count == 8'd229) ? 8'd125 :

           (di_count == 8'd230) ? 8'd206 :

           (di_count == 8'd231) ? 8'd71 :

           (di_count == 8'd232) ? 8'd152 :

           (di_count == 8'd233) ? 8'd233 :

           (di_count == 8'd234) ? 8'd26 :

           (di_count == 8'd235) ? 8'd107 :

           (di_count == 8'd236) ? 8'd188 :

           (di_count == 8'd237) ? 8'd53 :

           (di_count == 8'd238) ? 8'd134 :

           (di_count == 8'd239) ? 8'd215 :

           (di_count == 8'd240) ? 8'd80 :

           (di_count == 8'd241) ? 8'd161 :

           (di_count == 8'd242) ? 8'd242 :
           8'd0;

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
            done<=counter==242;
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