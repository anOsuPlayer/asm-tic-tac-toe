.section .rodata
.row: .string "%c | %c | %c\n"
.mid: .string "---------\n"

.p1: .string "X"
.p2: .string "O"

.p1v: .long 88
.p2v: .long 79

.tot1: .long 264
.tot2: .long 237

.move: .string "%d %d"
.d: .string "%d"

.play1: .string "(X) player 1's turn: "
.play2: .string "(O) player 2's turn: "

.win1: .string "(X) player 1 won!\n"
.win2: .string "(O) player 2 won!\n"

.draw: .string "draw!\n"

.invalid: .string "invalid move\n"

.section .data
.align 16
.r1:
    .long 46
    .long 46
    .long 46
.align 16
.r2:
    .long 46
    .long 46
    .long 46
.align 16
.r3:
    .long 46
    .long 46
    .long 46
.align 16

.section .text
.globl modify_table
modify_table:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp

    cmpl $2, %ecx
    jle .M0
        leaq .invalid(%rip), %rcx
        call printf
        movq $0, %rax
        jmp .M6
    .M0:
    cmpl $2, %edx
    jle .M1
        leaq .invalid(%rip), %rcx
        call printf
        movq $0, %rax
        jmp .M6
    .M1:

    cmpl $0, %ecx
    jnz .M2
        leaq .r1(%rip), %rcx
        movl (%rcx, %rdx, 4), %eax

        cmpl $46, %eax
        jz .M3
            leaq .invalid(%rip), %rcx
            call printf
            movq $0, %rax
            jmp .M6
        .M3:

        leaq .r1(%rip), %rcx
        movl %r8d, (%rcx, %rdx, 4)
        movq $1, %rax

        jmp .M6
    .M2:
    cmpl $1, %ecx
    jnz .M4
        leaq .r2(%rip), %rcx
        movl (%rcx, %rdx, 4), %eax

        cmpl $46, %eax
        jz .M5
            leaq .invalid(%rip), %rcx
            call printf
            movq $0, %rax
            jmp .M6
        .M5:

        leaq .r2(%rip), %rcx
        movl %r8d, (%rcx, %rdx, 4)
        movq $1, %rax

        jmp .M6
    .M4:
    cmpl $2, %ecx
    jnz .M6
        leaq .r3(%rip), %rcx
        movl (%rcx, %rdx, 4), %eax

        cmpl $46, %eax
        jz .M7
            leaq .invalid(%rip), %rcx
            call printf
            movq $0, %rax
            jmp .M6
        .M7:

        leaq .r3(%rip), %rcx
        movl %r8d, (%rcx, %rdx, 4)
        movq $1, %rax
    .M6:

    addq $32, %rsp
    popq %rbp
    ret

.globl place_1
place_1:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp

    leaq .play1(%rip), %rcx
    call printf
    leaq .move(%rip), %rcx
    leaq -4(%rbp), %rdx
    leaq -8(%rbp), %r8
    call scanf

    movzx -4(%rbp), %ecx
    movzx -8(%rbp), %edx
    movl .p1v(%rip), %r8d
    call modify_table

    addq $32, %rsp
    popq %rbp
    ret

.globl place_2
place_2:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp

    leaq .play2(%rip), %rcx
    call printf
    leaq .move(%rip), %rcx
    leaq -4(%rbp), %rdx
    leaq -8(%rbp), %r8
    call scanf

    movzx -4(%rbp), %ecx
    movzx -8(%rbp), %edx
    movl .p2v(%rip), %r8d
    call modify_table

    addq $32, %rsp
    popq %rbp
    ret

