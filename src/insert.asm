; src/insert.asm

%include "src/structs.inc"
extern create_node
global insert

section .text
;------------------------------------------------------------------------------
; insert(root, value)
;  — Standard BST insert, duplicates go right.
; Args:
;   RDI = Node* root
;   RSI = int64 value
; Returns:
;   RAX = root pointer (unchanged) or new node if root was NULL
;------------------------------------------------------------------------------
insert:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12

    mov     rbx, rdi             ; current root
    mov     r12, rsi             ; value to insert
    cmp     rbx, 0
    je      .mk_node             ; empty → new Node

    mov     rcx, [rbx + NODE_DATA]
    cmp     r12, rcx
    jl      .go_left

.go_right:
    mov     rdi, [rbx + NODE_RIGHT]
    mov     rsi, r12
    call    insert
    mov     [rbx + NODE_RIGHT], rax
    jmp     .ret

.go_left:
    mov     rdi, [rbx + NODE_LEFT]
    mov     rsi, r12
    call    insert
    mov     [rbx + NODE_LEFT], rax

.ret:
    mov     rax, rbx              ; return original root
    jmp     .cleanup

.mk_node:
    mov     rdi, r12
    call    create_node           ; RAX = new node
    jmp     .cleanup

.cleanup:
    pop     r12
    pop     rbx
    pop     rbp
    ret
