SUMMARY = "i.MX95 M7 core Demo binaries"
DESCRIPTION = "Prebuilt FreeRTOS firmware for Cortex-M core"
SECTION = "app"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRCBRANCH = "freertos_25.09.0"
M4_SRC = "git://github.com/TechNexion/imx-m4-demos-tn.git;protocol=https"
SRC_URI = "${M4_SRC};branch=${SRCBRANCH}"
SRCREV = "cb28959996e2b7496cf58aa7bacab33a201f6e7f"

inherit deploy

do_deploy() {
	install -d ${DEPLOYDIR}
	install ${S}/${M7_MACHINE}/* ${DEPLOYDIR}/
}

addtask deploy after do_install

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx95-nxp-bsp)"
