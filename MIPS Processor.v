`timescale 1ns / 1ps

// Top-level module for MIPS processor
module MIPS_Processor(
    input clk, reset,
    // Memory initialization interfaces (exposed for testbench)
    input instr_write_enable,
    input [7:0] instr_write_addr,
    input [31:0] instr_write_data,
    input data_init_write_enable,
    input [7:0] data_init_addr,
    input [31:0] data_init_data,
    // Register values for debugging
    output [31:0] RegValue0, RegValue1, RegValue2, RegValue3,
    output [31:0] RegValue4, RegValue5, RegValue6, RegValue7,
    output [31:0] RegValue8, RegValue9, RegValue10, RegValue11,
    output [31:0] RegValue12, RegValue13, RegValue14, RegValue15,
    output [31:0] RegValue16, RegValue17, RegValue18, RegValue19,
    output [31:0] RegValue20, RegValue21, RegValue22, RegValue23,
    output [31:0] RegValue24, RegValue25, RegValue26, RegValue27,
    output [31:0] RegValue28, RegValue29, RegValue30, RegValue31
);
    // Internal wires
    wire [5:0] Opcode;
    wire Zero;
    
    // Control signals
    wire RegDst, Jump, Branch, MemRead, MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite, ALUSrc, RegWrite, JALFlag;
    
    // Control Unit
    Control control(
        .Opcode(Opcode),
        .RegDst(RegDst), .Jump(Jump), .Branch(Branch),
        .MemRead(MemRead), .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .JALFlag(JALFlag)
    );
    
    // Datapath
    Datapath datapath(
        .clk(clk), .reset(reset),
        .RegDst(RegDst), .Jump(Jump), .Branch(Branch),
        .MemRead(MemRead), .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .JALFlag(JALFlag),
        .Opcode(Opcode),
        .Zero(Zero),
        .instr_write_enable(instr_write_enable),
        .RegValue0(RegValue0), .RegValue1(RegValue1), .RegValue2(RegValue2), .RegValue3(RegValue3),
        .RegValue4(RegValue4), .RegValue5(RegValue5), .RegValue6(RegValue6), .RegValue7(RegValue7),
        .RegValue8(RegValue8), .RegValue9(RegValue9), .RegValue10(RegValue10), .RegValue11(RegValue11),
        .RegValue12(RegValue12), .RegValue13(RegValue13), .RegValue14(RegValue14), .RegValue15(RegValue15),
        .RegValue16(RegValue16), .RegValue17(RegValue17), .RegValue18(RegValue18), .RegValue19(RegValue19),
        .RegValue20(RegValue20), .RegValue21(RegValue21), .RegValue22(RegValue22), .RegValue23(RegValue23),
        .RegValue24(RegValue24), .RegValue25(RegValue25), .RegValue26(RegValue26), .RegValue27(RegValue27),
        .RegValue28(RegValue28), .RegValue29(RegValue29), .RegValue30(RegValue30), .RegValue31(RegValue31),
        .data_init_write_enable(data_init_write_enable),
        .data_init_addr(data_init_addr),
        .data_init_data(data_init_data)
    );
endmodule
