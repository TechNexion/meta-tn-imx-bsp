SUMMARY = "SystemD service to expand partition size for TechNexion products"
SECTION = "devel"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI += " \
    file://lanbypass_on.sh \
"

do_install () {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/lanbypass_on.sh ${D}${sbindir}
}

FILES:${PN} = "${sbindir}/lanbypass_on.sh"
RDEPENDS:${PN} = "bash util-linux"
RDEPENDS:${PN}:ubuntu = "bash"
