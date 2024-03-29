SUMMARY = "This script creates a NATed or Bridged WiFi Access Point"
HOMEPAGE = "https://github.com/oblique/create_ap"
LICENSE = "BSD-1-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=47819091dc3777f6899ac4e6dbff2613"
DEPENDS = "bash"

SRCREV = "462c09fc88d9d6a6037e8f5b64f14492508bba90"
PV	 = "0.2-git${SRCPV}"

SRC_URI  = "git://github.com/oblique/create_ap.git;protocol=https;branch=master"

S	 = "${WORKDIR}/git"

do_configure() {
        :
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 create_ap ${D}${bindir}
	install -d ${D}${datadir}/bash-completion/completions/
	cp ${S}/bash_completion ${D}${datadir}/bash-completion/completions/create_ap
}

RDEPENDS:${PN} = "bash"

FILES:${PN}-dbg += "${datadir}/bash-completion/completions/.debug"
FILES:${PN} += "${datadir}/bash-completion/completions/"
