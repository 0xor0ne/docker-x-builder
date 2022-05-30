#!/bin/sh
(
BINARIES_DIR="/home/user/workspace/buildroot/output/images/"
cd ${BINARIES_DIR}

if [ "${1}" = "serial-only" ]; then
    EXTRA_ARGS='-nographic'
else
    EXTRA_ARGS='-serial stdio'
fi

export PATH="/home/user/workspace/buildroot/output/host/bin:${PATH}"
exec qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel zImage -dtb vexpress-v2p-ca9.dtb -drive file=rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0"  -net nic -net tap,ifname=tap0,script=no,downscript=no  ${EXTRA_ARGS}
)
