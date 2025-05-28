; src/find_min.asm

%include "src/structs.inc"

; Since binary search tree often requires finding the minimum value,
; we implement a function to find the minimum value in a binary search tree,
; and expose this routine to other modules.
global find_min

section .text
;------------------------------------------------------------------------------
; find_min(root)
; - Finds the minimum value in a binary search tree.
; Args:
;  RDI = pointer to the root Node
; Returns:
;  RAX = pointer to the Node with the minimum value
;------------------------------------------------------------------------------
find_min:
    ; prologue
    push rbp
    mov rbp, rsp
    push rbx          ; save rbx
                      ; In System V ABI, RBX, RBP, R12-R15 are callee-saved registers.
                      ; We save rbx to preserve its value across the function call.
                      ; We will restore it before returning.
                      ; Otherwise, we'll get a segmentation fault. >_<
    mov rax, rdi      ; rax <- start with root

.loop:
    cmp rax, 0
    je .done           ; if rax is NULL(empty subtree), return NULL
    mov rbx, [rax + NODE_LEFT]
    cmp rbx, 0         ; check if left child exists
    je .done
    mov rax, rbx       ; move to left child
    jmp .loop

.done:
    ; epilogue
    pop rbx            ; restore rbx
    pop rbp
    ret
