# For TechNexion boards

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx_4.1.15_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "ad04b69f2967d6086fe677300421f85faf5d33d8"
LOCALVERSION = "-1.1.1-technexion"


COMPATIBLE_MACHINE = "(edm1-cf-imx6|edm1-cf-imx6-no-console|pico-imx6|tek-imx6)"

