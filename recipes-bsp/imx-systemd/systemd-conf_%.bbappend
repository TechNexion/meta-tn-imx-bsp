FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://tn-imx-ethernet-unmanaged.network \
"

do_install:append () {
    install -D -m0644 ${S}/tn-imx-ethernet-unmanaged.network ${D}${systemd_unitdir}/network/10-ethernet-unmanaged.network
}

FILES:${PN} += " \
    ${sysconfdir}/systemd/system/ \
    ${sysconfdir}/udev/rules.d/ \
"
