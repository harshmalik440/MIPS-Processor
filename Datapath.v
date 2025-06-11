`timescale 1ns / 1ps

// Datapath Unit with fixed JAL implementation
module Datapath(
    input clk, reset,
    // Control signals
    input RegDst, Jump, Branch, MemRead, MemtoReg, 
    input [1:0] ALUOp,
    input MemWrite, ALUSrc, RegWrite, JALFlag,
    // Outputs to Control
    output [5:0] Opcode,
    output Zero,
    // New testbench interfaces for memory initialization
    input instr_write_enable,
    output [31:0] RegValue0, RegValue1, RegValue2, RegValue3,
    output [31:0] RegValue4, RegValue5, RegValue6, RegValue7,
    output [31:0] RegValue8, RegValue9, RegValue10, RegValue11,
    output [31:0] RegValue12, RegValue13, RegValue14, RegValue15,
    output [31:0] RegValue16, RegValue17, RegValue18, RegValue19,
    output [31:0] RegValue20, RegValue21, RegValue22, RegValue23,
    output [31:0] RegValue24, RegValue25, RegValue26, RegValue27,
    output [31:0] RegValue28, RegValue29, RegValue30, RegValue31,
    input data_init_write_enable,
    input [7:0] data_init_addr,
    input [31:0] data_init_data
);
    // Internal wires
    wire [31:0] PC, PC_next, PC_plus4, PC_branch, PC_jump;
    wire [31:0] Instruction;
    wire [4:0] WriteReg_temp, WriteReg;
    wire [31:0] WriteData_temp, WriteData, ReadData1, ReadData2;
    wire [31:0] SignImm, ShiftedImm;
    wire [31:0] SrcB, ALUResult;
    wire [31:0] ReadData;
    wire [3:0] ALUControl;
    wire PCSrc;
    wire chindi, chindi2;
    
    // Extract operation code from instruction
    assign Opcode = Instruction[31:26];
    
    // PC Logic
    ProgramCounter pc_reg(.clk(clk), .reset(reset), .PC_next(PC_next), .PC(PC));
    thirtytwo_bit_adder pc_adder(.S(PC_plus4), .C32(chindi), .A(PC), .B(32'd4), .Cin(1'b0));
    
    // Branch address calculation
    wire [31:0] nextImm;
    thirtytwo_bit_adder branch_adder(.S(nextImm), .C32(chindi2), .A(PC_plus4), .B(ShiftedImm), .Cin(1'b0));
    
    // PC source multiplexer
    assign PCSrc = Branch & Zero;
    mux2x1_32bit pc_src_mux(.y(PC_branch), .a(PC_plus4), .b(nextImm), .sel(PCSrc));
    
    // Jump address calculation - concatenate PC+4[31:28] with instruction[25:0] shifted left 2
    assign PC_jump = {PC_plus4[31:28], Instruction[25:0], 2'b00};
    mux2x1_32bit jump_mux(.y(PC_next), .a(PC_branch), .b(PC_jump), .sel(Jump));
    
    // Instruction Memory
    InstructionMemory imem(
        .PC(PC), 
        .Instruction(Instruction)
    );
    

    mux2x1_5bit reg_dst_mux(.a(Instruction[20:16]), .b(Instruction[15:11]), .sel(RegDst), .y(WriteReg_temp));
    
    mux2x1_5bit jal_reg_mux(.a(WriteReg_temp), .b(5'b11111), .sel(JALFlag), .y(WriteReg));

    RegisterFile regfile(
        .clk(clk), .reset(reset),
        .RegWrite(RegWrite),
        .ReadReg1(Instruction[25:21]), .ReadReg2(Instruction[20:16]), 
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );
    
    // Register value outputs for debugging
    assign RegValue0 = regfile.registers[0];
    assign RegValue1 = regfile.registers[1];
    assign RegValue2 = regfile.registers[2];
    assign RegValue3 = regfile.registers[3];
    assign RegValue4 = regfile.registers[4];
    assign RegValue5 = regfile.registers[5];
    assign RegValue6 = regfile.registers[6];
    assign RegValue7 = regfile.registers[7];
    assign RegValue8 = regfile.registers[8];
    assign RegValue9 = regfile.registers[9];
    assign RegValue10 = regfile.registers[10];
    assign RegValue11 = regfile.registers[11];
    assign RegValue12 = regfile.registers[12];
    assign RegValue13 = regfile.registers[13];
    assign RegValue14 = regfile.registers[14];
    assign RegValue15 = regfile.registers[15];
    assign RegValue16 = regfile.registers[16];
    assign RegValue17 = regfile.registers[17];
    assign RegValue18 = regfile.registers[18];
    assign RegValue19 = regfile.registers[19];
    assign RegValue20 = regfile.registers[20];
    assign RegValue21 = regfile.registers[21];
    assign RegValue22 = regfile.registers[22];
    assign RegValue23 = regfile.registers[23];
    assign RegValue24 = regfile.registers[24];
    assign RegValue25 = regfile.registers[25];
    assign RegValue26 = regfile.registers[26];
    assign RegValue27 = regfile.registers[27];
    assign RegValue28 = regfile.registers[28];
    assign RegValue29 = regfile.registers[29];
    assign RegValue30 = regfile.registers[30];
    assign RegValue31 = regfile.registers[31];
    
    // Sign extension and shift
    SignExtend signext(.in(Instruction[15:0]), .out(SignImm));
    
    // Shift left 2 for branch target
    assign ShiftedImm = {SignImm[29:0], 2'b00};
    
    // ALU logic
    ALUControl alucontrol(.ALUOp(ALUOp), .Funct(Instruction[5:0]), .ALUControl(ALUControl));
    mux2x1_32bit alu_src_mux(.y(SrcB), .a(ReadData2), .b(SignImm), .sel(ALUSrc));
    ALU_32bit alu(.A(ReadData1), .B(SrcB), .ALUControl(ALUControl), .Result(ALUResult), .Zero(Zero));
    
    // Data Memory
    DataMemory dmem(
        .clk(clk),
        .MemWrite(MemWrite), .MemRead(MemRead),
        .Address(ALUResult), .WriteData(ReadData2),
        .ReadData(ReadData),
        .init_write_enable(data_init_write_enable),
        .init_addr(data_init_addr),
        .init_data(data_init_data)
    );
    

    mux2x1_32bit mem_to_reg_mux(.y(WriteData_temp), .a(ALUResult), .b(ReadData), .sel(MemtoReg));
    

    mux2x1_32bit jal_data_mux(.y(WriteData), .a(WriteData_temp), .b(PC_plus4), .sel(JALFlag));
endmodule
