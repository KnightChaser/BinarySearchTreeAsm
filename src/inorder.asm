; src/inorder.asm

%include "src/structs.inc"
extern printf
global inorder

section .text
;------------------------------------------------------------------------------
; inorder(root)
;  — Recursively prints all values in sorted order.
; Args:
;   RDI = Node* root
;------------------------------------------------------------------------------
inorder:
    push    rbp
    mov     rbp, rsp
    push    rbx

    mov     rbx, rdi
    cmp     rbx, 0
    je      .done

    ; left subtree
    mov     rdi, [rbx + NODE_LEFT]
    call    inorder

    ; print this node
    mov     rsi, [rbx + NODE_DATA]
    lea     rdi, [rel fmt]        ; address of "%d "
    xor     eax, eax              ; clear for variadic ABI
    call    printf

    ; right subtree
    mov     rdi, [rbx + NODE_RIGHT]
    call    inorder

.done:
    pop     rbx
    pop     rbp
    ret

section .rodata
fmt db "%d ", 0  ; format string for printf
