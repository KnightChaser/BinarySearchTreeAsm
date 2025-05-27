;tree.asm

;------------------------------------------------------------------------------
; Binary Tree in x86-64 Assembly (System V AMD64 ABI)
; ——————————————————————————————————————————————————————————————————————————————
; Provides:
;   - create_node(value)  -> malloc’d Node*
;   - insert(root, value) -> updated tree
;   - inorder(root)       -> prints values in sorted order
;
; Layout:
;   Node struct: 3 × 8 bytes = 24 bytes
;     +0  data  (int64)
;     +8  left  (Node*)
;    +16  right (Node*)
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Struct Definition & Constants
;------------------------------------------------------------------------------
struc Node
    .data   resq 1            ; 8 B: value field
    .left   resq 1            ; 8 B: ptr to left child
    .right  resq 1            ; 8 B: ptr to right child
endstruc

%define NODE_DATA   Node.data
%define NODE_LEFT   Node.left
%define NODE_RIGHT  Node.right
%define NODE_SIZE   24       ; total struct size

;------------------------------------------------------------------------------
; External Symbols & Exports
;------------------------------------------------------------------------------
extern malloc                ; allocate memory
extern printf                ; formatted print
extern exit                  ; terminate process

global create_node
global insert
global inorder

;------------------------------------------------------------------------------
; Text Section: Code
;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
; Read-Only Data
;------------------------------------------------------------------------------
section .rodata
fmt:    db "%d ", 0

