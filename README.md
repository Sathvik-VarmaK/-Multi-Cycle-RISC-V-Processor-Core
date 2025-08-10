Multi-Cycle-RISC-V-Processor-Core
A synthesizable 32-bit multi-cycle RISC-V processor designed in Verilog. This project implements a core subset of the RV32I instruction set architecture, with a focus on demonstrating a robust control unit and datapath capable of handling data processing, memory access, and control flow instructions.


Key Features ✅
Multi-Cycle Architecture: The processor uses a 5-state Finite State Machine (FSM) — Fetch, Decode, Execute, Memory, and Write-Back — ensuring efficient hardware utilization.

RISC-V ISA Subset: Provides functional support for five fundamental instruction formats:

R-type: add, sub

I-type: addi, lw

S-type: sw

B-type: beq

J-type: jal

Robust Control Flow: The control unit and datapath are engineered to correctly handle conditional branches and unconditional jumps, enabling the execution of programs with loops and function calls.

Modular Design: The design is cleanly separated into distinct, reusable modules for the Control Unit, ALU, Register File, PC, and Memory systems, promoting clarity and ease of debugging.

Comprehensive Verification: The project includes a top-level testbench that runs a sample program to verify the control flow logic, along with individual unit tests for core components like the ALU and Register File.

