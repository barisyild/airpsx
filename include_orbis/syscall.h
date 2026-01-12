extern "C" {
    asm("orbis_syscall:\n"
        "movq $0, %rax\n"
        "movq %rcx, %r10\n"
        "syscall\n"
        "jb err\n"
        "retq\n"
    "err:\n"
        "pushq %rax\n"
        "callq __error\n"
        "popq %rcx\n"
        "movl %ecx, 0(%rax)\n"
        "movq $0xFFFFFFFFFFFFFFFF, %rax\n"
        "movq $0xFFFFFFFFFFFFFFFF, %rdx\n"
        "retq\n");
    int orbis_syscall(int num, ...);
}