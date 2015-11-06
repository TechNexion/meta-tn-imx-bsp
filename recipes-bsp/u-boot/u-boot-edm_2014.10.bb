require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "u-boot Technexion boards."
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

PROVIDES += "u-boot"

SRCBRANCH = "tn-mx6-patches-2014.10_3.10.53_1.1.0_ga"
SRCREV = "613462ad017f7ba6adcfa8bc04afabf93f00f0e5"
SRC_URI = "git://github.com/TechNexion/u-boot-edm.git;branch=${SRCBRANCH} \
           file://0001-edm-cf-imx6-put-SPL-into-raw-eMMC-instead-of-1st-FAT.patch \
           file://0002-edm-cf-imx6-put-zImage-and-dtb-into-root-directory.patch \
           file://0003-edm-cf-imx6-put-uEnv.txt-into-root-directory-instead.patch \
           file://uEnv_lvds7.txt \
           file://uEnv_hdmi720p.txt \
           file://uEnv_hdmi1080p.txt \
           file://uEnv_lcd.txt \
           file://uEnv_lvds7_hdmi720p.txt \
           file://uEnv_custom.txt \
           "

deploy_uenv () {
	install ${WORKDIR}/uEnv_lvds7.txt ${DEPLOYDIR}/uEnv_lvds7.txt
	install ${WORKDIR}/uEnv_hdmi720p.txt ${DEPLOYDIR}/uEnv_hdmi720p.txt
	install ${WORKDIR}/uEnv_hdmi1080p.txt ${DEPLOYDIR}/uEnv_hdmi1080p.txt
	install ${WORKDIR}/uEnv_lcd.txt ${DEPLOYDIR}/uEnv_lcd.txt
	install ${WORKDIR}/uEnv_lvds7_hdmi720p.txt ${DEPLOYDIR}/uEnv_lvds7_hdmi720p.txt
	install ${WORKDIR}/uEnv_custom.txt ${DEPLOYDIR}/uEnv_custom.txt
}

do_deploy[postfuncs] += "deploy_uenv"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(edm-fairy-imx6|edm-toucan-imx6|picosom-dwarf-imx6)"
