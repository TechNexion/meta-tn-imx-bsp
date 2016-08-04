# For TechNexion boards

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-imx_4.1.15_1.1.0_ga"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "f1fa786c9f7348ad35ebfe88e0451187ad253d6d"
LOCALVERSION = "-1.1.1-technexion"


COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7)"

