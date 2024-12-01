
# ICS3203-CAT2-Assembly-Muchiri-Elvis-Mwitari-146497

## Tasks

### Task 1 - Control Flow and Conditional Logic (6 Marks)
- The program classifies user input as either POSITIVE, NEGATIVE, or ZERO.

```bash
cd Task1
nasm -f elf32 task1.asm -o task1.o -g
ld -m elf_i386 task1.o -o task1
./task1
```

- After running the commands above, you are prompted to enter a number.
  - If you enter a negative number, the program returns "NEGATIVE" as output in the terminal.
  - If you enter a positive number (greater than zero), the program returns "POSITIVE" as the output in the terminal.
  - If you enter zero, the program returns "ZERO" as the output in the terminal.

#### Documentation Requirement: Jump Instructions Explanation
1. **jne parse_digits**  
   This instruction is used to jump to `parse_digits` if the first character is not a `-`. It checks whether the number is negative, and if it isn't, the program continues by parsing the digits directly.

2. **je finalize_conversion**  
   If the end of the string (null terminator) is reached, this jump moves to the final conversion step where the number stored in `eax` is finalized.

3. **jmp parse_loop**  
   This jump ensures that the program continues parsing the digits until the entire string is processed.

4. **je zero_case**  
   If the final number in `eax` is zero (after comparison with `0`), this jump leads the program to display the "ZERO" message.

5. **jl negative_case**  
   If the value in `eax` is less than `0` (negative), the program jumps to display the "NEGATIVE" message.

6. **jmp positive_case**  
   If the number is positive (greater than `0`), this jump directs the program to display the "POSITIVE" message.

---

### Task 2 - Array Manipulation with Looping and Reversal (6 Marks)
## Overview:
This program takes an array of integers as input, reverses it directly in memory, and displays the reversed array.

## Key Features:
- Reverses the array by swapping elements at mirrored positions within a loop.
- Operates entirely in-place, eliminating the need for extra memory.
- Comprehensive code comments provide insights into memory operations and loop mechanics for better understanding.

## Compilation and Execution:
```bash
cd Task2
nasm -f elf32 task2.asm -o task2.o
ld -m elf_i386 task2.o -o task2
./task2
```

---

### Task 3 - Modular Program with Subroutines for Factorial Calculation (4 Marks)
For this task, the program calculates the factorial of the user input using a recursive subroutine.

```bash
cd Task3
nasm -f elf32 task3.asm -o task3.o -g
ld -m elf_i386 task3.o -o task3
./task3
```

- When you run the commands above, you are prompted to enter a number, and the program returns the factorial of that input.

#### Documentation Requirement
##### 1. Register Management
- **eax**: Holds the result of operations like the user input (converted to integer), factorial calculation, and during number printing.
- **ebx**: Used to hold the file descriptor (`1` for `stdout` in system calls).
- **ecx**: Used for loop counters, string addresses, and system call parameters.
- **edx**: Used for division (`div` instruction) and for printing numbers.
- **esi**: Points to the input string and manages the current position during conversion.
- **ebp**: Manages the stack frame in function calls.

##### 2. Preserving and Restoring Values on Stack
- **factorial_calc**: Saves the value of `eax` onto the stack using `push eax` and restores it using `add esp, 4`.
- **print_number**: Sets up the stack frame by pushing `ebp` and preserves register values.

##### 3. Subroutines
- **factorial_calc**: Computes the factorial of the input number. The value in `eax` is updated with the result.
- **print_number**: Converts the factorial result back to a string and prints it.

---

### Task 4 - Data Monitoring and Control Using Port-Based Simulation (4 Marks)
- This task simulates monitoring a sensor value and controlling motor and alarm states based on thresholds:
  - **Input ≤ 50**: Output is "Motor is OFF".
  - **51 ≤ Input < 100**: Output is "Motor is ON".
  - **Input ≥ 100**: Output is "Alarm is triggered".

```bash
cd Task4
nasm -f elf32 task4.asm -o task4.o -g
ld -m elf_i386 task4.o -o task4
./task4
```

#### Documentation Requirement
##### 1. Prompt & Input
- The program prompts the user to enter a sensor value. The value is entered as a string and converted to an integer.

##### 2. Conversion
- The ASCII string input is converted into an integer using a loop, where each digit is processed and added to the result.

##### 3. Decision Making
- The integer value is compared to thresholds:
  - **> 100**: Outputs "Alarm is triggered".
  - **51–100**: Outputs "Motor is ON".
  - **≤ 50**: Outputs "Motor is OFF".

##### 4. Memory Management
- **sensor_value**: Stores the input.
- **motor_on_msg, motor_off_msg, alarm_msg**: Store the messages displayed based on the value.

##### 5. Registers
- **eax**: Holds the converted sensor value and results of comparisons.
- **ecx, ebx, edx**: Used for system calls (printing messages).
