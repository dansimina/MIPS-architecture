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
- **Data Hazards:** Resolved using **forwarding mechanisms**.
- **Control Hazards:** Branch prediction and **stalling** implemented.
- **Structural Hazards:** Avoided by **dedicated instruction/data memory**.

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
