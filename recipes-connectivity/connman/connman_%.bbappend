FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
   file://settings \
"

do_install_append() {
	install -d ${D}${localstatedir}/lib/connman
    install -m 0644 ${WORKDIR}/settings ${D}${localstatedir}/lib/connman
}

COMPATIBLE_MACHINE_edm-fairy-imx6 = "(edm-fairy-imx6)"
COMPATIBLE_MACHINE_edm-toucan-imx6 = "(edm-toucan-imx6)"
