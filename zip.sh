#!/bin/bash
OUT_DIR=out
AK3_DIR=$HOME/AnyKernel3
SECONDS=0
ZIPNAME="caf-spacewar-$(date '+%Y%m%d-%H%M').zip"
if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&
   head=$(git rev-parse --verify HEAD 2>/dev/null); then
        ZIPNAME="${ZIPNAME::-4}-$(echo $head | cut -c1-8).zip"
fi

kernel="$OUT_DIR/arch/arm64/boot/Image"
dts_dir="$OUT_DIR/arch/arm64/boot/dts/vendor/qcom"

if [ -f "$kernel" ] && [ -d "$dts_dir" ]; then
	echo -e "\nKernel compiled succesfully! Zipping up...\n"
	if [ -d "$AK3_DIR" ]; then
		cp -r $AK3_DIR AnyKernel3
	elif ! git clone https://github.com/morn-0/AnyKernel3.git; then
		echo -e "\nAnyKernel3 repo not found locally and couldn't clone from GitHub! Aborting..."
		exit 1
	fi
	cp $kernel AnyKernel3
	cat $dts_dir/*.dtb > AnyKernel3/dtb
	python2 scripts/dtc/libfdt/mkdtboimg.py create AnyKernel3/dtbo.img --page_size=4096 $dts_dir/*.dtbo
	cd AnyKernel3
	zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
	cd ..
	rm -rf AnyKernel3
	echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
	echo "Zip: $ZIPNAME"
else
	echo -e "\nCompilation failed!"
	exit 1
fi
