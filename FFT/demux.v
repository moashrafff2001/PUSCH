module demux#(parameter WIDTH=18)(input wire sel, input wire [WIDTH-1:0] in, output wire [WIDTH-1:0] out0, output wire [WIDTH-1:0] out1);
    assign out0 = (sel == 1'b0) ? in : {WIDTH{1'b0}};
    assign out1 = (sel == 1'b1) ? in : {WIDTH{1'b0}};
endmodule