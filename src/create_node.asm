; src/create_node.asm

%include "src/structs.inc"
extern malloc
extern exit
global create_node

section .text
;------------------------------------------------------------------------------
; create_node(value)
;  — Allocates a Node, sets its fields.
; Args:
;   RDI = 64-bit signed value
; Returns:
;   RAX = pointer to new Node (or does exit(1) on OOM)
;------------------------------------------------------------------------------
create_node:
    push    rbp
    mov     rbp, rsp
    mov     rbx, rdi              ; save value

    mov     rdi, NODE_SIZE        ; malloc argument
    call    malloc                ; RAX = ptr or NULL
    test    rax, rax
    je      .alloc_fail

    ; initialize fields
    mov     [rax + NODE_DATA], rbx
    mov     qword [rax + NODE_LEFT],  0
    mov     qword [rax + NODE_RIGHT], 0

    pop     rbp
    ret

.alloc_fail:
    mov     edi, 1
    call    exit
