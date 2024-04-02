SUMMARY = "SystemD service to expand partition size for TechNexion products"
SECTION = "devel"

LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=783b7e40cdfb4a1344d15b1f7081af66"


SRC_URI += " \
    file://LICENSE \
    file://rc-local.service \
    file://rc.local \
    file://20-wired.network \
"

S = "${WORKDIR}"

inherit systemd allarch

do_install () {
    install -d ${D}${sysconfdir}/systemd/system
    install -m 0644 ${S}/rc-local.service ${D}${sysconfdir}/systemd/system/rc-local.service

    install -d ${D}${sysconfdir}
    install -m 0755 ${S}/rc.local ${D}${sysconfdir}

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/20-wired.network ${D}${sysconfdir}/systemd/network/
}

FILES:${PN} = "${sysconfdir}/rc.local ${sysconfdir}/systemd/network/20-wired.network"

SYSTEMD_SERVICE:${PN} = "rc-local.service"
RDEPENDS:${PN} += "bash"
