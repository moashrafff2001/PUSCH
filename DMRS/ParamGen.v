module ParamGen (
	input clk,
	input reset,
	input enable,
	input [3:0] N_slot_frame,
	input [9:0] n_ID,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	input c,
	output wire [9:0] Mzc,
	output reg [4:0] u,
	output reg v,
	output reg enable_gen
);

assign Mzc = 6 * N_rb;

reg [7:0] f_gh;
reg [7:0] power;
reg [10:0] counter;
reg [7:0] c_catch;

integer i, j, k;

parameter [3:0] N_symb_slot = 14;

localparam [1:0] all_dis = 2'd0,
				 gh_en = 2'd1,
				 sh_en = 2'd2;

wire seq_hop_flag, grp_hop_flag;

assign grp_hop_flag = (counter >= 8*(N_symb_slot*N_slot_frame)) && (counter <= 8*(N_symb_slot*N_slot_frame) + 7) ? 1 : 0;
assign seq_hop_flag = (counter == (N_symb_slot*N_slot_frame)) ? 1 : 0;


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

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		counter <= 11'b0;
		c_catch <= 7'b0;
		k <= 0;
		enable_gen <= 0;
	end 

	else if (enable) begin
		// When the stream of bits (from gold sequence generator) meets the required indices
		// In case of group hopping is enabled
		if (grp_hop_flag) begin
			counter <= counter + 1;
			c_catch[k] <= c;
			k <= k + 1;
			enable_gen <= 0;
		end

		// In case of sequence hopping is enabled
		else if (seq_hop_flag) begin
			counter <= counter + 1;
			c_catch[0] <= c;
			k <= 0;
			enable_gen <= 0;
		end

		// In case of neither is enabled
		else begin
			counter <= counter + 1;
			k <= 0;
			enable_gen <= 0;
		end
	end

	// Parameters generation is done and enabling DMRS generation
	else begin
		counter <= 11'b0;
		k <= 0;
		enable_gen <= 1;
	end
end

// Operation on generated gold sequence to obtain u and v
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
						if (c_catch[i])
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
				v = c_catch[0];
			end

			default : begin
				f_gh = 7'b0;
				v = 1'b0;
			end
			
		endcase
		
		u = mod30(f_gh + n_ID);
	end

endmodule
