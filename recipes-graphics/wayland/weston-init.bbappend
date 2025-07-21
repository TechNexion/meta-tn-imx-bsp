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
}

FILES:${PN} += "${bindir}/setup-weston-init.sh"
FILES:${PN} += "${sysconfdir}/udev/rules.d/90-hdmi-hotplug.rules"
