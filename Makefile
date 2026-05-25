ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment.")
endif

PREFIX  := $(DEVKITARM)/bin/arm-none-eabi-
CC      := $(PREFIX)gcc
CXX     := $(PREFIX)g++
OBJCOPY := $(PREFIX)objcopy

NDSTOOL := /opt/devkitpro/tools/bin/ndstool

ARCH    := -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s
FLAGS   := -DARM9 -D__NDS__

# CORREÇÃO: adiciona o include path do calico
CALICO_INC := /opt/devkitpro/calico/include
INCLUDES   := -I/opt/devkitpro/libnds/include -I$(CALICO_INC) -I./include

CFLAGS   := -g -Wall -O2 $(ARCH) $(FLAGS) $(INCLUDES)
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions

LIBDIRS  := -L/opt/devkitpro/libnds/lib -L/opt/devkitpro/calico/lib
LIBS     := -lfat -lnds9 -lcalico9

OBJS   := source/main.o
TARGET := webforge-ds

SPECS      := $(DEVKITARM)/arm-none-eabi/lib/ds_arm9.specs
ARM7_BIN   := /opt/devkitpro/calico/arm7/calico-default-arm7.elf

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@$(OBJCOPY) -O binary $(TARGET).elf build_arm9.bin
	@$(NDSTOOL) -c $(TARGET).nds -9 build_arm9.bin -7 $(ARM7_BIN)
	@rm -f build_arm9.bin $(TARGET).elf source/*.o
	@echo "[SUCCESS] $(TARGET).nds built successfully."

$(TARGET).elf: $(OBJS)
	@$(CC) $(ARCH) -specs=$(SPECS) $(OBJS) $(LIBDIRS) $(LIBS) -o $(TARGET).elf

source/%.o: source/%.cpp
	@$(CXX) $(CXXFLAGS) -c $< -o $@

source/%.o: source/%.c
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -f source/*.o *.elf *.bin *.nds
