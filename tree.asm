; tree.asm

;------------------------------------------------------------------------------
; Tree data structure in x86-64 assembly
; This file implements a binary tree with functions to create nodes,
; insert values, and perform inorder traversal.
; ------------------------------------------------------------------------------
struc Node
    .data   resq 1
    .left   resq 1
    .right  resq 1
endstruc

%define NODE_DATA   Node.data
%define NODE_LEFT   Node.left
%define NODE_RIGHT  Node.right
%define NODE_SIZE   24           ; 3 * 8 bytes for data, left, right pointers

;------------------------------------------------------------------------------ 
; Imports & exports 
;------------------------------------------------------------------------------ 
extern malloc
extern printf
extern exit

global create_node
global inorder
global insert

section .text

; create_node()
;  - argument: rdi = value
;  - returns:  rax = pointer to new Node
create_node:
    ; prologue
    push rbp
    mov rbp, rsp

    ; save the incoming value
    mov rbx, rdi     ; rbx <- value

    ; request 24 bytes
    mov rdi, NODE_SIZE
    call malloc      ; rax <- ptr or 0 (failure)

    test rax, rax
    je .alloc_fail

    ; initialize struct fields
    mov [rax + NODE_DATA], rbx        ; set value
    mov qword [rax + NODE_LEFT], 0    ; set left pointer to NULL
    mov qword [rax + NODE_RIGHT], 0   ; set right pointer to NULL

    ; epilogue
    mov rsp, rbp
    pop rbp
    ret

.alloc_fail:
    ; Just exit(1)
    mov edi, 1
    call exit

; inorder(Node* root)
; - argument: rdi = pointer to root Node
; - prints the values in inorder traversal
inorder:
    ; prologue
    push rbp
    mov rbp, rsp
    push rbx      ; Use RBX to save the current node pointer

    mov rbx, rdi; ; rbx <- root Node pointer
    cmp rbx, 0
    je .done      ; If root is NULL, return

    ; Traverse left subtree (root->left)
    mov rdi, [rbx + NODE_LEFT] ; rdi <- left child pointer
    call inorder

    ; print this node's data
    mov rsi, [rbx + NODE_DATA] ; 2nd argument = node data
    lea rdi, [rel fmt]         ; 1st argument = format string
    xor eax, eax               ; Clear EAX for printf
    call printf

    ; traverse right subtree (root->right)
    mov rdi, [rbx + NODE_RIGHT] ; rdi <- right child pointer
    call inorder

.done:
    ; epilogue
    ; it happens when we return from the last call
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

; insert(Node* root, int value)
; - arguments:
;    rdi = pointer to root Node
;    rsi = value to insert
; - returns: rax = pointer to the root Node (unchanged)
insert:
    ; prologue
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rbx, rdi    ; rbx <- root Node pointer
    mov r12, rsi    ; r12 <- value to insert

    cmp rbx, 0
    je .make_node   ; if root is NULL, create a new node

    ; compare value < root->data?
    mov rcx, [rbx + NODE_DATA]
    cmp r12, rcx
    jl  .do_left
    ; else -> do_right
.do_right:
    mov rdi, [rbx + NODE_RIGHT]  ; arg1 = root->right
    mov rsi, r12                 ; arg2 = value to insert
    call insert
    mov [rbx + NODE_RIGHT], rax  ; update right child pointer
    jmp .return_root

.do_left:
    mov rdi, [rbx + NODE_LEFT]   ; arg1 = root->left
    mov rsi, r12                 ; arg2 = value to insert
    call insert
    mov [rbx + NODE_LEFT], rax   ; update left child pointer

.return_root:
    mov rax, rbx   ; return the unchanged root pointer
    jmp .cleanup

.make_node:
    ; create a new node
    mov rdi, r12   ; rdi <- value to insert
    call create_node
    jmp .cleanup

.cleanup:
    ; epilogue
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

section .rodata
fmt:  db "%d ", 0  ; format string for printf
