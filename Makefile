# Makefile for BinaryTreeAsm
ASM      := nasm
ASMFLAGS := -f elf64
CC       := gcc
CFLAGS   := -no-pie -fno-pie
LDFLAGS  := -z noexecstack
TARGET   := tree

.PHONY: all clean

all: $(TARGET)

# assemble the ASM into an object
tree.o: tree.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# compile the C into an object
main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

# link both into the final binary
$(TARGET): tree.o main.o
	$(CC) $(CFLAGS) main.o tree.o -o $(TARGET) $(LDFLAGS)

clean:
	rm -f *.o $(TARGET)

