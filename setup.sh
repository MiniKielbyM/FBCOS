#!/usr/bin/env bash
set -euo pipefail

################################################################################
# FBCOS Development Environment Setup
################################################################################

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PREFIX="$ROOT/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

BINUTILS_VERSION=2.45
GCC_VERSION=15.2.0

BINUTILS="binutils-$BINUTILS_VERSION"
GCC="gcc-$GCC_VERSION"

echo "== Installing required packages =="

sudo apt update

sudo apt install -y \
    build-essential \
    bison \
    flex \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    xorriso \
    grub-pc-bin \
    grub-common \
    qemu-system-x86 \
    wget \
    curl

mkdir -p "$ROOT/src"

################################################################################
# Download binutils
################################################################################

if [ ! -f "$ROOT/src/$BINUTILS.tar.xz" ]; then
    echo "Downloading Binutils..."
    wget -O "$ROOT/src/$BINUTILS.tar.xz" \
        "https://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.xz"
fi

################################################################################
# Download GCC
################################################################################

if [ ! -f "$ROOT/src/$GCC.tar.xz" ]; then
    echo "Downloading GCC..."
    wget -O "$ROOT/src/$GCC.tar.xz" \
        "https://ftp.gnu.org/gnu/gcc/$GCC/$GCC.tar.xz"
fi

################################################################################
# Extract
################################################################################

cd "$ROOT/src"

if [ ! -d "$BINUTILS" ]; then
    tar -xf "$BINUTILS.tar.xz"
fi

if [ ! -d "$GCC" ]; then
    tar -xf "$GCC.tar.xz"
fi

################################################################################
# Download GCC prerequisites
################################################################################

cd "$ROOT/src/$GCC"

./contrib/download_prerequisites

################################################################################
# Build Binutils
################################################################################

mkdir -p "$ROOT/build-binutils"

cd "$ROOT/build-binutils"

../src/$BINUTILS/configure \
    --target="$TARGET" \
    --prefix="$PREFIX" \
    --with-sysroot \
    --disable-nls \
    --disable-werror

make -j"$(nproc)"
make install

################################################################################
# Build GCC
################################################################################

mkdir -p "$ROOT/build-gcc"

cd "$ROOT/build-gcc"

../src/$GCC/configure \
    --target="$TARGET" \
    --prefix="$PREFIX" \
    --disable-nls \
    --enable-languages=c,c++ \
    --without-headers

make all-gcc -j"$(nproc)"
make all-target-libgcc -j"$(nproc)"

make install-gcc
make install-target-libgcc

################################################################################
# PATH
################################################################################

if ! grep -q "FBCOS/opt/cross/bin" "$HOME/.bashrc"; then
    echo "" >> ~/.bashrc
    echo "# FBCOS Cross Compiler" >> ~/.bashrc
    echo "export PATH=\"$PREFIX/bin:\$PATH\"" >> ~/.bashrc
fi

export PATH="$PREFIX/bin:$PATH"

################################################################################
# Verify
################################################################################

echo
echo "Verifying installation..."
echo

which i686-elf-gcc

i686-elf-gcc --version

echo

i686-elf-gcc --print-file-name=crtbegin.o

echo

grub-file --version

echo

qemu-system-i386 --version

echo
echo "======================================"
echo "Setup complete!"
echo
echo "Restart your shell or run:"
echo
echo "source ~/.bashrc"
echo
echo "Then build with:"
echo
echo "./build-and-run.sh"
echo "======================================"