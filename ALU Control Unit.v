`timescale 1ns / 1ps

// ALU Control Unit
module ALUControl(
    input [1:0] ALUOp,
    input [5:0] Funct,
    output [3:0] ALUControl
);
    reg [3:0] aluctl;
    
    always @(*) begin
        case(ALUOp)
            2'b00: aluctl = 4'b0010; // Add (for lw/sw/addi)
            2'b01: aluctl = 4'b0110; // Subtract (for beq)
            2'b10: begin // R-type
                case(Funct)
                    6'b100000: aluctl = 4'b0010; // ADD
                    6'b100010: aluctl = 4'b0110; // SUB
                    6'b100100: aluctl = 4'b0000; // AND
                    6'b100101: aluctl = 4'b0001; // OR
                    6'b101010: aluctl = 4'b0111; // SLT
                    default:   aluctl = 4'b0000;
                endcase
            end
            default: aluctl = 4'b0000;
        endcase
    end
    
    assign ALUControl = aluctl;
endmodule

// Sign Extension module
module SignExtend(
    input [15:0] in,
    output [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule