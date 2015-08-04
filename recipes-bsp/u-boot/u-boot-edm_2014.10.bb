require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "u-boot Technexion boards."
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

PROVIDES += "u-boot"

SRCBRANCH = "tn-mx6-patches-2014.10_3.10.53_1.1.0_ga"
SRCREV = "341788de56184a6f15b21896ca5ecfed50e966aa"
SRC_URI = "git://github.com/TechNexion/u-boot-edm.git;branch=${SRCBRANCH} \
           file://0001-edm-cf-imx6-put-SPL-into-raw-eMMC-instead-of-1st-FAT.patch \
           file://0002-edm-cf-imx6-put-zImage-and-dtb-into-root-directory-i.patch"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(edm-fairy-imx6)"
