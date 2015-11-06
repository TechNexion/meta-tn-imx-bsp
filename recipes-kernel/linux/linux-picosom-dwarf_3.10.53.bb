# TechNexion PicoSOM i.mx6 with Dwarf baseboard

LICENSE = "GPLv2"

require recipes-kernel/linux/linux-imx.inc
require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native bc-native"

SRCBRANCH = "tn-mx6-3.10.53-1.1.0_ga-update1"

SRC_URI = "git://github.com/TechNexion/linux.git;branch=${SRCBRANCH} \
           file://defconfig \
           file://0001-picosom-imx6-yocto-fix-imxplayer-no-picture-issue.patch \
"

SRCREV = "a071569f3d4f64ee2ab914c9ddce4b5d1084c00d"
LOCALVERSION = "-1.1.1-picosom_dwarf"

COMPATIBLE_MACHINE = "(picosom-dwarf-imx6)"
