FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
        file://terminal.png \
        file://0001-backend-drm-dmabuf-leak-during-hdmi-hotplug.patch \
"

do_install_append() {
    install -d ${D}${datadir}/weston
    install ${WORKDIR}/terminal.png ${D}${datadir}/weston
}
