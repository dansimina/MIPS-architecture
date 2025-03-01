# 🚀 MIPS Processor Implementation (Single-Cycle & Pipelined) - VHDL

This repository contains a **VHDL implementation** of a **MIPS processor**, featuring both **single-cycle** and **pipelined** architectures. The project is designed to execute **basic MIPS instructions**, supporting arithmetic, logic, branching, and memory access operations.

Both implementations have been **tested in simulation and on FPGA hardware** to ensure correctness.

---

## 📜 Project Overview

### 🏗️ Single-Cycle MIPS Processor
The **single-cycle** implementation executes **one instruction per clock cycle**. Each instruction progresses through the following components:

#### 🔹 **Key Components**
1. **Instruction Fetch (IF)**
   - Retrieves the instruction from memory.
   - Computes the next program counter (`PC + 4`).
   
2. **Instruction Decode (ID)**
   - Decodes the instruction and extracts registers and immediate values.
   - Controls signals for register write and branch operations.

3. **Execute (EX)**
   - Performs arithmetic and logic operations using the ALU.
   - Computes target addresses for branch instructions.

4. **Memory Access (MEM)**
   - Handles load and store instructions.
   - Implements memory read/write operations.

5. **Write-Back (WB)**
   - Writes back computed values to registers.
   - Selects between ALU result or memory data.

---

### 🚀 Pipelined MIPS Processor
The **pipelined** version divides execution into **five stages**, allowing multiple instructions to be processed simultaneously.

#### 🔹 **Pipeline Stages**
1. **Instruction Fetch (IF)**
   - Fetches instruction and increments `PC`.
   - Stores results in `REG_IF_ID`.

2. **Instruction Decode (ID)**
   - Decodes instruction, reads registers, and extends immediate values.
   - Control signals are set for the next stages.

3. **Execute (EX)**
   - ALU performs computations.
   - Determines branch conditions and computes addresses.

4. **Memory Access (MEM)**
   - Reads/writes memory as needed.
   - Stores results in `REG_EX_MEM`.

5. **Write-Back (WB)**
   - Writes computed values to registers.

#### ⚠️ **Pipeline Hazards & Handling**
Since pipelining introduces **hazards** that can disrupt execution, different strategies exist for handling them. In this project, hazards were resolved using **stall cycles**, though more efficient methods exist.

- **Data Hazards:** These occur when an instruction depends on the result of a previous instruction that has not yet completed. In this project, they were resolved using **stall cycles** (pipeline bubbles) to delay execution until data dependencies are resolved.
  - ✅ **More efficient alternative**: **Forwarding** could be used to eliminate unnecessary stalls by passing computed values directly from the ALU output back to earlier stages.

- **Control Hazards:** These occur when branch instructions modify the flow of execution. In this project, **pipeline stalls** were introduced after branches to ensure correct instruction sequencing.
  - ✅ **More efficient alternative**: **Branch prediction** could be used to guess the outcome of branches in advance, reducing stalls when predictions are correct.

- **Structural Hazards:** These happen when different instructions require the same hardware resource simultaneously. In this project, they were **avoided by performing memory reads and writes on different clock edges**, ensuring that an instruction can read from a register in one cycle while another writes to it in the next.

While techniques like **forwarding, branch prediction, and dynamic scheduling** could improve performance, the current implementation **strictly uses stalling** for simplicity and correctness in hazard resolution.

---

## 📌 Supported Instructions (VHDL Implementation)
### 🛠️ Arithmetic & Logical Instructions
| Instruction | Assembly Syntax | Operation |
|-------------|----------------|-----------|
| XOR  | `xor $d, $s, $t` | `$d = $s ^ $t` |
| ADD  | `add $d, $s, $t` | `$d = $s + $t` |
| SUB  | `sub $d, $s, $t` | `$d = $s - $t` |
| AND  | `and $d, $s, $t` | `$d = $s & $t` |
| OR   | `or $d, $s, $t` | `$d = $s | $t` |
| SRA  | `sra $d, $t, h` | `$d = $t >> h` |

### 🔀 Branch & Jump Instructions
| Instruction | Assembly Syntax | Operation |
|-------------|----------------|-----------|
| BEQ  | `beq $s, $t, offset` | Branch if `$s == $t` |
| BGTZ | `bgtz $s, offset` | Branch if `$s > 0` |
| BGEZ | `bgez $s, offset` | Branch if `$s >= 0` |
| JUMP | `j target` | Unconditional jump |

### 📥 Memory Access Instructions
| Instruction | Assembly Syntax | Operation |
|-------------|----------------|-----------|
| LW  | `lw $d, offset($s)` | Load word from memory |
| SW  | `sw $t, offset($s)` | Store word in memory |
