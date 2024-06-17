module round #(parameter WIDTH = 14) (
    input signed [WIDTH:0] num_in,
    output signed [WIDTH-1:0] rounded_out
);

   
    localparam [WIDTH-1:0] MIN_VALUE = -(1 << (WIDTH-1));
    localparam [WIDTH-1:0] MAX_VALUE = (1 << (WIDTH-1)) - 1;


    reg signed [WIDTH-1:0] rounded_num;

    always @* begin
        
        if (num_in[WIDTH]) begin
            // Negative number
            if (-num_in >= -MIN_VALUE) // Check if rounded value is smaller than the minimum
                rounded_num = MIN_VALUE;
            else if (num_in[0] == 1) 
                rounded_num = num_in[WIDTH:1] + 1;
            else
                rounded_num = num_in[WIDTH:1];
        end else begin
            // Positive number
            if (num_in > MAX_VALUE) begin // Check if rounded value is larger than the maximum
               $display("%t MAX",$time);
                rounded_num = MAX_VALUE;
            end
            else if (num_in[0] == 1) begin
                $display("%t +1",$time);
                rounded_num = num_in[WIDTH:1] + 1;
            end
            else begin
                $display("%t as it is",$time);
                rounded_num = num_in[WIDTH:1];
        end
        end
        
    end

   
    assign rounded_out = num_in[WIDTH-1:0];

endmodule
