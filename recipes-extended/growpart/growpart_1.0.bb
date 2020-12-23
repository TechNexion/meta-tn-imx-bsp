UMMARY = "Growpart scripts to resize emmc to maximum available size"
DESCRIPTION = "Growpart scripts"
SECTION = "app"
LICENSE = "GPLv3"
LICENSE_FLAGS = "commercial_tn"

LIC_FILES_CHKSUM = "file://growpart.sh;md5=3b7fb1e38951060405984a6627f550b7"

SRC_URI += " \
    file://tn-standby.jpg \
    file://growpart.sh \
    file://tn-first-boot.sh \
    file://tn-growpart.service \
"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install () {
	# add the jpg to /etc/xdg/weston/
        install -d ${D}${sysconfdir}/xdg/weston/
        install -m 0644 ${S}/tn-standby.jpg ${D}${sysconfdir}/xdg/weston/
	# add the service to systemd
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 0644 ${S}/tn-growpart.service ${D}${systemd_unitdir}/system/
	# enable the service
	ln -sf ${systemd_unitdir}/system/tn-growpart.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/tn-growpart.service

	# install growpart script and tn-first-boot
	install -d ${D}${bindir}
	install -m 0755 ${S}/growpart.sh ${D}${bindir}/growpart
	install -m 0755 ${S}/tn-first-boot.sh ${D}${bindir}/tn-first-boot
}

FILES_${PN} += "${bindir}"
FILES_${PN} += "${sysconfdir}/xdg/weston/"
FILES_${PN} += "${systemd_unitdir}/system/"
FILES_${PN} += "${sysconfdir}/systemd/system/multi-user.target.wants/"

RDEPENDS_${PN} += "bash systemd-container util-linux e2fsprogs"

LICENSE_FLAGS_WHITELIST += "commercial_tn"
