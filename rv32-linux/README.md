
# Testing the RV32 BPF JIT

This guide describes how to test the Linux kernel
BPF JIT for 32-bit RISC-V (RV32).
Currently, it supports running the builtin kernel
tests (lib/testbpf.c) and the `test_verifier`
self-tests (tools/testing/selftests/bpf/test_verifier.c).

First clone this repository somewhere to use
the configuration scripts and images contained
in this directory.

## Prerequisites:

This directory contains the configuration files needed
to build and run the tests. We will need to obtain
and build custom versions of the following tools:

- [RISC-V GNU Toolchain]
  + With support for Linux/ELF+glibc for RV32.
- [QEMU]
  + With riscv32-softmmu target and VirtFS support.
- [Buildroot]
  + Using the custom configuration in this directory
- [Linux]
  + With RV32 BPF JIT and headers / libraries
    required to build the selftests.



### RISC-V GNU Toolchain

You will need a 32-bit version of the RISC-V GNU toolchain.
While any RISC-V GCC cross-compiler should
be able to build the kernel, we need to compile
user-space self test programs which require
an RV32 glibc.

```sh
# Obtain RISC-V GNU toolchain
$ git clone --recursive "https://github.com/riscv/riscv-gnu-toolchain.git" && cd riscv-gnu-toolchain
# Configure RISC-V toolchain for rv32gc
$ ./configure --prefix=/opt/riscv --with-arch=rv32gc --with-abi=ilp32
# Build Linux-ELF/glibc toolchain
$ make linux -j8
```

Downloading and compiling the toolchain will likely
take a while. Once done, the toolchain will be
installed in `/opt/riscv`. You can choose another
place to install the toolchain, just make sure
to add it to your `PATH` when done.

### QEMU

We need a custom build of QEMU with support for 32-bit
RISC-V and VirtFS in order to run and test the Linux kernel.

```sh
# Clone QEMU
git clone --recursive "https://github.com/qemu/qemu.git" && cd qemu
# Configure QEMU to build riscv32 target and virtfs
$ ./configure --target-list=riscv32-softmmu --enable-virtfs
# Build QEMU
$ make -j8
```

### Buildroot

This directory contains pre-built versions
of `fw_jump.elf` and `rootfs.ext2` required for testing.

If required, you can also use `buildroot.config` to
re-make the Buildroot images.

Make sure to copy the output images back to this repository
for the guide to work.

### Linux source

You will need a version of Linux that has the BPF RV32
JIT. Unfortunately, the Linux BPF selftests do not seem
to have good support for cross-compiling, and its difficult
to get a GCC toolchain running in the buildroot image for a
native build of the tests. For convenience, I have a branch
of the Linux source code with pre-built dependencies and
modifications to build scripts to allow cross-compiling
for RV32 from a different host. You can find it here:

https://github.com/lukenels/linux/tree/rv32-test-verifier

(Make sure to be using the rv32-test-verifier branch).

Ideally in the future, it's easier to cross-compile BPF
selftests and this hack won't be necessary.

## Testing

## Building linux

The first step is to build the Linux kernel.

The rest of this guide uses the following variables
to refer to paths to various prerequisites.

```sh
LINUX=/path/to/linux/
META_LINUX_UTILS=/path/to/this/repository/
QEMU=/path/to/qemu
```

Step 1: Build Linux

```sh
$ cd $LINUX

$ cp $META_LINUX_UTILS/rv32-linux/linux.config .config

$ make ARCH=riscv CROSS_COMPILE=riscv32-unknown-linux-gnu- -j16
```

Step 2: Build selftests

```sh
$ git checkout tools/lib/bpf/libbpf.a
$ make -C tools/testing/selftests/bpf ARCH=riscv CROSS_COMPILE=riscv32-unknown-linux-gnu- test_verifier
```

## Running the tests

First, boot the Linux image on QEMU.

```sh
$ env LINUX=$LINUX QEMU=$QEMU $META_LINUX_UTILS/rv32-linux/run.sh
```

Second, login using username `root` and no password.

Third, mount the 9P filesystem to access the kernel module and selftests
in the Linux source directory:

```sh
$ mkdir -p linux
$ mount -t 9p -o trans=virtio hostshare linux
```

Next, enable the BPF JIT compiler.
(Omit this to compare against the interpreter baseline.)

```sh
$ echo 1 >/proc/sys/net/core/bpf_jit_enable
```

To run the lib/test_bpf.ko tests, run:

```sh
$ insmod linux/lib/test_bpf.ko
```

This will print the results of the tests, ending with something like:

```
test_bpf: Summary: 378 PASSED, 0 FAILED, [349/366 JIT'ed]
test_bpf: #0 gso_with_rx_frags PASS
test_bpf: #1 gso_linear_no_head_frag PASS
test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
```

To run the `test_verifier` selftests, run:

```sh
$ ./linux/tools/testing/selftests/bpf/test_verifier
```

This should end with something like:

```
Summary: 1415 PASSED, 122 SKIPPED, 43 FAILED
```

Note that this fails 43 tests, but these same tests are also failed
under the BPF interpreter. You can verify this by disabling / not
enabling the BPF JIT earlier and running the tests again. You can also
verify that the BPF JIT is actually being used by enable BPF debug mode:

```sh
$ echo 2 >/proc/sys/net/core/bpf_jit_enable
$ ./linux/tools/testing/selftests/bpf/test_verifier
```

This will take longer, but show that the JIT is being used.


# Conclusion

This entire test process is quite brittle and relies on
a specific set of a bunch of prerequisites in order to get around some
limitations.

- There is no readily available non-embedded Linux distribution
  for 32-bit RISC-V. Fedora exists for 64-bit RISC-V but not 32.
  This makes it difficult to get the tools
  required for a native build of the RV32 selftests.
- Linux BPF selftest infrastructure does not play nicely
  with cross-compilation. CFLAGS / LDFLAGS / etc. are not
  consistently passed around to sub-make, and there doesn't
  appear to be a distinction between compiling programs
  that need to run on the host (e.g., bpftool) versus
  those that need to run on the target (e.g., test_verifier).
- These limitations mean that I only can run the `test_verifier`
  selftests for now; getting the rest of the tests like `test_progs`
  is something I'm working on but doesn't work yet.

[buildroot]: https://github.com/buildroot/buildroot
[QEMU]: https://github.com/qemu/QEMU
[RISC-V GNU Toolchain]: https://github.com/riscv/riscv-gnu-toolchain
[Linux]: https://github.com/lukenels/linux/tree/rv32-test-verifier
