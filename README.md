# Minimal Raspberry Pi initialisation Without a Screen and Keyboard (WaSaK)

## NOOBS supports headless OS installation...

Before going further, NOOBS does offer the option of (headless installation of Raspberry Pi operating systems)[https://www.raspberrypi.org/forums/viewtopic.php?t=141559]. The NOOBS installer can be operated remotely using VNC and provides a nice GUI. Just search the internet for 'noobs vncinstall forcetrigger' to find many guides on how to do this.

## ...so why WaSaK?

* Embedded applications might not need to provide a desktop experience.
* Remote terminal access prior to any installation.
* Avoid repartitioning of SD Card until required by you! NOOBS modifies the SD Card partition table even before an OS is selected for installation.
* Because repartitioning is avoided, the SD Card can still be accessed when inserted into an Android device.
* WaSaK extension packages are zip files, easily accessible on most devices.
* Allows much more hacking and hands-on learning.
* Does not require installation of a VNC viewer.
* Dedicated embedded applications can be facilitated simply by creating a WaSaK extension package without requiring a desktop OS to be installed on the Pi.
* Writable initramfs root filesystem provides further flexibility than read-only SquashFS. SquashFS is still supported to minimise RAM usage.
* Works with mainline Raspberry Pi kernels including 64-bit kernels.
* Run dedicated test agents and test kernel builds.

## Alpine Linux - new base for WaSaK

Alpine Linux supports [Headless Installation on the Raspberry Pi](https://wiki.alpinelinux.org/wiki/Raspberry_Pi_-_Headless_Installation). It appears to support nearly all the functionality of WaSaK apart from the installation of ttyd. WaSaK will use Alpine as its base in future revisions. This will mean that WaSaK will no longer be dependent on parts of the NOOBS filesystem.

A very useful feature of Alpine is the [lbu](https://wiki.alpinelinux.org/wiki/Alpine_local_backup) which is a manager for overlay filesystems. One great feature is that filesystem changes can be reviewed and then committed or reverted.

