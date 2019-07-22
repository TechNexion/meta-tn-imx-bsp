do_install_append_autologin() {
	if [ ! -z "${SERIAL_CONSOLES}" ] ; then
		sed -i -e 's/agetty/agetty -a root/g' ${D}${systemd_unitdir}/system/serial-getty@.service
	fi
}