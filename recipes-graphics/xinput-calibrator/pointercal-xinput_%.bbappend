FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_mx6 += "file://pointercal.xinput.new"

do_install_append_mx6() {
    install -d ${D}${sysconfdir}/
    install -m 0644 ${S}/pointercal.xinput.new ${D}${sysconfdir}/pointercal.xinput
}
