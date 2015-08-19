
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://touch_cal.sh"

S = "${WORKDIR}"

do_install_append() {
	install -m 0755 ${WORKDIR}/touch_cal.sh ${D}${sysconfdir}/init.d

	update-rc.d -r ${D} touch_cal.sh start 102 2 3 4 5 .
}
