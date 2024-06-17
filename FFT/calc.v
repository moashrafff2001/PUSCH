module calc(
    input [3:0] stage2,
    input [2:0] stage3,
    input [1:0] stage5,
    output reg [8:0] pow2,
    output reg [7:0] pow3,
    output reg [4:0] pow5,
    output reg [7:0] pow3x5
);
    always @* begin
        case(stage2)
            2: pow2 = 4;
            3: pow2 = 8;
            4: pow2 = 16;
            5: pow2 = 32;
            6: pow2 = 64;
            7: pow2 = 128;
            8: pow2 = 256;
            default:pow2=0;
        endcase
        case(stage3)
            1: pow3 = 3;
            2: pow3 = 9;
            3: pow3 = 27;
            4: pow3 = 81;
            5: pow3 = 243;
            default:pow3=0;
        endcase
        case(stage5)
            1: pow5 = 5;
            2: pow5 = 25;
            default:pow5=0;
        endcase
        
        if (stage5 == 0)
            pow3x5 = pow3;
        else
            pow3x5 = pow3 * pow5;
    end

endmodule