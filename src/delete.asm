; src/delete.asm

%include "src/structs.inc"

extern find_min ; src/find_main.asm
global delete

section .text
;------------------------------------------------------------------------------
; delete(root, value)
; - Deletes a Node with the specified value from the binary search tree.
; Args:
;   RDI = pointer to the root Node
;   RSI = 64-bit signed value to delete
; Returns:
;   RAX = pointer to the new root Node (or NULL if tree is empty)
;------------------------------------------------------------------------------
delete:
    ; prologue
    push rbp
    mov rbp, rsp
    push rbx         ; save callee-saved registers (RBX, RBP, R12-R15)
    push r12
    push r13

    ; initialize variables
    mov rbx, rdi     ; rbx <- root
    mov r12, rsi     ; r12 <- value to delete

    cmp rbx, 0
    je .ret_null     ; nothing to delete, return NULL

    ; compare value with current node's data(node->data)
    mov rcx, [rbx + NODE_DATA]
    cmp r12, rcx
    jl .go_left      ; if value(r12) < node->data(rcx), go left
    jg .go_right     ; if value(r12) > node->data(rcx), go right
    ; "==" case falls through to delete the current node

    ; (match found) delete the target node(rbx)
    ; if no left child exists, return the right subtree (root->right)
    mov rax, [rbx + NODE_LEFT]
    cmp rax, 0
    je .take_right

    ; if no right child exists, return the left subtree (root->left)
    mov rax, [rbx + NODE_RIGHT]
    cmp rax, 0
    je .take_left

    ; if both children exist, find the minimum in the right subtree
    ; 1) find the minimum in the right subtree
    mov rdi, [rbx + NODE_RIGHT]  ; rdi <- right child
    call find_min
    mov r13, rax                 ; r13 <- minimum node in right subtree

    ; 2) copy successor->data into current node
    mov rax, [r13 + NODE_DATA]
    mov [rbx + NODE_DATA], rax

    ; 3) delete that successor from the right subtree
    mov rdi, [rbx + NODE_RIGHT]  ; rdi <- right child
    mov rsi, rax                 ; value to remove gets copied
    call delete
    mov [rbx + NODE_RIGHT], rax  ; update right child

    mov rax, rbx                 ; return current node as new root
    jmp .cleanup

.take_right:
    ; return root->right
    mov rax, [rbx + NODE_RIGHT]
    jmp .cleanup

.take_left:
    ; return root->left
    mov rax, [rbx + NODE_LEFT]
    jmp .cleanup

.go_left:
    ; go left
    mov rdi, [rbx + NODE_LEFT]  ; rdi <- left child
    mov rsi, r12                ; value to delete
    call delete                 ; delete from left subtree
    mov [rbx + NODE_LEFT], rax  ; update left child
    mov rax, rbx                ; return current node as new root
    jmp .cleanup

.go_right:
    ; go right
    mov rdi, [rbx + NODE_RIGHT] ; rdi <- right child
    mov rsi, r12                ; value to delete
    call delete                 ; delete from right subtree
    mov [rbx + NODE_RIGHT], rax ; update right child
    mov rax, rbx                ; return current node as new root
    jmp .cleanup

.ret_null:
    ; return NULL
    xor rax, rax                ; RAX = 0 (NULL)

.cleanup:
    ; epilogue
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
