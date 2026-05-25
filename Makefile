#---------------------------------------------------------------------------------
# WebForge DS - Official Infrastructure Build Configuration (Pkg-Config Fix)
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to devkitARM>")
endif

PREFIX  := $(DEVKITARM)/bin/arm-none-eabi-
CC      := $(PREFIX)gcc
CXX     := $(PREFIX)g++
AS      := $(PREFIX)as
LD      := $(PREFIX)ld
OBJCOPY := $(PREFIX)objcopy

NDSTOOL := $(DEVKITARM)/../tools/bin/ndstool

PKG_CONFIG := $(DEVKITARM)/../tools/bin/nds-pkg-config

ARCH    := -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s

INCLUDES := $(shell $(PKG_CONFIG) --cflags libnds) -I./include

CFLAGS   := -g -Wall -O2 $(ARCH) $(INCLUDES)
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS  := -g $(ARCH)

LIBDIRS  := $(shell $(PKG_CONFIG) --libs libnds)
LIBS     := -lfat

OBJS     := source/main.o
TARGET   := webforge-ds

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@$(OBJCOPY) -O binary $(TARGET).elf build_arm9.bin
	@$(NDSTOOL) -c $(TARGET).nds -9 build_arm9.bin -7 $(DEVKITARM)/../libnds/default.arm7
	@rm -f build_arm9.bin $(TARGET).elf source/*.o
	@echo "[SUCCESS] $(TARGET).nds built successfully."

$(TARGET).elf: $(OBJS)
	@$(CC) $(ARCH) -specs=ds_arm9.specs $(OBJS) $(LIBDIRS) $(LIBS) -o $(TARGET).elf

source/%.o: source/%.cpp
	@$(CXX) $(CXXFLAGS) -c $< -o $@

source/%.o: source/%.c
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -f source/*.o *.elf *.bin *.nds
	@echo "Cleaned up workspace."
