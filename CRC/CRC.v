module CRC #(parameter SEED = 16'h0000) 
(
  input wire CLK,          
  input wire RST,          
  input wire DATA,          
  input wire ACTIVE,       
  output reg [15:0] data_out,     
  output reg Valid, 
  output reg enable       
);

  reg [15:0] LFSR;  
  reg [4:0] count;          
  wire Feedback;  
  wire count_max;
  reg [15:0] out;
  reg dataout;

  // feedback
  assign Feedback = DATA ^ LFSR[0];
  
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      LFSR <= SEED;
      dataout <= 1'b0;
      data_out <= 'b0;
      Valid <= 1'b0;
      enable <= 1'b0;
    end 
    else if (ACTIVE) 
    begin 
      LFSR[0]  <= Feedback;
      LFSR[1]  <= LFSR[0];
      LFSR[2]  <= LFSR[1];
      LFSR[3]  <= LFSR[2];
      LFSR[4]  <= LFSR[3];
      LFSR[5]  <= LFSR[4]^ Feedback;
      LFSR[6]  <= LFSR[5];
      LFSR[7]  <= LFSR[6];
      LFSR[8]  <= LFSR[7];
      LFSR[9]  <= LFSR[8];
      LFSR[10] <= LFSR[9];
      LFSR[11] <= LFSR[10];
      LFSR[12] <= LFSR[11]^ Feedback;
      LFSR[13] <= LFSR[12];
      LFSR[14] <= LFSR[13];
      LFSR[15] <= LFSR[14];
      Valid <= 1'b0;
      enable <= 1'b1;
    end 
    else if (!count_max) 
    begin  
      dataout <= LFSR[15]; 
      LFSR[15:0] <= {LFSR[14:0],1'b0};  
      out <= {LFSR[15], out[15:1]};
      enable <= 1'b1;
      Valid <= 1'b0;
    end 
    else if (count_max) 
    begin
      Valid <= 1'b1;
      data_out <= out;
      enable <= 1'b1;
    end
    else 
    begin
      Valid <= 1'b0;
      data_out <= 'b0;
      enable <= 1'b0;
    end
  end
  
  reg counter_flag; 
  
  // counter to count the output bits to high Valid flag after finish
  always @(posedge CLK or negedge RST) begin
    if (!RST)
    begin
      count <= 5'b10000;
      counter_flag <= 0;
    end
    else if (ACTIVE)
    begin
      count <= 5'b0;
      counter_flag <= 1;
    end
    
    else if ((!count_max) && (counter_flag))
      count <= count + 5'b1;
    else if (count_max)
    begin
      count <= 0;
      counter_flag <= 0;
    end
    else
      count <= 0;
  end

  assign count_max = (count == 5'b10000);

endmodule
