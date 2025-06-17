# MIPS Processor Implementation

This project is a Verilog-based implementation of a basic MIPS (Microprocessor without Interlocked Pipeline Stages) processor. The design aims to demonstrate the fundamental architecture and operation of a single-cycle MIPS processor, which is widely used in computer architecture education and embedded systems.

## Project Overview

- **Language:** Verilog HDL
- **Goal:** To implement the core components of a basic MIPS processor.
- **Features:**
  - Instruction Fetch, Decode, Execute, Memory, and Writeback stages in a single cycle
  - Support for a subset of the MIPS instruction set (R-type, I-type, and J-type instructions)
  - Register file, ALU, memory interface, and control unit included
  - Testbenches for simulation and verification

## MIPS Architecture Overview

MIPS is a RISC (Reduced Instruction Set Computer) architecture known for its simplicity and efficiency. The basic MIPS processor typically consists of the following components:

### 1. **Instruction Fetch**
   - Retrieves the instruction from program memory using the Program Counter (PC).

### 2. **Instruction Decode**
   - Decodes the fetched instruction to determine the operation, source and destination registers, and immediate values.

### 3. **Execution / ALU**
   - Performs arithmetic or logical operations using the Arithmetic Logic Unit (ALU).
   - Calculates addresses for memory access instructions.

### 4. **Memory Access**
   - Loads data from or stores data to memory for load/store instructions.

### 5. **Writeback**
   - Writes results back to the register file if required by the instruction.

### **Instruction Types:**
- **R-type:** Register-to-register arithmetic/logic operations (e.g., `add`, `sub`, `and`, `or`)
- **I-type:** Operations with immediate values and memory access (`lw`, `sw`, `addi`)
- **J-type:** Jump instructions for control flow changes (`j`, `jal`)

### **Pipeline (Advanced versions)**
While this project implements a basic single-cycle version, real-world MIPS processors use pipelining to improve performance by overlapping instruction execution.

## Directory Structure

- `src/` — Verilog source files for processor modules
- `testbench/` — Testbenches for verifying processor functionality
- `README.md` — Project documentation (this file)

## Running the Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/harshmalik440/MIPS-Processor.git
   ```

2. **Open the project in Vivado (Xilinx):**
   - Launch Vivado.
   - Create a new project and add all Verilog files from the `src/` directory.
   - Add the testbenches from the `testbench/` directory.
   - Set up your simulation and run it to verify functionality.
   - You can also use Vivado's implementation and synthesis tools if you wish to deploy to an FPGA.

3. **Check simulation output and logs for verification results.**

## References

- See [MIPS.pdf](./MIPS.pdf) — This was our CS224: Hardware Lab course slide.

---
