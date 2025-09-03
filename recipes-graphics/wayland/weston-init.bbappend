#
# Modified Startup script and systemd unit file for the Weston Wayland compositor
#
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://setup-weston-init.sh \
             file://90-hdmi-hotplug.rules"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

do_install:append() {
	install -d ${D}${bindir}
	install -p -m 0755 ${S}/setup-weston-init.sh ${D}${bindir}

	install -d ${D}${sysconfdir}/udev/rules.d
	install -p -m 0644 ${S}/90-hdmi-hotplug.rules ${D}${sysconfdir}/udev/rules.d

	sed -i '/^ExecStart=\/usr\/bin\/weston*/i ExecStartPre=-\/usr\/bin\/setup-weston-init.sh' ${D}${systemd_system_unitdir}/weston.service

	insert_line_after "After=plymouth-quit-wait.service" "# If Psplash is used, terminate psplash before starting weston" ${D}${systemd_system_unitdir}/weston.service
	insert_line_after "# If Psplash is used, terminate psplash before starting weston" "After=psplash-quit.service" ${D}${systemd_system_unitdir}/weston.service
}

SOFTWARE_RENDER = "true"
SOFTWARE_RENDER:imxgpu2d = "false"
SOFTWARE_RENDER:imxgpu3d = "false"

do_install:append:rescue() {
	if [ "${SOFTWARE_RENDER}" = "true" ]; then
		sed -i 's/^use-g2d=true/#use-g2d=true/' ${D}${sysconfdir}/xdg/weston/weston.ini
		sed -i '/^#use-g2d=true/a renderer=pixman' ${D}${sysconfdir}/xdg/weston/weston.ini
	fi
}

FILES:${PN} += "${bindir}/setup-weston-init.sh"
FILES:${PN} += "${sysconfdir}/udev/rules.d/90-hdmi-hotplug.rules"
