module ParamGen (
	input [3:0] N_slot_frame,
	input [9:0] N_cell_ID,
	input [6:0] N_rb,
	input [1:0] En_hopping,
	input [30:0] pseudo_sequence,
	output wire [9:0] Mzc,
	output reg [4:0] u,
	output reg v
);

assign Mzc = 6 * N_rb;

// Function for mod 31
function [4:0] mod31;
    input [10:0] data_31;
	reg [10:0] temp;
    begin
        temp = data_31;

        // Add higher 6 bits to the lower 5 bits
        temp = (temp & 31) + (temp >> 5);
        // Since the maximum value after this addition can be 62 (which is 31*2),

        // Now temp should be less than 31
        if (temp >= 31)
            temp = temp - 31;

        mod31 = temp[4:0];
    end
endfunction

// Function for mod 30
function [10:0] mod30;
    input [10:0] data_30;
	integer j;
    begin
		mod30 = data_30;
		// For Maximuim no. for a single mod30 operation needs 35 iteration
		for (j = 0; j < 35; j = j + 1)
			begin
				if (mod30 > 7'd29)
					mod30 = mod30 - 7'd30;
			end
    end
endfunction

reg [7:0] f_gh;
reg [7:0] power;
reg [10:0] counter;
reg [7:0] c_catch;

integer i, k;

parameter N_symb_slot = 14;

localparam [1:0] all_dis = 2'd0,
				 gh_en = 2'd1,
				 sh_en = 2'd2;


wire [4:0] seq_hop_catch;
assign seq_hop_catch = mod31(N_symb_slot*N_slot_frame);

wire [4:0] grp_hop_catch_1, grp_hop_catch_2, grp_hop_catch_3, grp_hop_catch_4,
		   grp_hop_catch_5, grp_hop_catch_6, grp_hop_catch_7, grp_hop_catch_8;

assign grp_hop_catch_1 = mod31(8*(N_symb_slot*N_slot_frame));
assign grp_hop_catch_2 = mod31(8*(N_symb_slot*N_slot_frame) + 1);
assign grp_hop_catch_3 = mod31(8*(N_symb_slot*N_slot_frame) + 2);
assign grp_hop_catch_4 = mod31(8*(N_symb_slot*N_slot_frame) + 3);
assign grp_hop_catch_5 = mod31(8*(N_symb_slot*N_slot_frame) + 4);
assign grp_hop_catch_6 = mod31(8*(N_symb_slot*N_slot_frame) + 5);
assign grp_hop_catch_7 = mod31(8*(N_symb_slot*N_slot_frame) + 6);
assign grp_hop_catch_8 = mod31(8*(N_symb_slot*N_slot_frame) + 7);

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
				c_catch[0] = pseudo_sequence[grp_hop_catch_1];
				c_catch[1] = pseudo_sequence[grp_hop_catch_2];
				c_catch[2] = pseudo_sequence[grp_hop_catch_3];
				c_catch[3] = pseudo_sequence[grp_hop_catch_4];
				c_catch[4] = pseudo_sequence[grp_hop_catch_5];
				c_catch[5] = pseudo_sequence[grp_hop_catch_6];
				c_catch[6] = pseudo_sequence[grp_hop_catch_7];
				c_catch[7] = pseudo_sequence[grp_hop_catch_8];

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
				v = pseudo_sequence[seq_hop_catch];
			end

			default : begin
				f_gh = 7'b0;
				v = 1'b0;
			end
			
		endcase
		
		u = mod30(f_gh + N_cell_ID);

	end

endmodule
