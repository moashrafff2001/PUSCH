module ParamGen (
	input [9:0] n_ID,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	input [7:0] c,
	output wire [9:0] Mzc,
	output reg [4:0] u,
	output reg v
);

assign Mzc = 6 * N_rb;

reg [7:0] f_gh;
reg [7:0] power;

integer i, j;
parameter [3:0] N_symb_slot = 14;

localparam [1:0] all_dis = 2'd0,
				 gh_en = 2'd1,
				 sh_en = 2'd2;

function [10:0] mod30;
    input [10:0] data;
    begin
		mod30 = data;
		// For Maximuim no. for a single mod30 operation needs 35 iteration
		for (j = 0; j < 35; j = j + 1)
			begin
				if (mod30 > 7'd29)
					mod30 = mod30 - 7'd30;
			end
    end
endfunction

always@(*)
	begin
		f_gh = 7'b0;
		power = 7'b1;
		v = 1'b0;
		
		case (En_hopping)
		
			all_dis : begin
				f_gh = 7'b0;
				v = 1'b0;
			end
			
			gh_en : begin
				for (i = 0; i < 8; i = i + 1)
					begin
						if (c[i])
							f_gh = f_gh + power;
							
						else
							f_gh = f_gh;
						
						power = power << 1;
					end
					
				f_gh = mod30(f_gh);
				v = 1'b0;
			end
			
			sh_en : begin
				f_gh = 7'b0;
				v = c[0];
			end
			
		endcase
		
		u = mod30(f_gh + n_ID);
	end

endmodule
