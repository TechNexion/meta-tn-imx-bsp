DESCRIPTION = "Utility to configure and test Broadcom Bluetooth chips"
SECTION = "base"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://brcm_patchram_plus.c"
TARGET_CC_ARCH += "${LDFLAGS}"

S = "${WORKDIR}"

do_compile() {
	${CC} brcm_patchram_plus.c -o brcm_patchram_plus
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 brcm_patchram_plus ${D}${bindir}
}


FILES_${PN}-dbg += "/lib/firmware/brcm.debug"
FILES_${PN} += "/lib/firmware/brcm"
