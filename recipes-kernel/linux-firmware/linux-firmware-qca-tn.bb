SUMMARY = "WiFi firmware files for TechNexion QCA module"
SECTION = "kernel"
LICENSE = "Proprietary"

LIC_FILES_CHKSUM = "\
    file://README;md5=7f59cc620b234e99b85d4474c84e5b7c \
"

SRC_URI += " \
    file://README \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/firmware/
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7|mx8)"
