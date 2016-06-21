# For TechNexion boards

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx_4.1.15_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "5cfe4b7f773e2b9694a5213c9a056797eef74bb0"
LOCALVERSION = "-1.1.1-technexion"


COMPATIBLE_MACHINE = "(edm1-cf-imx6)"

