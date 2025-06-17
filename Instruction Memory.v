`timescale 1ns / 1ps

module InstructionMemory(
    input [31:0] PC,
    output [31:0] Instruction
);
    reg [31:0] memory [255:0]; 
    

    wire [7:0] word_addr = PC[9:2];
    

    assign Instruction = memory[word_addr];
        initial begin
        // Load n from memory[0] 
//        memory[0] = 32'b100011_00000_00010_0000000000000000; // lw $2, 0($0) ; n
//         memory[1] = 32'b000000_00000_00000_00011_00000_100000; // add $3, $0, $0 ; first = 0 
//         memory[2] = 32'b000000_00000_00001_00100_00000_100000; // add $4, $0, $1 ; second = 1 (use $1 as temp) 
//         memory[3] = 32'b000000_00000_00000_00110_00000_100000; // add $6, $0, $0 ; counter = 0 // Label: loop
//          memory[4] = 32'b101011_00001_00011_0000000000000010; // sw $3, 2($1) ; store first
          
//           memory[5] = 32'b000000_00011_00100_00101_00000_100000; // add $5, $3, $4 ; next = first + second
//            memory[6] = 32'b000000_00100_00000_00011_00000_100000; // add $3, $4, $0 ; first = second 
//            memory[7] = 32'b000000_00101_00000_00100_00000_100000; // add $4, $5, $0 ; second = next
//             memory[8] = 32'b000000_00110_00001_00110_00000_100000; // add $6, $6, $1 ; counter += 1 
//             memory[9] = 32'b000000_00110_00000_00111_00000_100000; // add $7, $6, $0 ; temp = counter 
//             memory[10] = 32'b000000_00111_00010_00111_00000_101010; // slt $7, $7, $2 ; if counter < n
//              memory[11] = 32'b101011_00000_00100_0000000110010000; // sw $4, 400($0)
//               memory[12] = 32'b000100_00111_00001_1111111111111000; // be $7, $1, -8 ; branch to loop (PC-relative)
//                memory[13] = 32'b000100_00000_00000_1111111111111111; // beq $0, $0, loop (offset = -1) loop at done

memory[0] = 32'b100011_00000_00010_0000000000000000; // lw $2, 0($0)      ; Load n from memory address 0
memory[1] = 32'b000000_00000_00000_00011_00000_100000; // add $3, $0, $0   ; first = 0
memory[2] = 32'b000000_00000_00001_00100_00000_100000; // add $4, $0, $1   ; second = 1 (use $1 as temp = 1)
memory[3] = 32'b000000_00000_00000_00110_00000_100000; // add $6, $0, $0   ; counter = 0
// Loop:
memory[4] = 32'b101011_00001_00011_0000000000000010; // sw $3, 2($1)      ; Store first at address = 1+2=3
memory[5] = 32'b000000_00011_00100_00101_00000_100000; // add $5, $3, $4   ; next = first + second
memory[6] = 32'b000000_00100_00000_00011_00000_100000; // add $3, $4, $0   ; first = second
memory[7] = 32'b000000_00101_00000_00100_00000_100000; // add $4, $5, $0   ; second = next
memory[8] = 32'b000000_00110_00001_00110_00000_100000; // add $6, $6, $1   ; counter += 1
memory[9] = 32'b000000_00110_00000_00111_00000_100000; // add $7, $6, $0   ; temp = counter
memory[10] = 32'b000000_00111_00010_00111_00000_101010; // slt $7, $7, $2  ; if counter < n
memory[11] = 32'b101011_00000_00100_0000000110010000; // sw $4, 400($0)    ; Store result at address 400
memory[12] = 32'b000100_00111_00001_1111111111111000; // beq $7, $1, -8    ; branch to loop if condition true

// Let's add more instructions to cover all required types:
memory[13] = 32'b000000_00011_00100_01000_00000_100010; // sub $8, $3, $4  ; Subtract instruction
memory[14] = 32'b000000_00101_00110_01001_00000_100100; // and $9, $5, $6  ; AND operation
memory[15] = 32'b000000_00111_01000_01010_00000_100101; // or $10, $7, $8  ; OR operation
memory[16] = 32'b000010_00000000000000000000010100; // j 20               ; Jump to instruction 20

// Adding code at address 20 (after jump)
memory[20] = 32'b000011_00000000000000000000011000; // jal 24             ; Jump and link to instruction 24
memory[21] = 32'b100011_00000_01011_0000000000000100; // lw $11, 4($0)     ; Load from another address

// Subroutine at address 24
memory[24] = 32'b101011_00000_01010_0000000000001000; // sw $10, 8($0)     ; Store in subroutine
memory[25] = 32'b000000_01001_01010_01100_00000_100000; // add $12, $9, $10 ; Calculate something
memory[26] = 32'b000000_11111_00000_11111_00000_100000; // add $31, $31, $0 ; Move return address (redundant, for illustration)
memory[27] = 32'b000000_00000_11111_00000_00000_001000; // jr $31           ; Return from subroutine

// Return point (address 22)
memory[22] = 32'b000100_00000_00000_1111111111101010; // beq $0, $0, -22   ; Loop back to start for demonstration
        end
    
endmodule