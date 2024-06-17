module QPSk_LUT#(parameter LUT_WIDTH = 18 ) (
input wire [1:0] Bits_In , 
input wire EN_QPSK ,
output reg signed [LUT_WIDTH-1:0] QPSK_I,
output reg signed [LUT_WIDTH-1:0] QPSK_Q
);

always @(EN_QPSK) begin 
    case(Bits_In)

        2'b00: begin // Map input 00 to QPSK symbol (1, 1)
            QPSK_I =  'b0_00000001;
            QPSK_Q =  'b0_00000001;
        end
        2'b01: begin // Map input 01 to QPSK symbol (1, -1)
            QPSK_I =  'b0_00000001;
            QPSK_Q = - 'd1;
        end
        2'b10: begin // Map input 10 to QPSK symbol (-1, 1)
            QPSK_I = - 'd1;
            QPSK_Q =  'b0_00000001;
        end
        2'b11: begin // Map input 11 to QPSK symbol (-1, -1)
            QPSK_I = - 'd1;
            QPSK_Q = - 'd1;
        end
        default: begin // Default mapping to (0, 0)
            QPSK_I =  'b0_00000000;
            QPSK_Q =  'b0_00000000;
        end
    endcase
end
endmodule