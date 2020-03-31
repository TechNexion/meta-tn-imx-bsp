# Copyright (C) 2020 TechNexion Ltd.

SUMMARY = "TechNexion QCA Btdiag"
DESCRIPTION = "Btdiag of QDART client for TechNexion QCA BT modules"
SECTION = "app"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://notice.txt;md5=912c8fae0926ab3ef757331fc96b5d70"

SRCBRANCH = "master"
TN_QDART_BT_TOOL_SRC = "git://gitlab.com/technexion-imx/btdiag.git;protocol=https;user=oauth2:${PA_TOKEN}"
SRC_URI = "${TN_QDART_BT_TOOL_SRC};branch=${SRCBRANCH} \
           file://fcc-btdiag@.service \
"
SRCREV = "be84f595b8daa1ea150b09d969390380589c4973"

inherit distro_features_check
REQUIRED_DISTRO_FEATURES = "systemd fcc"

S = "${WORKDIR}/git"

FILES_${PN} += " /usr/sbin/Btdiag \
                 ${systemd_unitdir}/system/fcc-btdiag@.service \
"

do_check() {
    if [ -z "${PA_TOKEN}" ]; then
        bberror "Download QCA Btdiag tool requires personal access token (Please contact TechNexion: sales@technexion.com)"
    fi
}

addtask check before do_fetch

do_install() {
    install -d "${D}/usr/sbin/"
    install -m 0755 ${S}/Btdiag "${D}/usr/sbin/"

    if [ -n "${SERIAL_BLUETOOTH}" ] ; then
        install -d ${D}${systemd_unitdir}/system/
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
        install -m 0644 ${WORKDIR}/fcc-btdiag@.service ${D}${systemd_unitdir}/system/
        # enable the service
        ttydev=`echo "${SERIAL_BLUETOOTH}" | sed -e 's/^[0-9]*\;//' -e 's/\;.*//'`
        ln -sf ${systemd_unitdir}/system/fcc-btdiag@.service \
                ${D}${sysconfdir}/systemd/system/multi-user.target.wants/fcc-btdiag@$ttydev.service
    fi
}
