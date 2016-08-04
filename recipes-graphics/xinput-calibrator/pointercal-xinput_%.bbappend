FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://pointercal.xinput.new"

do_install_append() {
    install -d ${D}${sysconfdir}/
    install -m 0644 ${S}/pointercal.xinput.new ${D}${sysconfdir}/pointercal.xinput
}
