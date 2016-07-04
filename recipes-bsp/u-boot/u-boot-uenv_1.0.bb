SUMMARY = "u-boot uEnv.txt"
DESCRIPTION = "u-boot uEnv.txt"
SECTION = "base"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://README;md5=6e3b4d22a2346e07c446bc8dca914ae4"

SRC_URI += " \
   file://uEnv.txt \
   file://README \
"
S = "${WORKDIR}"

inherit deploy

do_deploy() {
	install -d ${DEPLOYDIR}
	install ${S}/uEnv.txt ${DEPLOYDIR}/uEnv.txt
}

addtask deploy after do_install before do_build

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6)"
