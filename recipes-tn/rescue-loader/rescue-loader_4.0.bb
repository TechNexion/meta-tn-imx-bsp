SUMMARY  = "TechNexion Rescue Loader Python Scripts"
DESCRIPTION = "Python scripts to run on target board to download sdcard image and program the eMMC"
HOMEPAGE = "https://github.com/TechNexion-customization/rescue-loader"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780"

require rescue-loader.inc

SRC_URI = "${SRCSERVER};branch=${SRCREV}"
S = "${WORKDIR}/git"

RDEPENDS_${PN} = " \
	bash \
	directfb \
	libudev \
	${PYTHON_PN}-debugger \
	${PYTHON_PN}-threading \
	${PYTHON_PN}-datetime \
	${PYTHON_PN}-pickle \
	${PYTHON_PN}-jsonpatch \
	${PYTHON_PN}-pygobject \
	${PYTHON_PN}-dbus \
	${PYTHON_PN}-lxml \
	${PYTHON_PN}-pyudev \
	${PYTHON_PN}-pyserial \
	${PYTHON_PN}-psutil \
	${PYTHON_PN}-pyusb \
	${PYTHON_PN}-pyqrcode \
	${PYTHON_PN}-pyqt \
	"

inherit setuptools3

REQUIRED_DISTRO_FEATURES = "systemd"

BBCLASSEXTEND = "nativesdk"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${systemd_unitdir}/system/dbus.target.wants/
	install -d ${D}${systemd_unitdir}/system/sockets.target.wants/
	install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/
	install -d ${D}${sysconfdir}/profile.d/
	install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/

	# directfb config file
	install -m 0644 ${S}/rescue_loader/directfbrc ${D}${sysconfdir}
	#install -m 0644 ${S}/rescue_loader/directfbrc-no-tslib ${D}${sysconfdir}/directfbrc

	# rescue-loader xml config file
	install -m 0644 ${S}/rescue_loader/installer.xml ${D}${sysconfdir}

	# rescue-loader installerd systemd service files
	install -m 0644 ${S}/rescue_loader/installerd.service ${D}${systemd_unitdir}/system/
	ln -sf ${systemd_unitdir}/system/installerd.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/installerd.service

	# guiclientd.conf
	# for Portrait Panel, rotate qws and set touch input
	# QWS_DISPLAY=transformed:rot270 directfb:0
	# QWS_MOUSE_PROTO=linuxinput:/dev/input/event1
	# otherwise, just sets the directfb:0, others settings follow qt4 defaults
	echo "DBUS_SESSION_BUS_ADDRESS=unix:path=/var/run/dbus/session_bus_socket" > ${D}${sysconfdir}/systemd/guiclientd.conf
	if [ -n ${DISPLAY_PANEL} -a ${DISPLAY_PANEL} = "ili9881c" ]; then
		echo "QWS_DISPLAY=transformed:mmWidth140:mmHeight68:rot270 directfb:0" >> ${D}${sysconfdir}/systemd/guiclientd.conf
		echo "QWS_MOUSE_PROTO=linuxinput:/dev/input/event1" >> ${D}${sysconfdir}/systemd/guiclientd.conf
	else
		echo "QWS_DISPLAY=directfb:0" >> ${D}${sysconfdir}/systemd/guiclientd.conf
	fi
	echo "ARG=-qws" >> ${D}${sysconfdir}/systemd/guiclientd.conf

	# rescue-loader guiclientd systemd service files
	install -m 0644 ${S}/rescue_loader/guiclientd.service ${D}${systemd_unitdir}/system/
	ln -sf ${systemd_unitdir}/system/guiclientd.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/guiclientd.service

	# dbus session socket
	install -m 0644 ${S}/rescue_loader/dbus-sess.socket ${D}${systemd_unitdir}/system/
	ln -sf ${systemd_unitdir}/system/dbus-sess.socket ${D}${systemd_unitdir}/system/dbus.target.wants/dbus-sess.socket
	ln -sf ${systemd_unitdir}/system/dbus-sess.socket ${D}${systemd_unitdir}/system/sockets.target.wants/dbus-sess.socket

	# dbus session service
	install -m 0644 ${S}/rescue_loader/dbus-sess.service ${D}${systemd_unitdir}/system/
	ln -sf ${systemd_unitdir}/system/dbus-sess.service ${D}${systemd_unitdir}/system/multi-user.target.wants/dbus-sess.service

	# export DBUS_SESSION_BUS_ADDDRESS=unix:path=/var/run/dbus/session_bus_socket through dbus-export.sh in /etc/profile
	install -m 0755 ${S}/rescue_loader/dbus-export.sh ${D}${sysconfdir}/profile.d/dbus-export.sh

	# export QWS_DISPLAY=directfb:0 through qt4-export.sh in /etc/profile
	install -m 0755 ${S}/rescue_loader/qt4-export.sh ${D}${sysconfdir}/profile.d/qt4-export.sh
}

FILES_${PN} += " \
	${sysconfdir}/directfbrc \
	${sysconfdir}/installer.xml \
	${systemd_unitdir}/system/installerd.service \
	${sysconfdir}/systemd/system/multi-user.target.wants/installerd.service \
	${sysconfdir}/systemd/system/guiclientd.conf \
	${systemd_unitdir}/system/guiclientd.service \
	${sysconfdir}/systemd/system/multi-user.target.wants/guiclientd.service \
	${systemd_unitdir}/system/dbus-sess.socket \
	${systemd_unitdir}/system/dbus.target.wants/dbus-sess.socket \
	${systemd_unitdir}/system/sockets.target.wants/dbus-sess.socket \
	${systemd_unitdir}/system/dbus-sess.service \
	${systemd_unitdir}/system/multi-user.target.wants/dbus-sess.service \
	${sysconfdir}/profile.d/dbus-export.sh \
	${sysconfdir}/profile.d/qt4-export.sh "

