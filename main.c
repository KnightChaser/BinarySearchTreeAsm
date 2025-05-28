// main.c
#include <stdio.h>
#include <stdlib.h>

// Function prototypes for the binary search tree operations,
// which are defined in src/ assembly codes.
extern void *create_node(int);
extern void inorder(void *);
extern void *insert(void *, int);
extern void *delete(void *, int);

int main(int argc, char *argv[]) {
    void *root = NULL;
    int vals[] = {50, 30, 70, 20, 40, 60, 80};

    // Insert values into the binary search tree and
    // print the inorder traversal
    for (size_t i = 0; i < 7; i++) {
        if (!root) {
            root = create_node(vals[i]);
        } else {
            insert(root, vals[i]);
            inorder(root);
            printf("\n");
        }
    }

    // Delete a value from the binary search
    // tree and print the inorder traversal
    for (size_t i = 0; i < 7; i++) {
        delete (root, vals[i]);
        inorder(root);
        printf("\n");
    }

    return 0;
}
