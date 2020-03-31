# Copyright (C) 2020 TechNexion Ltd.

SUMMARY = "WiFi FCC firmware files for TechNexion QCA module"
SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_qca"
LIC_FILES_CHKSUM = "\
    file://qca9377/CadenceLicense.txt;md5=2d7b27d27db072fdc7383e37e76b848f \
"

SRCBRANCH = "master"
TN_QCA_FCC_FIRMWARE_SRC = "git://gitlab.com/technexion-imx/qca_fcc_firmware.git;protocol=https;user=oauth2:${PA_TOKEN}"
SRC_URI = "${TN_QCA_FCC_FIRMWARE_SRC};branch=${SRCBRANCH}"
SRCREV = "c62b776f4f5442c9ee1fc8ac57304e767dd1df50"

do_check() {
    if [ -z "${PA_TOKEN}" ]; then
        bberror "Download QCA FCC Firmware requires personal access token (Please contact TechNexion: sales@technexion.com)"
    fi
}

addtask check before do_fetch

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/lib/firmware/
    cp -r ${S}/qca/ ${D}/lib/firmware/
    cp -r ${S}/qca9377/ ${D}/lib/firmware/
    cp -r ${S}/qca6174/ ${D}/lib/firmware/
    cp -r ${S}/wlan/ ${D}/lib/firmware/
}

FILES_${PN}-dbg += "/lib/firmware/.debug"
FILES_${PN} += "/lib/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx6ul|mx7|mx8)"

