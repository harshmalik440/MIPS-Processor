`timescale 1ns / 1ps

// Basic gate-level components (keeping the same style as provided code)
module mux2x1_gate_level (a,b,sel,y);
    input a, b; // Data inputs
    input sel; // Selection input
    output y; // Output

    assign y = sel ? b:a; // Output from the OR gate
endmodule 

module mux2x1_5bit (a,b,sel,y);
    input[4:0] a, b; // Data inputs
    input sel; // Selection input
    output[4:0] y; // Output

    assign y = sel ? b:a; // Output from the OR gate
endmodule 

// 32-bit 2:1 MUX
module mux2x1_32bit (y, a, b, sel);
    input [31:0] a;
    input [31:0] b;
    input sel;
    output [31:0] y;

    // Gate-level implementation of the 32-bit multiplexer
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: mux_gen
            mux2x1_gate_level mux_inst(.a(a[i]), .b(b[i]), .sel(sel), .y(y[i]));
        end
    endgenerate
endmodule

// Half adder at gate level
module halfadder (S, C, x, y);
    input x, y;
    output S, C;
    xor (S, x, y);
    and (C, x, y);
endmodule

// Full adder at gate level
module fulladder (S, C, x, y, z);
    input x, y, z;
    output S, C;
    wire S1, D1, D2;
    halfadder HA1 (S1, D1, x, y);
    halfadder HA2 (S, D2, S1, z);
    or g1 (C, D2, D1);
endmodule

// 32-bit adder
module thirtytwo_bit_adder (S, C32, A, B, Cin);
    input [31:0] A, B;
    input Cin;
    output [31:0] S;
    output C32;
    wire [31:0] C;
    // First full adder with carry-in
    fulladder FA0 (S[0], C[0], A[0], B[0], Cin);
    
    // Generate the remaining full adders
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin: adder_gen
            fulladder FA (S[i], C[i], A[i], B[i], C[i-1]);
        end
    endgenerate
    
    assign C32 = C[31]; // Final carry out
endmodule