.globl check_win
check_win:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp

    # checking columns

    vmovdqa .r1(%rip), %xmm0
    vmovdqa .r2(%rip), %xmm1
    vmovdqa .r3(%rip), %xmm2

    vpaddd %xmm1, %xmm0, %xmm0
    vpaddd %xmm2, %xmm0, %xmm0

    vpbroadcastd .tot1(%rip), %xmm1
    vpbroadcastd .tot2(%rip), %xmm2

    vpsubd %xmm0, %xmm1, %xmm1
    vpsubd %xmm0, %xmm2, %xmm2

    pextrd $0, %xmm1, %eax
    cmpl $0, %eax
    jnz .L0
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L0:
    pextrd $1, %xmm1, %eax
    cmpl $0, %eax
    jnz .L1
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L1:
    pextrd $2, %xmm1, %eax
    cmpl $0, %eax
    jnz .L2
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L2:

    pextrd $0, %xmm2, %eax
    cmpl $0, %eax
    jnz .L3
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L3:
    pextrd $1, %xmm2, %eax
    cmpl $0, %eax
    jnz .L4
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L4:
    pextrd $2, %xmm2, %eax
    cmpl $0, %eax
    jnz .L5
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L5:

    # checking rows

    vmovdqa .r1(%rip), %xmm0
    vmovdqa .r2(%rip), %xmm1
    vmovdqa .r3(%rip), %xmm2

    movl $0, -4(%rbp)

    pextrd $0, %xmm0, %eax
    addl %eax, -4(%rbp)
    pextrd $1, %xmm0, %eax
    addl %eax, -4(%rbp)
    pextrd $2, %xmm0, %eax
    addl %eax, -4(%rbp)

    movl .tot1(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L6
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L6:
    movl .tot2(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L7
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L7:

    movl $0, -4(%rbp)

    pextrd $0, %xmm1, %eax
    addl %eax, -4(%rbp)
    pextrd $1, %xmm1, %eax
    addl %eax, -4(%rbp)
    pextrd $2, %xmm1, %eax
    addl %eax, -4(%rbp)

    movl .tot1(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L8
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L8:
    movl .tot2(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L9
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L9:

    movl $0, -4(%rbp)

    pextrd $0, %xmm2, %eax
    addl %eax, -4(%rbp)
    pextrd $1, %xmm2, %eax
    addl %eax, -4(%rbp)
    pextrd $2, %xmm2, %eax
    addl %eax, -4(%rbp)

    movl .tot1(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L10
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L10:
    movl .tot2(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L11
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L11:

    # checking diagonals

    movl $0, -4(%rbp)

    pextrd $0, %xmm0, %eax
    addl %eax, -4(%rbp)
    pextrd $1, %xmm1, %eax
    addl %eax, -4(%rbp)
    pextrd $2, %xmm2, %eax
    addl %eax, -4(%rbp)

    movl .tot1(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L12
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L12:
    movl .tot2(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L13
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L13:

    movl $0, -4(%rbp)

    pextrd $0, %xmm2, %eax
    addl %eax, -4(%rbp)
    pextrd $1, %xmm1, %eax
    addl %eax, -4(%rbp)
    pextrd $2, %xmm0, %eax
    addl %eax, -4(%rbp)

    movl .tot1(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L14
        leaq .win1(%rip), %rcx
        call printf
        movq $1, %rax
        jmp .QUIT
    .L14:
    movl .tot2(%rip), %eax
    cmpl -4(%rbp), %eax
    jnz .L15
        leaq .win2(%rip), %rcx
        call printf
        movq $2, %rax
        jmp .QUIT
    .L15:

    movq $0, %rax

    .QUIT:
    addq $32, %rsp
    popq %rbp
    ret

.globl print_table
print_table:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp

    # printing table

    movl $0, %edi
    leaq .r1(%rip), %rsi

    leaq .row(%rip), %rcx
    movb (%rsi, %rdi, 4), %dl
    incl %edi
    movb (%rsi, %rdi, 4), %r8b
    incl %edi
    movb (%rsi, %rdi, 4), %r9b
    call printf

    movl $0, %edi
    leaq .r2(%rip), %rsi

    leaq .row(%rip), %rcx
    movb (%rsi, %rdi, 4), %dl
    incl %edi
    movb (%rsi, %rdi, 4), %r8b
    incl %edi
    movb (%rsi, %rdi, 4), %r9b
    call printf

    movl $0, %edi
    leaq .r3(%rip), %rsi

    leaq .row(%rip), %rcx
    movb (%rsi, %rdi, 4), %dl
    incl %edi
    movb (%rsi, %rdi, 4), %r8b
    incl %edi
    movb (%rsi, %rdi, 4), %r9b
    call printf

    leaq .mid(%rip), %rcx
    call printf

    addq $32, %rsp
    popq %rbp
    ret

.globl main
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $64, %rsp

    movl $0, -4(%rbp)

    .main_loop:
        call print_table

        .print_loop_1:
            call place_1
        cmpq $1, %rax
        jnz .print_loop_1

        leaq .mid(%rip), %rcx
        call __mingw_printf

        call check_win
        cmpq $0, %rax
        jnz .game_win

        incl -4(%rbp)
        cmpl $9, -4(%rbp)
        jz .game_draw

        call print_table

        .print_loop_2:
            call place_2
        cmpq $1, %rax
        jnz .print_loop_2

        leaq .mid(%rip), %rcx
        call __mingw_printf

        call check_win
        cmpq $0, %rax
        jnz .game_win

        incl -4(%rbp)
        cmpl $9, -4(%rbp)
        jz .game_draw

    jmp .main_loop

    .game_draw:
    leaq .draw(%rip), %rcx
    call printf

    .game_win:
    leaq .mid(%rip), %rcx
    call __mingw_printf
    call print_table

    addq $64, %rsp
    popq %rbp
    ret
