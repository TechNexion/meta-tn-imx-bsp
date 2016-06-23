# For TechNexion boards

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx_4.1.15_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "827ab7685ee14ee2fa740b8582db809669dc5a0f"
LOCALVERSION = "-1.1.1-technexion"


COMPATIBLE_MACHINE = "(edm1-cf-imx6)"

