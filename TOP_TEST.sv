module PUSCH_Top_tb;

  // Parameters
  parameter WIDTH_IFFT = 26;
  parameter period = 10;
  // Inputs
  reg clk;
  reg reset;
  reg enable;
  reg Data_in;
  reg [1:0] base_graph;
  reg [1:0] rv_number;
  reg [3:0] process_number;
  reg [16:0] available_coded_bits;
  reg [2:0] modulation_order;
  reg [5:0] N_Rapid;
  reg [15:0] N_Rnti;
  reg [9:0] N_cell_ID;
  reg Config;
  reg [3:0] N_slot_frame;
  reg [6:0] N_rb;
  reg [1:0] En_hopping;
  reg [3:0] N_symbol;
  reg [10:0] N_sc_start;
  reg [3:0] Sym_Start_REM;
  reg [3:0] Sym_End_REM;

  // Outputs
  wire signed [WIDTH_IFFT-1:0] Data_r;
  wire signed [WIDTH_IFFT-1:0] Data_i;
  wire Data_valid;



  // Instantiate the Unit Under Test (UUT)
  PUSCH_Top #(WIDTH_IFFT) Dut (
      .clk(clk),
      .reset(reset),
      .enable(enable),
      .Data_in(Data_in),
      .base_graph(base_graph),
      .rv_number(rv_number),
      .process_number(process_number),
      .available_coded_bits(available_coded_bits),
      .modulation_order(modulation_order),
      .N_Rapid(N_Rapid),
      .N_Rnti(N_Rnti),
      .N_cell_ID(N_cell_ID),
      .Config(Config),
      .N_slot_frame(N_slot_frame),
      .N_rb(N_rb),
      .En_hopping(En_hopping),
      .N_symbol(N_symbol),
      .N_sc_start(N_sc_start),
      .Sym_Start_REM(Sym_Start_REM),
      .Sym_End_REM(Sym_End_REM),
      .Data_r(Data_r),
      .Data_i(Data_i),
      .Data_valid(Data_valid)
  );

  always #(period/2) clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 0;
    enable = 0;
    Data_in = 0;

    /*base_graph = 0;
    rv_number = 0;
    process_number = 0;
    available_coded_bits = 0;
    modulation_order = 0;
    N_Rapid = 0;
    N_Rnti = 0;
    N_cell_ID = 0;
    Config = 0;
    N_slot_frame = 0;
    N_rb = 0;
    En_hopping = 0;
    N_symbol = 0;
    N_sc_start = 0;
    Sym_Start_REM = 0;
    Sym_End_REM = 0;
	*/
    // Wait 100 ns for global reset to finish
    #(period);
    reset = 1;
    enable = 1;
    Data_in = 1;

    #(period);
	enable = 0;

	#(period*100);

    /*
    // Add stimulus here
    reset = 1;
    #10;
    reset = 0;
    #10;
    enable = 1;
    base_graph = 2'b01;
    rv_number = 2'b10;
    process_number = 4'b0001;
    available_coded_bits = 17'd1023;
    modulation_order = 3'b010;
    N_Rapid = 6'b100110;
    N_Rnti = 16'b0000111100001111;
    N_cell_ID = 10'b0000011001;
    Config = 1;
    N_slot_frame = 4'b0100;
    N_rb = 7'b0010100;
    En_hopping = 2'b01;
    N_symbol = 4'b0011;
    N_sc_start = 11'b00011000001;
    Sym_Start_REM = 4'b0001;
    Sym_End_REM = 4'b1000;

    // Apply input data sequence
    Data_in = 1'b1;
    #20;
    Data_in = 1'b0;
    #20;
    Data_in = 1'b1;
    #20;
    Data_in = 1'b0;
    
    // Wait for some time to observe the output
    #1000;

    */
    $stop;
  end


endmodule