# ==============================================================================
# RISC-V RV32I Workshop Demonstration Program
# ==============================================================================
# Description:
#   This program demonstrates key features of the RV32I instruction set:
#     1. Register initialization with immediate values (ADDI)
#     2. Arithmetic & logical operations (ADD, SUB, AND, OR, XOR, SLLI, SRLI)
#     3. Data memory access (SW, LW)
#     4. Loop execution using conditional branch (BNE)
#     5. Upper immediate loading (LUI)
#     6. Unconditional jumping (JAL)
#     7. Final verification flag (x15 = 1)
# ==============================================================================

.text
.globl _start

_start:
    # 1. Initialize Operands
    addi x1, x0, 15          # PC 0x00: x1 = 15 (0x0F)
    addi x2, x0, 25          # PC 0x04: x2 = 25 (0x19)

    # 2. Arithmetic & Logic Operations
    add  x3, x1, x2          # PC 0x08: x3 = 15 + 25 = 40 (0x28)
    sub  x4, x2, x1          # PC 0x0C: x4 = 25 - 15 = 10 (0x0A)
    and  x5, x1, x2          # PC 0x10: x5 = 15 & 25 = 9  (0x09)
    or   x6, x1, x2          # PC 0x14: x6 = 15 | 25 = 31 (0x1F)
    xor  x7, x1, x2          # PC 0x18: x7 = 15 ^ 25 = 22 (0x16)

    # 3. Shift Operations
    slli x8, x1, 2           # PC 0x1C: x8 = 15 << 2 = 60 (0x3C)
    srli x9, x2, 1           # PC 0x20: x9 = 25 >> 1 = 12 (0x0C)

    # 4. Data Memory Access
    sw   x3, 4(x0)           # PC 0x24: Memory[4] = x3 (40)
    lw   x10, 4(x0)          # PC 0x28: x10 = Memory[4] = 40 (0x28)

    # 5. Loop (Sum 1 to 5)
    addi x11, x0, 0          # PC 0x2C: sum = 0
    addi x12, x0, 5          # PC 0x30: count = 5

loop:
    add  x11, x11, x12       # PC 0x34: sum += count
    addi x12, x12, -1        # PC 0x38: count--
    bne  x12, x0, loop       # PC 0x3C: branch to loop if count != 0 (target PC 0x34)
                             # After loop: x11 = 5 + 4 + 3 + 2 + 1 = 15 (0x0F)

    # 6. Upper Immediate
    lui  x13, 0x12345        # PC 0x40: x13 = 0x12345000

    # 7. Jump Over Instruction
    jal  x14, skip_target    # PC 0x44: jump to skip_target (target PC 0x4C), x14 = PC+4 (0x48)
    addi x15, x0, 99         # PC 0x48: [SKIPPED]

skip_target:
    addi x15, x0, 1          # PC 0x4C: x15 = 1 (SUCCESS FLAG)

halt:
    beq  x0, x0, halt        # PC 0x50: Infinite loop / halt
