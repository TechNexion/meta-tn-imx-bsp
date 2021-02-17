FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SUMMARY = "Python Qt4 Bindings"
AUTHOR = "Phil Thomson @ riverbank.co.uk (Modified by po.cheng@technexion.com)"
HOMEPAGE = "http://riverbankcomputing.co.uk"
SECTION = "devel/python"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "\
    file://LICENSE.GPL3;md5=feee51612c3c1191a1d5f41156fa2c75 \
"
DEPENDS = "sip3 sip3-native python3"

SRC_URI = "\
    https://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-${PV}/PyQt-x11-gpl-${PV}.tar.gz \
"

SRC_URI[md5sum] = "997c3e443165a89a559e0d96b061bf70"
SRC_URI[sha256sum] = "853780dcdbe2e6ba785d703d059b096e1fc49369d3e8d41a060be874b8745686"

SRC_URI += "\
    file://0001-configure-skip-qtdetail.patch \
    file://0002-configure-set-qws.patch \
    file://0003-sip-add_qws.patch \
    file://0004-sip-QtGuit-hide-qfont-cachestatistics.patch \
    file://0005-sip-fix_qws_handle.patch \
    file://0006-build-PyQt-into-Python-Dbus-mainloop.patch \
"

S = "${WORKDIR}/PyQt-x11-gpl-${PV}"

PARALLEL_MAKE = ""

inherit qt4e python3native python3-dir distro_features_check
# depends on qt4-embedded
DISTRO_FEATURES_remove = "x11 wayland"

DISABLED_FEATURES = "PyQt_Desktop_OpenGL PyQt_Accessibility PyQt_SessionManager PyQt_Shortcut PyQt_RawFont PyQt_OpenSSL PyQt_SQL PyQt_Script"

DISABLED_FEATURES_append_arm = " PyQt_qreal_double"

PYQT_MODULES = "QtCore QtGui QtDeclarative QtNetwork QtDBus QtSvg"
PYQT_MODULES_aarch64 = "QtCore QtGui QtDeclarative QtNetwork QtDBus QtSvg"

PYQT_FLAVOR = "${@bb.utils.contains('QT_BASE_NAME', 'qt4-embedded', 'WS_QWS', 'WS_X11', d)}"

do_configure() {
	echo "py_platform = linux" > pyqt.cfg
	echo "py_inc_dir = %(sysroot)/$includedir/python%(py_major).%(py_minor)${PYTHON_ABI}" >> pyqt.cfg
	echo "py_pylib_dir = %(sysroot)/${libdir}/python%(py_major).%(py_minor)${PYTHON_ABI}" >> pyqt.cfg
	echo "py_pylib_lib = python%(py_major).%(py_minor)${PYTHON_ABI}" >> pyqt.cfg
	echo "pyqt_module_dir = ${D}/${libdir}/python%(py_major).%(py_minor)/site-packages" >> pyqt.cfg
	echo "pyqt_bin_dir = ${D}/${bindir}" >> pyqt.cfg
	echo "pyqt_sip_dir = ${D}/${datadir}/sip/PyQt4" >> pyqt.cfg
	echo "pyuic_interpreter = ${D}/${bindir}/python%(py_major).%(py_minor)" >> pyqt.cfg
	echo "pyqt_disabled_features = ${DISABLED_FEATURES}" >> pyqt.cfg
	echo "qt_shared = True" >> pyqt.cfg
	echo "[Qt 4.8]" >> pyqt.cfg
	echo "pyqt_modules = ${PYQT_MODULES}" >> pyqt.cfg
	echo yes | ${PYTHON} configure-ng.py --verbose --qmake ${STAGING_BINDIR_NATIVE}/qmake2 --configuration pyqt.cfg --sysroot ${STAGING_DIR_HOST} -w --confirm-license --no-designer-plugin --no-docstrings --no-sip-files --qt-flavor=${PYQT_FLAVOR}
}

do_install() {
	oe_runmake install
}

RDEPENDS_${PN} = "python3-core python3-sip3"

FILES_${PN} += "${libdir}/${PYTHON_DIR}/site-packages ${datadir}/sip/PyQt4/"
FILES_${PN}-dbg += "${libdir}/${PYTHON_DIR}/site-packages/*/.debug/"

