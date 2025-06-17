`timescale 1ns / 1ps

// Data Memory(will review later)
module DataMemory(
    input clk,
    input MemWrite, MemRead,
    input [31:0] Address, WriteData,
    output [31:0] ReadData,
    // New interface for direct initialization from testbench
    input init_write_enable,
    input [7:0] init_addr,
    input [31:0] init_data
);
    reg [31:0] memory [255:0]; // 256 words of 32-bit memory
    integer i;
    
    
    // Normal write operation during execution
    always @(posedge clk) begin
        if (MemWrite)
            memory[Address[9:2]] <= WriteData;
    end
    initial begin
    memory[0] = 32'd10;
    memory[1]=32'd1;
    memory[4] = 32'd100; // Some arbitrary data
    end
    
    // Read operation
    assign ReadData = MemRead ? memory[Address[9:2]] : 32'b0;
endmodule
