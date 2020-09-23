PACKAGECONFIG_remove_rescue = "logind vconsole"

do_install_append_rescue() {
    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service
}
