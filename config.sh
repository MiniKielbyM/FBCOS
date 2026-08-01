#!/bin/sh

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

export HOST=${HOST:-$(./default-host.sh)}
export ARCH=$(./target-triplet-to-arch.sh "$HOST")

export PREFIX="$PROJECT_ROOT/opt/cross"
export SYSROOT="$PROJECT_ROOT/sysroot"

export PATH="$PREFIX/bin:$PATH"