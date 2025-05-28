ASM      := nasm
ASMFLAGS := -f elf64
CC       := gcc
CFLAGS   := -no-pie -fno-pie
LDFLAGS  := -z noexecstack

SRCDIR   := src
OBJS     := \
    $(SRCDIR)/create_node.o \
    $(SRCDIR)/insert.o      \
    $(SRCDIR)/inorder.o     \
    $(SRCDIR)/delete.o      \
    $(SRCDIR)/find_min.o    \
    main.o

.PHONY: all clean
all: tree

# Assemble ASM modules
$(SRCDIR)/create_node.o: $(SRCDIR)/create_node.asm $(SRCDIR)/structs.inc
	$(ASM) $(ASMFLAGS) $< -o $@

$(SRCDIR)/insert.o: $(SRCDIR)/insert.asm $(SRCDIR)/structs.inc
	$(ASM) $(ASMFLAGS) $< -o $@

$(SRCDIR)/delete.o: $(SRCDIR)/delete.asm $(SRCDIR)/structs.inc
	$(ASM) $(ASMFLAGS) $< -o $@

$(SRCDIR)/inorder.o: $(SRCDIR)/inorder.asm $(SRCDIR)/structs.inc
	$(ASM) $(ASMFLAGS) $< -o $@

$(SRCDIR)/find_min.o: $(SRCDIR)/find_min.asm $(SRCDIR)/structs.inc
	$(ASM) $(ASMFLAGS) $< -o $@

# Compile C module
main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link all into executable
tree: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f $(SRCDIR)/*.o *.o tree

