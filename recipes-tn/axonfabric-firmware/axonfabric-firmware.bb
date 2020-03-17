SUMMARY = "Firmware files for Axon Fabric"
SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_tn"
LIC_FILES_CHKSUM = "\
    file://tn-license.txt;md5=e45d720ee54cbc714f0698499845fa04 \
"

require axonfabric-firmware.inc

TECHNEXION_GITHUB_MIRROR ?= "git://github.com/TechNexion/axonfabric-firmware.git"
SRCREV = "${AUTOREV}"

SRC_URI = "${TECHNEXION_GITHUB_MIRROR};branch=${SRCBRANCH}"

S = "${WORKDIR}/git"

FWDIR = "/lib/firmware/axonfabric"

do_install() {
    install -d ${D}${FWDIR}
    install -m 0755 ${S}/${SRCBRANCH}/axon_fabric_imx6_f01-${SRCBRANCH}.jed ${D}${FWDIR}
	install -m 0755 ${S}/${SRCBRANCH}/axon_fabric_imx6_f03-${SRCBRANCH}.jed ${D}${FWDIR}
	install -m 0755 ${S}/${SRCBRANCH}/axon_fabric_imx8mm_f01-${SRCBRANCH}.jed ${D}${FWDIR}
	install -m 0755 ${S}/${SRCBRANCH}/axon_fabric_imx8mm_f03-${SRCBRANCH}.jed ${D}${FWDIR}
}

FILES_${PN}-dbg += "${FWDIR}/.debug"
FILES_${PN} += "${FWDIR}/"

COMPATIBLE_MACHINE = "(mx6|mx8)"
