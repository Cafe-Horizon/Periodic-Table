# Makefile for AArch64 SVG Generator

# Default to native tools if running on aarch64, else use cross-tools
ARCH := $(shell uname -m)
ifeq ($(ARCH), aarch64)
    AS = as
    LD = ld
    EMU =
else
    AS = aarch64-linux-gnu-as
    LD = aarch64-linux-gnu-ld
    EMU = qemu-aarch64
endif

SRC_DIR = src
OBJ_DIR = obj
BIN = generate_svg
SVG = periodic-table.svg

OBJS = $(OBJ_DIR)/generate_svg.o

all: $(BIN)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/generate_svg.o: $(SRC_DIR)/generate_svg.s $(SRC_DIR)/elements.inc | $(OBJ_DIR)
	$(AS) -g -o $@ $<

$(BIN): $(OBJS)
	$(LD) -o $@ $(OBJS)

run: $(BIN)
	$(EMU) ./$(BIN) > $(SVG)
	@echo "Generated $(SVG) using AArch64 assembly $(if $(EMU),via $(EMU),natively)"

clean:
	rm -rf $(OBJ_DIR) $(BIN) $(SVG)

.PHONY: all run clean
