`timescale 1ns / 1ps

// PC Register
module ProgramCounter(
    input clk, reset,
    input [31:0] PC_next,
    output reg [31:0] PC
);
    // Initialize PC
    initial begin
        PC = 32'b0;
    end
    
    always @(posedge clk) begin
        if (reset)
            PC <= 32'b0;
        else
            PC <= PC_next;
    end
endmodule