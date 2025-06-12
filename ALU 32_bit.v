`timescale 1ns / 1ps

// ALU module supporting add, sub, and, or, slt operations
module ALU_32bit(
    input [31:0] A,       // 32-bit input operand A
    input [31:0] B,       // 32-bit input operand B
    input [3:0] ALUControl,  // Control signal for operation selection
    output [31:0] Result,   // 32-bit output result
    output Zero            // 1 if Result is zero, 0 otherwise
);
    wire [31:0] B_modified;
    wire [31:0] add_result, and_result, or_result, slt_result;
    wire [31:0] not_B;
    wire cin;
    wire cout;
    wire set;
    
    // NOT operation on B for subtraction
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: not_gen
            not(not_B[i], B[i]);
        end
    endgenerate
    
    // Select B or ~B based on ALUControl
    assign cin = (ALUControl[2] == 1'b1) ? 1'b1 : 1'b0; // 1 for subtraction
    mux2x1_32bit mux_b_sel (.y(B_modified), .a(B), .b(not_B), .sel(ALUControl[2]));
    
    // Adder for add and subtract operations
    thirtytwo_bit_adder adder(.S(add_result), .C32(cout), .A(A), .B(B_modified), .Cin(cin));
    
    // AND operation
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin: and_gen
            and(and_result[j], A[j], B[j]);
        end
    endgenerate
    
    // OR operation
    genvar k;
    generate
        for (k = 0; k < 32; k = k + 1) begin: or_gen
            or(or_result[k], A[k], B[k]);
        end
    endgenerate
    
    // SLT operation (Set if Less Than)
    // SLT sets result to 1 if A < B (signed comparison), else 0
    assign set = add_result[31]; // Sign bit of subtraction result
    assign slt_result = {31'b0, set};
    
    // MUX to select final result based on ALUControl
    wire [31:0] temp_result1, temp_result2;
    mux2x1_32bit mux_result1 (.y(temp_result1), .a(and_result), .b(or_result), .sel(ALUControl[0]));
    mux2x1_32bit mux_result2 (.y(temp_result2), .a(add_result), .b(slt_result), .sel(ALUControl[0]));
    mux2x1_32bit mux_result_final (.y(Result), .a(temp_result1), .b(temp_result2), .sel(ALUControl[1]));
    
    // Zero flag
    wire [31:0] or_stages[4:0];
    
    // First stage - OR gates for every 2 bits
    genvar m;
    generate
        for (m = 0; m < 16; m = m + 1) begin: zero_stage1
            or(or_stages[0][m], Result[2*m], Result[2*m + 1]);
        end
    endgenerate
    
    // Second stage - OR gates for every 2 results from first stage
    genvar n;
    generate
        for (n = 0; n < 8; n = n + 1) begin: zero_stage2
            or(or_stages[1][n], or_stages[0][2*n], or_stages[0][2*n + 1]);
        end
    endgenerate
    
    // Third stage
    genvar p;
    generate
        for (p = 0; p < 4; p = p + 1) begin: zero_stage3
            or(or_stages[2][p], or_stages[1][2*p], or_stages[1][2*p + 1]);
        end
    endgenerate
    
    // Fourth stage
    genvar q;
    generate
        for (q = 0; q < 2; q = q + 1) begin: zero_stage4
            or(or_stages[3][q], or_stages[2][2*q], or_stages[2][2*q + 1]);
        end
    endgenerate
    
    // Final stage
    or(or_stages[4][0], or_stages[3][0], or_stages[3][1]);
    
    // Invert to get Zero flag
    not(Zero, or_stages[4][0]);
endmodule