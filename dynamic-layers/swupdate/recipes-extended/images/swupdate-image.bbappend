# remove unneeded technexion packagegroups
IMAGE_INSTALL:remove = "packagegroup-tn-tools packagegroup-tn-voicehat packagegroup-tn-wlan packagegroup-tn-vizionsdk sysvinit"

IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('SWUPDATE_INIT', 'tiny', 'virtual/initscripts-swupdate', 'initscripts systemd', d)} \
    swupdate-progress \
    swupdate-client \
    swupdate-tools-ipc \
    u-boot-fw-utils \
    tn-u-boot-fw-env \
    udev-rules-imx \
    udev \
    firmware-imx-sdma-imx7d \
"

DISTRO_FEATURES:remove = "irda alsa bluetooth wifi nfs 3g ptest bluez bluez5 vulkan optee pulseaudio multiarch \
                        acl argp ext2 pcmcia usbgadget xattr zeroconf pci jailhouse virtualization \
                        vizionviewer vizionsdk-dev packagegroup-tn-tools tn-apt-list packagegroup-tn-wlan xen xen-tools apt dpkg"

IMAGE_FSTYPES:remove = "ext4 wic.md5sum wic.xz wic.bz2"
IMAGE_FSTYPES = "cpio.gz.u-boot"
