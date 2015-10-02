# TechNexion EDM1-CF-IMX6 with Fairy baseboard

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-mx6-3.10.53-1.1.0_ga-update1"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
"

SRCREV = "194e5b498e0615e9321e0096787d2fbd6effa3ee"
LOCALVERSION = "-1.1.1-edm_goblin_imx6sx"


COMPATIBLE_MACHINE = "(edm-goblin-imx6sx)"

