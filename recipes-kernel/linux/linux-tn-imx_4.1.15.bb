# For TechNexion boards

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx_4.1.15_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "14bdfda09c2e5cd9b069070103827a265ee9bf91"
LOCALVERSION = "-1.1.1-technexion"


COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7)"

