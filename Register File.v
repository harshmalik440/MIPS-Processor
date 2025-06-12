`timescale 1ns / 1ps

// Register File module (32 registers x 32 bits each)
module RegisterFile(
    input clk, reset,
    input RegWrite,
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
);
    reg [31:0] registers [31:0];
    
    initial begin  registers[0] <= 32'd0; registers[1]<=32'd1;end
   
    // Write operation
    always @(posedge clk) begin
        if (RegWrite)
            registers[WriteReg] <= WriteData;
    end
    // Read operations
    assign ReadData1 =  registers[ReadReg1];
    assign ReadData2 =  registers[ReadReg2];
endmodule