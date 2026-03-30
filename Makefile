# Compiler and tools
CC = gcc
RM = rm -f

# Directories
SRCDIR = src
INCDIR = heads
BUILDDIR = build

# Flags
CFLAGS = -O2 -Wall -Wextra -I$(INCDIR)
#LDFLAGS = - Library Flags If any

# Find all .c files recursively inside src/ (including subfolders)
SOURCES = $(shell find $(SRCDIR) -name "*.c") main.c

# Convert each .c to .o in the build directory, preserving subfolder structure
OBJECTS = $(addprefix $(BUILDDIR)/, $(SOURCES:.c=.o))

# The final executable (add .exe on Windows)
TARGET = myapp.exe # App Name

# Default target: build the executable
all: $(TARGET)

# Link the executable from all object files
$(TARGET): $(OBJECTS)
	$(CC) $^ $(LDFLAGS) -o $@
	@echo "Build complete: $@"

# Compile any .c into a .o, creating necessary subfolders
$(BUILDDIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Automatic header dependencies: generate .d files
DEPENDS = $(OBJECTS:.o=.d)
-include $(DEPENDS)

# Rule to generate .d files (tracks which headers each .c includes)
$(BUILDDIR)/%.d: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MM -MT $(@:.d=.o) $< > $@

# Clean: remove build folder and executable
clean:
	$(RM) -r $(BUILDDIR) $(TARGET)

# Run the program after building
run: $(TARGET)
	./$(TARGET)

# Phony targets (not real files)
.PHONY: all clean run
