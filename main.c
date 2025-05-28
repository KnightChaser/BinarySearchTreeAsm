// main.c
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function prototypes written in x86_64 NASM Assembly
// for the binary search tree operations
// that are defined in /src directory.
extern void *create_node(int);
extern void *insert(void *, int);
extern void *delete(void *, int);
extern void inorder(void *);

// Print the help message
static void help(void) {
    printf("Available commands:\n");
    printf("  insert <value> - Insert a value into the BST\n");
    printf("  delete <value> - Delete a value from the BST\n");
    printf("  print          - Print the BST in-order\n");
    printf("  help           - Show this help message\n");
    printf("  exit           - Exit the program\n");
}

int main(int argc, char *argv[]) {
    void *root = NULL;
    char line[128];

    while (true) {
        printf("command> ");
        if (!fgets(line, sizeof(line), stdin)) {
            // EOF or read error
            break;
        }

        // Strip trailing newline
        line[strcspn(line, "\n")] = '\0';

        if (strncmp(line, "insert ", 7) == 0) {
            // insert <key> to the binary search tree
            int v;
            if (sscanf(line + 7, "%d", &v) == 1) {
                if (!root) {
                    // If the tree is empty, create the root node
                    root = create_node(v);
                } else {
                    // Otherwise, insert the value into the tree
                    root = insert(root, v);
                }
                printf("inserted %d\n", v);
            } else {
                printf("invalid insert command\n");
            }

        } else if (strncmp(line, "delete ", 7) == 0) {
            // delete <key> from the binary search tree
            int v;
            if (sscanf(line + 7, "%d", &v) == 1) {
                root = delete (root, v);
                printf("deleted %d\n", v);
            } else {
                printf("invalid delete command\n");
            }

        } else if (strcmp(line, "print") == 0) {
            // print the binary search tree in-order
            inorder(root);
            printf("\n");

        } else if (strcmp(line, "exit") == 0) {
            // exit the program (cutely! >_0)
            printf("bye! >_<\n");
            break;

        } else if (line[0] != '\0') {
            printf("unknown command: '%s'\n", line);
        }
    }

    return EXIT_SUCCESS;
}
