FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://psplash-quit.service \
"
SYSTEMD_SERVICE:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', ' psplash-quit.service', '', d)}"

do_install:append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 644 ${UNPACKDIR}/psplash-quit.service ${D}/${systemd_unitdir}/system
    fi
}
