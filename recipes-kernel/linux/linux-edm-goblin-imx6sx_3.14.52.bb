# TechNexion EDM1-CF-IMX6 with Fairy baseboard

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx-3.14.52_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "d32798270e2c8b34cbffcfa57c03c2822f418ddc"
LOCALVERSION = "-1.1.1-edm_goblin_imx6sx"


COMPATIBLE_MACHINE = "(edm-goblin-imx6sx)"

