CC = gcc
CFLAGS = -Wall -O3
LDFLAGS = -lm

# Main targets
all: tensor1d libtensor1d.so

# Compile the main executable
tensor1d: tensor1d.c tensor1d.h
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# Create shared library
libtensor1d.so: tensor1d.c tensor1d.h
	$(CC) $(CFLAGS) -shared -fPIC -o $@ $< $(LDFLAGS)

# Clean up build artifacts
clean:
	rm -f tensor1d libtensor1d.so

# Test using pytest
test:
	pytest

.PHONY: all clean test
