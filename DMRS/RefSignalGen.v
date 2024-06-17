module RefSignalGen #(
    parameter WIDTH = 9
    )(
	input clk,
	input reset,
	input [9:0] Mzc,
	input [4:0] u,
	input v,
	input [9:0] prime,
	input [29:0] prime_rec,
	input [1:0] phi1_value,
	input [1:0] phi2_value,
	input [1:0] phi3_value,
	input [1:0] phi4_value,
	input signed [WIDTH-1:0] sin_value,
	input signed [WIDTH-1:0] cos_value,
	output reg [9:0] counter,
	output reg [14:0] phase,
	output wire signed [WIDTH-1:0] DMRS_r,
	output wire signed [WIDTH-1:0] DMRS_i,
	output reg DMRS_valid,
	output reg finished
);

// Step Calculations for zadoff-chu sequence
reg [25:0] step;
reg [43:0] step_first;
reg [25:0] step_init;
reg [25:0] step_next;
reg [14:0] phase_next;

// For q and Nzc Calculations
reg [34:0] mult; 
reg [14:0] q_dash;
reg [14:0] q_dash_half;
reg [9:0] q;
reg [9:0] Nzc;
reg [33:0] Nzc_rec;

// Finished signal
// reg finished;
//assign finished = (counter == Mzc) ? 1 : 0;

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
				step_first = q * Nzc_rec; // Q10.0*Q0.34 = Q10.34 -> Q0.26
				step_init = step_first[33:08] + step_first[7]; // rounding the first step
			end
		
		//  Calculating the initial step for Mzc = 30		
		else
			begin
				step_first = 44'b0;
				step_init = {step_init[19:0], 6'b000000}; // Q5.20 -> Q0.20 + Q0.5 -> Q0.25
			end
			
	end

// Sequential block
always@(posedge clk or negedge reset)
	begin
		if (!reset)
			begin
				DMRS_valid <= 1'b0;
				counter <= 10'b0;
				step <= 26'b0;
        		phase <= 15'b0;
				finished <= 1'b0;
			end
		
		else if (counter == Mzc)
			begin
				DMRS_valid <= 1'b0;
				// counter <= 10'b0;
				step <= 26'b0;
        		phase <= 15'b0;
				finished <= 1'b1;
			end

		else if (!finished)
			begin
				DMRS_valid <= 1'b1;
				counter <= counter + 1;
				step <= step_next;
        		phase <= phase_next;
				finished <= 1'b0;
			end
			
		else
			begin
				DMRS_valid <= 1'b0;
				counter <= 10'b0;
				step <= 26'b0;
        		phase <= 15'b0;
				finished <= 1'b0;
			end
		end
		
// DM-RS Calculations
always@(*)
	begin
		// Assign the next state values
		step_next = step;
    	phase_next = phase;

		if (Mzc >= 'd36) begin
			if ((counter == 0) || (counter == Nzc)) begin
				step_next = 26'b0;
				phase_next = 15'b0;
			end 
			
			else begin
				step_next = step + step_init; // Q0.26+Q0.26 = Q0.27 -> rounding to Q0.26
				phase_next = phase + step_next[25:11] + step_next[10]; // phase rounding
			end
		end 

		else if (Mzc == 'd30) 
		begin
			if (counter == 0) begin
				step_next = step_init;
				phase_next = step_next[25:11] + step_next[10];
			end 
			
			else begin
				step_next = step + step_init; // Q0.26+Q0.26 = Q0.27 -> rounding to Q0.26
				phase_next = phase + step_next[25:11] + step_next[10]; // phase rounding
			end
		end 
		
		else begin
			step_next = 26'b0;
			case (Mzc)
				6   : phase_next = {phi1_value, 13'b1000000000000};

				12  : phase_next = {phi2_value, 13'b1000000000000};

				18  : phase_next = {phi3_value, 13'b1000000000000};

				24  : phase_next = {phi4_value, 13'b1000000000000};

				default : phase_next = 13'b0; // In case of unavailable sequence length
			endcase
			
			// In case of +ve phi the shift already does not matter since there are 2 integer bits
			// and 1 sign bit which equals to zero
			
			// In case of -ve phi, we need to calculate the 2s complement to wrap the -ve value
			if (phase_next[14]) begin
				phase_next[13:0] = phase_next[13:0] >> 1; // Correct value of phase
				phase_next = ~phase_next + 1'b1; // Twos complement to get the -ve values correct
				phase_next = phase_next << 1; // Get rid of sign bit
			end
		end

		

	end
endmodule