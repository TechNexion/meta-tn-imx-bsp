SUMMARY = "This bash shell script gathers system information for technexion support"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} += "bash"

SRC_URI = "git://github.com/TechNexion-customization/get-support-info.git"
SRCREV = "09c5b84268b221eb0c7cfd5f205c2f94aa6f6b62"

S = "${WORKDIR}/git"

do_install() {
    # Copy get-support-info.sh to ${sbindir} i.e. /usr/sbin
    install -d ${D}${sbindir}
    install -m 0755 ${S}/get-support-info ${D}${sbindir}
}

FILES_${PN} += "${sbindir}/get-support-info"

