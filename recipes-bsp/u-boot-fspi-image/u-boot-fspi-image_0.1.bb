SUMMARY = "flexspi u-boot image"
SECTION = "devel"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://fspi_u-boot.bin;md5=251102100b92ca9c246bfdf93ad5b2a4"

SRC_URI += " \
    file://fspi_u-boot.bin \
"

S = "${WORKDIR}"

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0755 ${S}/fspi_u-boot.bin ${DEPLOYDIR}/
}

addtask deploy after do_install

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx8mp)"
