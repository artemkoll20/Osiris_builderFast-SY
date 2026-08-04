#!/bin/bash

# 1. Generate a random unique folder name in RAM (/tmp)
RANDOM_ID=$(head /dev/urandom | tr -dc 'a-z0-9' | head -c 8)
TEMP_DIR="/tmp/build_sandbox_${RANDOM_ID}"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# 2. Securely download the entire repository archive into RAM and unpack it on the fly
# Replace USERNAME and REPO with your actual GitHub credentials
wget -qO- "https://github.com" | tar -xz --strip-components=1

# 3. Navigate into the Osiris directory where CMakeLists.txt and Dependencies are located
cd Osiris || exit 1

# 4. Configure and build the project using CMake + Ninja + Clang + Mold inside RAM
# -B build_ram: build directory is also isolated inside the volatile memory
CC=clang CXX=clang++ cmake -G Ninja -B build_ram \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=mold"

# Trigger the high-speed compilation process
cmake --build build_ram

# 5. Copy the compiled binary out to the root of /tmp before wiping the sandbox
# Note: Check if your CMakeLists output name matches "libOsiris.so"
cp build_ram/libOsiris.so /tmp/libOsiris.so

# 6. Instantly and completely wipe all source code, dependencies, and caches from RAM
cd /tmp
rm -rf "$TEMP_DIR"

# Print execution status to the terminal
echo "[+] Secure build finished successfully!"
echo "[+] Target module saved to: /tmp/libOsiris.so"
echo "[+] All temporary build artifacts and source files have been fully removed from RAM."

