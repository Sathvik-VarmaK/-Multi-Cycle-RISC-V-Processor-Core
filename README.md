# Multi-Cycle RISC-V Processor Core

![Language](https://img.shields.io/badge/Language-Verilog-blue.svg)
![Simulator](https://img.shields.io/badge/Simulator-ModelSim%20%7C%20QuestaSim%20%7C%20Vivado-green.svg)

This repository contains the complete Verilog source code for a 32-bit multi-cycle RISC-V processor. This project was built from the ground up as a deep dive into computer architecture, focusing on implementing a robust control unit and a datapath capable of handling data processing, memory access, and, most importantly, control flow.

It was a challenging but incredibly rewarding project that brought the core concepts of processor design to life!



---
## ## Key Features ✅

* **Multi-Cycle Architecture:** The processor uses a 5-state Finite State Machine (Fetch, Decode, Execute, Memory, Write-Back) to execute one instruction over several clock cycles, allowing for more efficient hardware usage compared to a single-cycle design.
* **RISC-V ISA Subset:** Implements a solid foundation of the RV32I instruction set, including:
    * **R-type:** `add`, `sub`
    * **I-type:** `addi`, `lw`
    * **S-type:** `sw`
    * **B-type:** `beq`
    * **J-type:** `jal`
* **Full Control Flow:** The control unit and datapath are designed to correctly handle conditional branches (`beq`) and unconditional jumps (`jal`), enabling the execution of programs with loops and basic function calls.
* **Modular Design:** The entire processor is designed with a clean separation of concerns, with distinct Verilog modules for the Control Unit, ALU, Register File, PC, and Memory systems.

---
## ## Project Structure 📁

The project files are organized into source and simulation directories for clarity.

```
My_RISCV_Project/
├── src/
│   ├── top_module.v
│   ├── control_unit.v
│   ├── register_file.v
│   ├── alu.v
│   ├── data_memory.v
│   ├── instruction_memory.v
│   ├── pc.v
│   └── imm_gen.v
│
└── sim/
    ├── program.mem
    └── tb_top.v
```

---
## ## Getting Started 🚀

To run a simulation of this processor, you'll need a Verilog simulator like ModelSim, QuestaSim, or Xilinx Vivado's simulator.

1.  **Clone the repository:**
    ```sh
    git clone <https://github.com/Sathvik-VarmaK/Multi-Cycle-RISC-V-Processor-Core.git>
    ```
2.  **Create a project** in your simulator of choice.
3.  **Add all the Verilog files** from the `src/` directory as design sources.
4.  **Add `tb_top.v`** from the `sim/` directory as a simulation source and set it as the top-level testbench.
5.  **Place `program.mem`** in the main simulation directory so it can be found by the `$readmemh` task.
6.  **Run the simulation!** In a tool like ModelSim, you can use the command `run 800 ns` in the transcript to execute the testbench.

---
## ## Sample Program

The included test program (`program.mem`) tests the control flow logic by running a simple countdown loop.

```verilog
// program.mem
// A program to count down from 3 to 0 using a branch.
// Instructions are in 32-bit hexadecimal format.

// Address 0:  addi x5, x0, 3      (x5 = 3, our loop counter)
00300293
// Address 4:  addi x6, x0, 0      (x6 = 0, our loop exit condition)
00000313
// Address 8 (LOOP_START):
// Address 8:  beq x5, x6, END_LOOP (jump 12 bytes if x5==x6)
00628663
// Address 12: addi x5, x5, -1     (Decrement the counter: x5 = x5 - 1)
FFF28293
// Address 16: jal x0, LOOP_START  (Jump back to address 8)
FE9FF06F
// Address 20 (END_LOOP):
// Address 20: add x7, x0, x5      (x7 should equal 0 if the loop worked)
005003B3
```
After the simulation, you can verify that register `x7` contains the value `0`.

---
