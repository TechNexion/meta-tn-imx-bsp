SUMMARY = "u-boot boot.scr.uimg"
DESCRIPTION = "Boot script for launching bootable disk images on TechNexion products"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://README;md5=34187c3c5d1f19b2facd3f93dad26def"

DEPENDS = "u-boot-mkimage-native"

PR = "r0"

SRC_URI = " \
		file://README \
		file://boot.scr \
"

SRC_URI_append_rescue = " file://boot.scr.tsl"

S = "${WORKDIR}"

inherit deploy

do_configure_append_rescue () {
    cp ${S}/boot.scr.tsl ${S}/boot.scr
}

do_compile () {
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
	              -n "TechNexion boot script" -d ${S}/boot.scr \
	              ${S}/boot.scr.uimg
}

do_deploy () {
	install -d ${DEPLOYDIR}
	install -m 0644 ${S}/boot.scr.uimg ${DEPLOYDIR}
}

addtask deploy after do_install before do_build

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
