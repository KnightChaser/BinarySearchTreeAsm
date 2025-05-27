; tree/structs.inc

; Common struct and constants  
struc Node
    .data   resq 1    ; 8B: value
    .left   resq 1    ; 8B: left child ptr
    .right  resq 1    ; 8B: right child ptr
endstruc

%define NODE_DATA   Node.data
%define NODE_LEFT   Node.left
%define NODE_RIGHT  Node.right
%define NODE_SIZE   24
