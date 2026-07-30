# Setup

These instructions are for Ubuntu-based distributions.

## Install Dependencies

Update the package lists:

```bash
sudo apt update
```

Install the required packages:

```bash
sudo apt install \
    build-essential \
    bison \
    flex \
    texinfo \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    libisl-dev \
    wget
```

## Verify Installation

Ensure the required tools are installed:

```bash
gcc --version
g++ --version
make --version
bison --version
flex --version
```

Each command should print version information without errors.

## Project Layout

Create the project directory:

```bash
mkdir -p ~/fbcos
cd ~/fbcos
```

The cross-compiler tutorial expects the following structure:

```text
fbcos/
├── src/
├── build-binutils/
├── build-gcc/
└── opt/
    └── cross/
```

Create it with:

```bash
mkdir src
mkdir build-binutils
mkdir build-gcc
mkdir -p opt/cross
```