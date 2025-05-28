## `BinarySearchTreeASM` 🌲
> A simple binary search tree(BST) implemented in NASM (System V AMD64 ABI, x86_64 assembly). I left detailed annotations on codes, too! >_<

### Preview
![image](https://github.com/user-attachments/assets/c458876d-2d70-4a35-9b0a-c7a74840fa50)

Project overlook: 
- `src/structs.inc`: Defines Node struct layout and constants 
- `src/create_node.asm`: Allocates and initializes a new Node 
- `src/insert.asm`: Inserts an integer value into the BST 
- `src/find_min.asm`: Finds the node with the minimum value 
- `src/delete.asm`: Deletes an integer value from the BST 
- `src/inorder.asm`: Prints tree contents in sorted order 
- `main.c`: Interactive shell for `insert`, `delete`, `print` commands. (Since this is not directly relatd to BST data structure, I implemented such interactions in C rather than Assembly for convenience.) 

### Usage
- Build: `make`
- Run: `./tree`
- Commands: `insert <key>`, `delete <key>`, `print`, `help` and `exit`.

### Licenses and contributions
This is an open source. Any contributions or comments are welcomed!
