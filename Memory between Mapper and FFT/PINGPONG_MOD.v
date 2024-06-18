module PingPongMem_MOD #(
    parameter MEM_DEPTH = 1200,
    parameter DATA_WIDTH = 18
)(
    input wire CLK,
    input wire RST,
    input wire EN,

    input wire [DATA_WIDTH-1:0] data_in,
    input wire read_enable,
    input wire write_enable,
    input wire Mod_Valid_OUT ,
    input wire PINGPONG_SWITCH ,  
    input wire MOD_DONE , 
    input wire [10:0] write_addr,  // External write address input
    input wire [10:0] read_addr,   // External read address input
    output reg [DATA_WIDTH-1:0] data_out  // Output data
);

    // Memories
    
    reg [DATA_WIDTH-1:0] data_in_reg ;
    reg Mod_Valid_OUT_reg ;  
    reg signed [DATA_WIDTH-1:0] ping [0:MEM_DEPTH-1];
    reg signed [DATA_WIDTH-1:0] pong [0:MEM_DEPTH-1];

    // Memory select flag
    reg use_ping;
    integer i;
    // Memory select and reset logic
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            use_ping <= 0;
          for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                    pong[i] <= 0;
                    ping[i] <=0 ;
                end
        end else if ((EN && PINGPONG_SWITCH)  ) begin
            use_ping <= ~use_ping;
        end
    end

    // Write logic with address shift
    always @(posedge CLK) begin
        if (write_enable && Mod_Valid_OUT) begin
            if (use_ping) begin
                if (write_addr  < MEM_DEPTH+1)
                    ping[write_addr-1] <= data_in;
            end else begin
                if (write_addr< MEM_DEPTH+1)
                    pong[write_addr-1] <= data_in;
            end
        end
    end

    // Reset the other bank to zero when switching

    always @(posedge CLK) begin
         if (MOD_DONE) begin
            if(use_ping) begin 
                for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                    pong[i] <=0 ;
                end

            end
            else begin 
                for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                    ping[i] <= 0;
                end

            end       

        end   
     end
    
    // Read logic on Sym_Done signal
    always @(posedge CLK) begin
        if (read_enable) begin
            if (use_ping) begin
                data_out <= pong[read_addr];
            end else begin
                data_out <= ping[read_addr];
            end
        end
        else
            data_out <= 'b0 ; 
    end
 
    always @(posedge CLK) begin

        data_in_reg <= data_in ; 
        Mod_Valid_OUT_reg <= Mod_Valid_OUT ;
    end    
endmodule