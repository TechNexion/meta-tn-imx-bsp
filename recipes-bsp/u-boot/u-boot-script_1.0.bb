SUMMARY = "u-boot boot.scr.uimg"
DESCRIPTION = "Boot script for launching bootable disk images on TechNexion products"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://README;md5=34187c3c5d1f19b2facd3f93dad26def"

DEPENDS = "u-boot-mkimage-native"

PR = "r0"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

SRCSERVER = "git://github.com/TechNexion/u-boot-edm.git"
SRCREV = "eebb8d2b3c52eef3ac30e2e3c05bc0d850ef6b20"
SRCBRANCH = "tn-imx_v2018.03_4.14.98_2.0.0_ga-boot.scr"
SRCOPTIONS = ";protocol=git"
SRC_URI = " \
		file://README \
		${SRCSERVER};branch=${SRCBRANCH}${SRCOPTIONS} \
"

S = "${WORKDIR}/git"

do_compile() {
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "TechNexion boot script" -d ${S}/boot.scr ${WORKDIR}/boot.scr.uimg
}

inherit deploy

do_deploy() {
	install -d ${DEPLOYDIR}
	install -m 0644 ${WORKDIR}/boot.scr.uimg ${DEPLOYDIR}
}

addtask deploy after do_compile before do_build

PACKAGE_ARCH = "${MACHINE_ARCH}"

