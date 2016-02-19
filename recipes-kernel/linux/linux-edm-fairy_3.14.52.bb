# TechNexion EDM1-CF-IMX6 with Fairy baseboard

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx-3.14.52_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
           file://0001-fix-imxplayer-no-picture-issue.patch \
"

SRCREV = "fd056816898c9d03d5385049b49813731f516bfe"
LOCALVERSION = "-1.1.1-edm_fairy"


COMPATIBLE_MACHINE = "(edm-fairy-imx6)"

