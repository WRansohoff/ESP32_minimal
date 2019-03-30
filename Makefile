# 'Bare metal' ESP32 application Makefile
# Use the xtensa-esp32-elf toolchain.
TOOLCHAIN = xtensa-esp32-elf-

CFLAGS_PLATFORM  = -mlongcalls -mtext-section-literals -fstrict-volatile-bitfields
ASFLAGS_PLATFORM = $(CFLAGS_PLATFORM)
LDFLAGS_PLATFORM = $(CFLAGS_PLATFORM)

###
# General project build
###
CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)ld
OC = $(TOOLCHAIN)objcopy
OS = $(TOOLCHAIN)size

# Linker script location.
LDSCRIPT       = ./ld/esp32.ld
# Set C/LD/AS flags.
CFLAGS += $(INC) -Wall -Werror -std=gnu11 -nostdlib $(CFLAGS_PLATFORM) $(COPT)
# (Allow access to the same memory location w/ different data widths.)
CFLAGS += -fno-strict-aliasing
CFLAGS += -fdata-sections -ffunction-sections
#CFLAGS += -Os
CFLAGS += -Os -g
LDFLAGS += -nostdlib -T$(LDSCRIPT) -Wl,-Map=$@.map -Wl,--cref -Wl,--gc-sections
LDFLAGS += $(LDFLAGS_PLATFORM)
LDFLAGS += -lm -lc -lgcc
ASFLAGS += -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)

# Set C source files.
C_SRC += \
	./src/main.c \

OBJS += $(C_SRC:.c=.o)

# Set the first rule in the file to 'make all'
.PHONY: all
all: main.elf

# Rules to build files.
%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

main.elf: $(OBJS)
	$(CC) $^ $(LDFLAGS) -o $@

# Target to clean build artifacts.
.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f ./main.bin
	rm -f ./main.elf ./main.elf.map
