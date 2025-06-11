`timescale 1ns / 1ps

// Control Unit with corrected JAL control signals
module Control(
    input [5:0] Opcode,
    output RegDst, Jump, Branch, MemRead, MemtoReg, 
    output [1:0] ALUOp,
    output MemWrite, ALUSrc, RegWrite, JALFlag
);
    // Main decoder for the control signals
    reg [10:0] controls; // Expanded to 11 bits to include JALFlag
    
    always @(*) begin
        case(Opcode)
            6'b000000: controls = 11'b10010001000; // R-type
            6'b100011: controls = 11'b01111000000; // LW
            6'b101011: controls = 11'b00100100000; // SW
            6'b000100: controls = 11'b00000010100; // BEQ
            6'b001000: controls = 11'b01010000000; // ADDI
            6'b000010: controls = 11'b00000000010; // J
            6'b000011: controls = 11'b00010000011; // JAL - Set RegWrite, Jump and JALFlag
            default:   controls = 11'b00000000000; // Illegal op
        endcase
    end
    
    // Assign all control signals from controls bits
    assign {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, Jump, JALFlag} = controls;
endmodule
