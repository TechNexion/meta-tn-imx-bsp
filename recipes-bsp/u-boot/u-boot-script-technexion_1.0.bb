FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "u-boot bootscript for TechNexion specific image"
DESCRIPTION = "Boot script for launching bootable disk images on TechNexion products"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://README;md5=34187c3c5d1f19b2facd3f93dad26def"

DEPENDS = "u-boot-mkimage-native"

PR = "r0"

COMPATIBLE_MACHINE = "(imx-nxp-bsp)"

SRC_URI = "file://README \
		   file://bootscript-tsl-arm64.txt \
		  "

inherit deploy

do_compile() {
    mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
        -n "TechNexion boot script" -d ${UNPACKDIR}/bootscript-tsl-arm64.txt \
        ${B}/boot.scr
}

do_install() {
    install -d ${D}/boot
    install -m 0644 ${B}/boot.scr ${D}/boot/boot.scr
}

FILES:${PN} += "/boot /boot/boot.scr"

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${B}/boot.scr ${DEPLOYDIR}/boot.scr
}

addtask deploy after do_install before do_build