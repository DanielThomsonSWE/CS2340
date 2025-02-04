! This program executes "pow" as a test program using the LC-2200 ISA
! Check your registers ($v0) and memory to see if it is consistent with this program

main:	lea $sp, initsp                         ! initialize the stack pointer
        lw $sp, 0($sp)                          ! finish initialization

        lea $a0, BASE                           ! load base for pow
        lw $a0, 0($a0)
        lea $a1, EXP                            ! load power for pow
        lw $a1, 0($a1)
        lea $at, POW                            ! load address of pow
        
        add $t0, $zero, $zero
        add $t1, $zero, $zero
	    add $t2, $zero, $zero

        addi $t0, $t0, 1                        ! set $t0 for beq check
        addi $t1, $t1, 1                        ! set $t1 for beq check
        beq $t0, $t1, ternary1                  ! test beq
        halt

ternary1:
        add $t0, $zero, $zero
        addi $t1, $zero, 2
        addi $t2, $zero, 3
        tern $t0, $t1, $t2
        beq $t0, $t2, ternary2
        halt

ternary2:
        addi $t0, $t0, 1
        tern $t0, $t1, $t2
        beq $t0, $t1, ternary3

ternary3:
        addi $t0, $t0, -3
        tern $t0, $t1, $t2
        beq $t0, $t1, coalesce1
        halt

coalesce1:
        addi $t0, $zero, -2
        cols $t0, $t1, $t2
        beq $t0, $t1, coalesce2
        halt

coalesce2:
        addi $t1, $zero, 0
        cols $t0, $t1, $t2
        beq $t0, $t2, swap1
        halt

swap1:
        addi $t0, $zero, 3
        addi $t1, $zero, 5
        add $t2, $t0, $zero
        swap $t0, $t1
        beq $t1, $t2, swap2
        halt

swap2:
        swap $t0, $t1
        beq $t0, $t2, CALL
        halt

CALL:
        jalr $at, $ra                           ! run pow
        lea $a0, ANS                            ! load base for pow
        sw $v0, 0($a0)

        halt                                    ! stop the program here
        addi $v0, $zero, -1                     ! load a bad value on failure to halt

BASE:   .fill 2
EXP:    .fill 8
ANS:	.fill 0                                 ! should come out to 256 (BASE^EXP)

RET1:
        add $v0, $zero, $zero                   ! return a value of 0
        addi $v0, $v0, 1                        ! increment and return 1
        beq $zero, $zero, FIN                   ! unconditional branch to FIN

RET0:
        add $v0, $zero, $zero                   ! return a value of 0
        beq $zero, $zero, FIN                   ! unconditional branch to FIN

POW:    addi $sp, $sp, -1                       ! allocate space for old frame pointer
        sw $fp, 0($sp)                          ! save frame ptr on the stack
        addi $fp, $sp, 0                        ! set new frame pointer

BASECHK:
        beq $zero, $a1, RET1                    ! if the exponent is 0, return 1
        beq $zero, $a0, RET0                    ! if the base is 0, return 0

WORK:
        addi $a1, $a1, -1                       ! decrement the power

        lea $at, POW                            ! load the address of POW
        addi $sp, $sp, -2                       ! push 2 slots onto the stack
        sw $ra, -1($fp)                         ! save RA to stack
        sw $a0, -2($fp)                         ! save arg 0 to stack
        jalr $at, $ra                           ! recursively call POW
        add $a1, $v0, $zero                     ! store return value in arg 1
        lw $a0, -2($fp)                         ! load the base into arg 0

        lea $at, MULT                           ! load the address of MULT
        jalr $at, $ra                           ! multiply arg 0 (base) and arg 1 (running product)
        lw $ra, -1($fp)                         ! load RA from the stack
        addi $sp, $sp, 2                        ! pop RA & arg 0 of the stack

FIN:	lw $fp, 0($fp)                          ! restore old frame pointer
        addi $sp, $sp, 1                        ! pop off the stack
        jalr $ra, $zero

MULT:   add $v0, $zero, $zero                   ! return value = 0
        addi $t0, $zero, 0                      ! sentinel = 0

AGAIN:  add $v0, $v0, $a0                       ! return value += argument0
        addi $t0, $t0, 1                        ! increment sentinel
        beq $t0, $a1, RET                       ! while argument != sentinel ...
        beq $zero, $zero, AGAIN                  ! loop again

RET:
        jalr $ra, $zero                         ! return from mult

initsp: .fill 0xA000
