FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://10-ethernet-unmanaged.network"

do_install:append() {
    install -D -m0644 ${S}/10-ethernet-unmanaged.network ${D}${systemd_unitdir}/network/10-ethernet-unmanaged.network
}