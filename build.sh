#!/bin/bash
set -e

echo "[1/5] Assembling boot.s..."
i686-elf-as boot.s -o boot.o

echo "[2/5] Compiling kernel.c..."
i686-elf-gcc -c kernel.c \
    -o kernel.o \
    -std=gnu99 \
    -ffreestanding \
    -O2 \
    -Wall \
    -Wextra

echo "[3/5] Linking kernel..."
i686-elf-gcc \
    -T linker.ld \
    -o FBCOS \
    -ffreestanding \
    -O2 \
    -nostdlib \
    boot.o kernel.o

echo "[4/5] Building ISO..."
mkdir -p isodir/boot/grub
cp FBCOS isodir/boot/FBCOS
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o FBCOS.iso isodir

echo "[5/5] Running..."
qemu-system-i386 -kernel FBCOS