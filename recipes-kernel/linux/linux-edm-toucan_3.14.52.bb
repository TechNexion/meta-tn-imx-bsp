# TechNexion EDM1-CF-IMX6 with Toucan baseboard

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx-3.14.52_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
           file://0001-fix-imxplayer-no-picture-issue.patch \
           file://0002-edm1-cf-imx6-Toucan-audio-route-using-Line-Out.patch \
"

SRCREV = "d32798270e2c8b34cbffcfa57c03c2822f418ddc"
LOCALVERSION = "-1.1.1-edm_toucan"


COMPATIBLE_MACHINE = "(edm-toucan-imx6)"

