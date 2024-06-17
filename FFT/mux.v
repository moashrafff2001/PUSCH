module mux #(parameter WIDTH = 18) (
    input wire [WIDTH-1:0] input_0,
    input wire [WIDTH-1:0] input_1,
    input wire select,
    output wire [WIDTH-1:0] out
);
    assign out = select ? input_1 : input_0;
endmodule