#---------------------------------------------------------------------------------
# WebForge DS - Official Infrastructure Build Configuration (Calico Patch)
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

ARCH    := -mthumb -mthumb-interwork -march=armv5te -mtune=arm946e-s
FLAGS   := -DARM9 -D__NDS__

INCLUDES := -I$(DEVKITARM)/../libnds/include \
            -I$(DEVKITARM)/../libcalico/include \
            -I./include

CFLAGS   := -g -Wall -O2 $(ARCH) $(FLAGS) $(INCLUDES)
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS  := -g $(ARCH)

LIBDIRS  := -L$(DEVKITARM)/../libnds/lib -L$(DEVKITARM)/../libcalico/lib
LIBS     := -lfat -lcalico -lnds9

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
