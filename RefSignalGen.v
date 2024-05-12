module RefSignalGen (
	input clk,
	input reset,
	input enable,
	input [9:0] Mzc,
	input [4:0] u,
	input v,
	input [9:0] prime,
	input [29:0] prime_rec,
	input [1:0] phi1_value,
	input [1:0] phi2_value,
	input [1:0] phi3_value,
	input [1:0] phi4_value,
	input signed [8:0] sin_value,
	input signed [8:0] cos_value,
	output reg [9:0] counter,
	output reg [12:0] phase,
	output wire signed [8:0] DMRS_r,
	output wire signed [8:0] DMRS_i,
	output reg DMRS_valid
);

// Step Calculations for zadoff-chu sequence
reg [24:0] step;
reg [12:0] phase_in;
reg [43:0] step_first;
reg [24:0] step_init;

// For q and Nzc Calculations
reg [34:0] mult; 
reg [14:0] q_dash;
reg [14:0] q_dash_half;
reg [9:0] q;
reg [9:0] Nzc;
reg [33:0] Nzc_rec;

// Finished signal
wire finished;
assign finished = (counter == Mzc) ? 1 : 0;

// Outputs
assign DMRS_r = cos_value;
assign DMRS_i = ((Mzc >= 'd30)&&(sin_value != 9'b000000000)) ? {(~sin_value[8]), sin_value[7:0]} : sin_value;


// Nzc and q Calculations
always@(*)
	begin
		// Nzc and its reciprocal Calculations
		Nzc = prime;
		Nzc_rec = {4'b0, prime_rec};
		
		// q Calculations
		step_init = (u + 1) * 20'b00001000010000100001; // Q5.0*Q0.20 = Q5.20
		
		mult = step_init * Nzc; // Q5.20*Q10.0 = Q15.20
		
		q_dash = mult[29:15]; // Q15.20 -> Q10.5
		q_dash_half = q_dash + 15'b000000000010000;
		
		if (q_dash[4] == 1'b0) // Checking if even
			q = q_dash_half[14:5] + v;
		
		else
			q = q_dash_half[14:5] - v;
			
		//  Calculating the initial step for zadoff-chu sequence
		if (Mzc >= 'd36)
			begin
				step_first = q * Nzc_rec; // Q10.0*Q0.34 = Q10.34 -> Q0.25
				step_init = step_first[33:09] + step_first[8]; // rounding the first step
			end
		
		//  Calculating the initial step for Mzc = 30		
		else
			begin
				step_first = 44'b0;
				step_init = {step_init[19:0], 5'b00000}; // Q5.20 -> Q0.20 + Q0.5 -> Q0.25
			end
			
	end

// Sequential block
always@(posedge clk or negedge reset)
	begin
		if (!reset)
			begin
				DMRS_valid <= 1'b0;
				phase <= 13'b0;
				counter <= 10'b0;
			end
			
		else if (enable && (!finished))
			begin
				DMRS_valid <= 1'b1;
				phase <= phase_in;
				counter <= counter + 1;
			end
			
		else
			begin
				DMRS_valid <= 1'b0;
				phase <= 13'b0;
				counter <= 10'b0;
			end
		end
		
// DM-RS Calculations
always@(*)
	begin
		if (Mzc >= 'd36)
			begin
				if ((counter == 0) || (counter == Nzc))
					begin
						step = 25'b0;
						phase_in = 13'b0;
					end
					
				else begin
					step = step + step_init; // Q0.25+Q0.25 = Q0.26 -> rounding to Q0.25
					phase_in = phase_in + step[24:12] + step[11];// phase_in rounding
				end
			end
		
		else if (Mzc == 'd30)
			begin
				if (counter == 0)
					begin
						step = step_init;
						phase_in = step[24:12] + step[11];
					end
					
				else begin
					step = step + step_init; // Q0.25+Q0.25 = Q0.26 -> rounding to Q0.25
					phase_in = phase_in + step[24:12] + step[11];// phase_in rounding
				end
			end
			
		else
			begin
				step = 25'b0;
				case (Mzc)
					6		: phase_in = {phi1_value, 11'b10000000000};

					12		: phase_in = {phi2_value, 11'b10000000000};

					18		: phase_in = {phi3_value, 11'b10000000000};

					24		: phase_in = {phi4_value, 11'b10000000000};
					
					default : phase_in = 13'b0; // In case of unavailable sequence length
				endcase
				
				// In case of +ve phi the shift already does not matter since there are 2 integer bits
				// and 1 sign bit which equals to zero
				
				// In case of -ve phi, we need to calculate the 2s complement to wrap the -ve value
				if (phase_in[12])
					begin
						phase_in[11:0] = phase_in[11:0] >> 1; // Correct value of phase_in
						phase_in = ~phase_in + 1'b1; // Twos complement to get the -ve values correct
						phase_in = phase_in << 1; // Get rid of sign bit
					end

			end

	end
endmodule