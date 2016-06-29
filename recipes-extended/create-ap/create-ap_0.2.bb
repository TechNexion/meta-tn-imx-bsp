SUMMARY = "This script creates a NATed or Bridged WiFi Access Point"
HOMEPAGE = "https://github.com/oblique/create_ap"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=47819091dc3777f6899ac4e6dbff2613"

SRCREV = "ac87711075e21a92ff9f9e8f0930c20b16486a29"
PV	 = "0.2-git${SRCPV}"

SRC_URI  = "git://github.com/oblique/create_ap.git"
	    
S	 = "${WORKDIR}/git"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 create_ap ${D}${bindir}
	install -d ${D}${datadir}/bash-completion/completions/
	cp ${S}/bash_completion ${D}${datadir}/bash-completion/completions/create_ap
}

FILES_${PN}-dbg += "${datadir}/bash-completion/completions/.debug"
FILES_${PN} += "${datadir}/bash-completion/completions/"
