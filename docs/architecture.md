# RISC-V Single-Cycle Datapath & Control Architecture

This document provides technical reference for the 32-bit RISC-V (RV32I) single-cycle core designed for the workshop.

---

## 1. Instruction Formats (RV32I)

Each RISC-V instruction is 32 bits wide, aligned on a 4-byte boundary.

```
       31      25 24  20 19  15 14  12 11       7 6       0
R-Type |  funct7 |  rs2 |  rs1 |funct3|    rd    | opcode |
I-Type |       imm[11:0]        |funct3|    rd    | opcode |
S-Type |imm[11:5]|  rs2 |  rs1 |funct3| imm[4:0] | opcode |
B-Type |12| 10:5 |  rs2 |  rs1 |funct3| 4:1 | 11 | opcode |
U-Type |             imm[31:12]                  | opcode |
J-Type |20|   10:1   | 11 |    19:12   |    rd    | opcode |
```

---

## 2. Control Unit Truth Table

| Instruction Class | Opcode (`[6:0]`) | RegWrite | ALUSrc | MemRead | MemWrite | MemToReg | Branch | Jump | ALUOp |
|:------------------|:----------------:|:--------:|:------:|:-------:|:--------:|:--------:|:------:|:----:|:-----:|
| **R-Type**        | `0110011`        |    1     |   0    |    0    |    0     |    00    |   0    |  0   |  10   |
| **I-Type (ALU)**  | `0010011`        |    1     |   1    |    0    |    0     |    00    |   0    |  0   |  10   |
| **Load (LW)**     | `0000011`        |    1     |   1    |    1    |    0     |    01    |   0    |  0   |  00   |
| **Store (SW)**    | `0100011`        |    0     |   1    |    0    |    1     |    --    |   0    |  0   |  00   |
| **Branch**        | `1100011`        |    0     |   0    |    0    |    0     |    --    |   1    |  0   |  01   |
| **JAL**           | `1101111`        |    1     |   --   |    0    |    0     |    10    |   0    |  1   |  --   |
| **JALR**          | `1100111`        |    1     |   1    |    0    |    0     |    10    |   0    |  1   |  00   |
| **LUI**           | `0110111`        |    1     |   1    |    0    |    0     |    00    |   0    |  0   |  11   |
| **AUIPC**         | `0010111`        |    1     |   1    |    0    |    0     |    00    |   0    |  0   |  00   |

---

## 3. ALU Control Truth Table

| ALUOp | funct3 | funct7[5] | Is I-Type | Selected Operation | `alu_ctrl[3:0]` |
|:-----:|:------:|:---------:|:---------:|:-------------------|:---------------:|
| `00`  |   --   |    --     |    --     | ADD                | `4'b0000`       |
| `01`  | `000`  |    --     |    --     | SUB (BEQ)          | `4'b0001`       |
| `01`  | `001`  |    --     |    --     | SUB (BNE)          | `4'b0001`       |
| `01`  | `100`  |    --     |    --     | SLT (BLT, BGE)     | `4'b1000`       |
| `01`  | `110`  |    --     |    --     | SLTU (BLTU, BGEU)  | `4'b1001`       |
| `10`  | `000`  |     0     |     0     | ADD                | `4'b0000`       |
| `10`  | `000`  |     1     |     0     | SUB                | `4'b0001`       |
| `10`  | `000`  |    --     |     1     | ADDI               | `4'b0000`       |
| `10`  | `001`  |     0     |    --     | SLL / SLLI         | `4'b0101`       |
| `10`  | `010`  |    --     |    --     | SLT / SLTI         | `4'b1000`       |
| `10`  | `011`  |    --     |    --     | SLTU / SLTIU       | `4'b1001`       |
| `10`  | `100`  |    --     |    --     | XOR / XORI         | `4'b0100`       |
| `10`  | `101`  |     0     |    --     | SRL / SRLI         | `4'b0110`       |
| `10`  | `101`  |     1     |    --     | SRA / SRAI         | `4'b0111`       |
| `10`  | `110`  |    --     |    --     | OR / ORI           | `4'b0011`       |
| `10`  | `111`  |    --     |    --     | AND / ANDI         | `4'b0010`       |
| `11`  |   --   |    --     |    --     | LUI (Pass Imm)     | `4'b1010`       |

---

## 4. Branch Evaluation Logic

Branches are resolved combinationally within the single clock cycle:

```verilog
always @(*) begin
    case (funct3)
        3'b000: take_branch = alu_zero;                                      // BEQ
        3'b001: take_branch = ~alu_zero;                                     // BNE
        3'b100: take_branch = ($signed(reg_rdata1) < $signed(reg_rdata2));   // BLT
        3'b101: take_branch = ($signed(reg_rdata1) >= $signed(reg_rdata2));  // BGE
        3'b110: take_branch = (reg_rdata1 < reg_rdata2);                     // BLTU
        3'b111: take_branch = (reg_rdata1 >= reg_rdata2);                    // BGEU
        default: take_branch = 1'b0;
    endcase
end
```
