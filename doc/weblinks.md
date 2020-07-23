Internet References
===================

Prebuilt binaries
------------------

WaSaK attempts to utilise as many prebuilt resources as possible to reduce build time. The binaries used by WaSaK are:

* The bootloader, kernel and kernel modules can be found in the [Raspberry Pi firmware](https://github.com/raspberrypi/firmware/archive/stable.zip) GitHub repo.
* [busybox-armv7](https://www.busybox.net/downloads/binaries/1.21.1/busybox-armv7l).

Source code references
----------------------

The WaSaK initramfs is a gzip-ed cpio archive and is produced using **gen_init_cpio** compiled from [C source code](https://github.com/raspberrypi/linux/blob/rpi-5.4.y/usr/gen_init_cpio.c). This is not built for the Raspberry Pi target, this must be built so that it can be executed on the host that is generating the initramfs. The embedded application and large extensions are likely to reside in a SquashFS filesystem and thus the application developer and most other experimenters are unlikely to need to create a new initramfs.
