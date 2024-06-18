module PingPongMem_MOD #(
    parameter MEM_DEPTH = 1200,
    parameter DATA_WIDTH = 18
)(
    input wire CLK,
    input wire RST,

    input wire [DATA_WIDTH-1:0] data_in,
    input wire [10:0] Last_addr,
    input wire write_enable,
    input wire Mod_Valid_OUT ,
    input wire PINGPONG_SWITCH ,  
    input wire MOD_DONE , 
    input wire [10:0] write_addr,  // External write address input
    output reg [DATA_WIDTH-1:0] data_out  // Output data
);

    // Memories
    
    reg signed [DATA_WIDTH-1:0] ping [0:MEM_DEPTH-1];
    reg signed [DATA_WIDTH-1:0] pong [0:MEM_DEPTH-1];
    reg [10:0] Last_indx ; 
    reg flag ; 
    // Memory select flag
    reg use_ping;
    integer i;
    // Memory select and reset logic
    
     always @(*) begin
        if (!RST) begin
            use_ping = 1;
        end else if (PINGPONG_SWITCH) begin
            use_ping = ~use_ping;
        end
    end
    
    
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
          for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                    pong[i] <= 0;
                    ping[i] <=0 ;
             end
        end 
        else if (MOD_DONE) begin
            if(use_ping) begin 
                for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                    ping[i] <=0 ;
                end

            end
            else begin 
                for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                    pong[i] <= 0;
                end

            end       

        end 
    // Write logic with address shift
        else if (write_enable && Mod_Valid_OUT) begin
            if (use_ping) begin
                if (write_addr  < MEM_DEPTH+1)
                    ping[write_addr-1] <= data_in;
            end else begin
                if (write_addr< MEM_DEPTH+1)
                    pong[write_addr-1] <= data_in;
            end
        end
    end


    // Read logic on Sym_Done signal
    always @(posedge CLK) begin
     if(! RST) begin 
          data_out <= 0 ; 
          Last_indx <= 1 ;   
     end
     else if (flag) begin
            if (use_ping) begin
                data_out <= pong[Last_indx-1];
            end else begin
                data_out <= ping[Last_indx-1];
            end
            Last_indx <= Last_indx +1 ; 
     end   else begin
            data_out <= 'b0 ;
            Last_indx <= 1 ;  
     end
    end
 
always@(posedge CLK or negedge RST) begin 
    if(!RST)
            flag = 0 ; 
    else if(MOD_DONE) begin 
            flag = 1 ; 
    end else if (Last_indx == Last_addr)  
            flag = 0 ; 

end    
endmodule
