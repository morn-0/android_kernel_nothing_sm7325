#!/bin/fish

set -x CBL $HOME/cbl
set -x PATH $CBL/bin $PATH

make -j 16 \
        O=out \
        ARCH=arm64 \
        CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE=$CBL/bin/aarch64-linux-gnu- \
        CC=$CBL/bin/clang \
	CROSS_COMPILE_ARM32=$CBL/bin/arm-linux-gnueabi- \
	LLVM=1 \
	gki_v2_defconfig
make -j 16 \
        O=out \
        ARCH=arm64 \
        CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE=$CBL/bin/aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=$CBL/bin/arm-linux-gnueabi- \
        CC=$CBL/bin/clang \
	LLVM=1 || exit $status
make -j 16 \
        O=out \
        ARCH=arm64 \
        CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE=$CBL/bin/aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=$CBL/bin/arm-linux-gnueabi- \
        CC=$CBL/bin/clang \
	LLVM=1 \
	INSTALL_MOD_PATH=modules INSTALL_MOD_STRIP=1 modules_install

