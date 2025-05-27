// main.c
#include <stdlib.h>

extern void *create_node(int);
extern void inorder(void *);
extern void *insert(void *, int);

int main(void) {
  void *root = NULL;
  int vals[] = {50, 30, 70, 20, 40, 60, 80};
  for (int i = 0; i < 7; i++) {
    if (!root)
      root = create_node(vals[i]);
    else
      insert(root, vals[i]);
  }
  inorder(root);
  return 0;
}
