FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

TN_FILES = " file://default.pa \
             file://pulseaudio.service \
"
SRC_URI_append_mx6 = "${TN_FILES}"
SRC_URI_append_mx7 = "${TN_FILES}"

inherit systemd

do_install_append() {
    # Install pulseaudio systemd service
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'false', 'true', d)}; then
            install -m 644 -p -D ${WORKDIR}/build/src/pulseaudio.service ${D}${systemd_user_unitdir}/pulseaudio.service
            install -m 644 -p -D ${WORKDIR}/pulseaudio-${PV}/src/daemon/systemd/user/pulseaudio.socket ${D}${systemd_user_unitdir}/pulseaudio.socket

            # Execute these manually on behalf of systemctl script (from systemd-systemctl-native.bb)
            # because it does not support systemd's user mode.
            install -d ${D}${systemd_user_unitdir}/sockets.target.wants/
            ln -sf ${systemd_user_unitdir}/pulseaudio.socket ${D}${systemd_user_unitdir}/sockets.target.wants/

            install -d ${D}${systemd_user_unitdir}/default.target.wants/
            ln -sf ${systemd_user_unitdir}/pulseaudio.service ${D}${systemd_user_unitdir}/default.target.wants/
        fi
    fi
}

install_for_x11() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'true', 'false', d)}; then
            if [ -e "${WORKDIR}/default.pa" ]; then
                install -m 0644 ${WORKDIR}/default.pa ${D}${sysconfdir}/pulse/default.pa
            fi

            # Install pulseaudio systemd service
            install -d ${D}${systemd_unitdir}/system/
            install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
            install -m 0644 ${WORKDIR}/pulseaudio.service ${D}${systemd_unitdir}/system/
            # enable the service
            ln -sf ${systemd_unitdir}/system/pulseaudio.service \
                    ${D}${sysconfdir}/systemd/system/multi-user.target.wants/pulseaudio.service
        fi
    fi
}

do_install_append_mx6() {
    install_for_x11
}

do_install_append_mx7() {
    install_for_x11
}

FILES_${PN}-server += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_user_unitdir}/pulseaudio.socket', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_user_unitdir}/sockets.target.wants/pulseaudio.socket', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_user_unitdir}/pulseaudio.service', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_user_unitdir}/default.target.wants/pulseaudio.service', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${sysconfdir}/pulse/default.pa', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}/system/pulseaudio.service', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${sysconfdir}/systemd/system/multi-user.target.wants/pulseaudio.service', '', d)} \
"
