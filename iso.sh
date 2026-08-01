#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/fbcos.kernel isodir/boot/fbcos.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "fbcos" {
	multiboot /boot/fbcos.kernel
}
EOF
grub-mkrescue -o fbcos.iso isodir