require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "u-boot Technexion boards."
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=025bf9f768cbcb1a165dbe1a110babfb"

PROVIDES += "u-boot"

SRCBRANCH = "tn-mx6sx-2014.04_3.10.53_1.1.0_ga"
SRCREV = "16e85b94af2a34cf9da7e41d65991c8b063abbeb"
SRC_URI = "git://github.com/TechNexion/u-boot-edm.git;branch=${SRCBRANCH}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(edm-goblin-imx6sx)"
