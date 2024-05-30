SUMMARY = "WiFi firmware files for TechNexion QCA PCIe module"

SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_qca"
HOMEPAGE = "https://git.codelinaro.org/clo/ath-firmware/ath10k-firmware.git"

LIC_FILES_CHKSUM = "file://ath10k/LICENSE.qca_firmware;md5=74852b14e2b35d8052226443d436a244"

SRCREVATH10K = "ca0916244fb9ae75242585f3bb8397c5732b910c"
SRCREVQCABT = "be98108d402e3aa76e78b978a986db052497014d"

SRC_URI = "git://git.codelinaro.org/clo/ath-firmware/ath10k-firmware.git;protocol=https;branch=main;rev=${SRCREVATH10K};destsuffix=ath10k \
           ${SRCSERVER};branch=${SRCBRANCH}${SRCOPTION};rev=${SRCREVQCABT};subpath=qca;destsuffix=qca \
"

S = "${WORKDIR}"

# Gitlab Personal Access Token: e.g. SbtQ_mC4fvJRA88_9jB7
OVERRIDES_append = "${@'' if (d.getVar('PA_TOKEN', True) is None or len(d.getVar('PA_TOKEN', True)) == 0) else ':token'}"
TOKEN = "${@'' if (d.getVar('PA_TOKEN', True) is None or len(d.getVar('PA_TOKEN', True)) == 0) else '%s' % d.getVar('PA_TOKEN', True)}"
SRCSERVER_token = "git://gitlab.com/technexion-imx/qca_firmware.git"
SRCOPTION_token = ";protocol=https;user=oauth2:${TOKEN}"
SRCBRANCH_token = "caf-wlan/CNSS.LEA.NRT_3.0"

do_configure() {
        :
}

do_compile() {
        :
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/ath10k/QCA9377/hw1.0
    install -d ${D}${nonarch_base_libdir}/firmware/qca

    #Install QCA9377 wifi firmware
    install -m 0755 ${S}/ath10k/QCA9377/hw1.0/board-2.bin ${D}${nonarch_base_libdir}/firmware/ath10k/QCA9377/hw1.0
    install -m 0755 ${S}/ath10k/QCA9377/hw1.0/board.bin ${D}${nonarch_base_libdir}/firmware/ath10k/QCA9377/hw1.0
    install -m 0755 ${S}/ath10k/LICENSE.qca_firmware ${D}${nonarch_base_libdir}/firmware/ath10k/QCA9377/hw1.0
    install -m 0755 ${S}/ath10k/QCA9377/hw1.0/CNSS.TF.1.0/firmware-5.bin_CNSS.TF.1.0-00267-QCATFSWPZ-1 ${D}${nonarch_base_libdir}/firmware/ath10k/QCA9377/hw1.0/firmware-5.bin

    #Install QCA9377 bt firmware
    install -m 0755 ${S}/qca/notice.txt ${D}${nonarch_base_libdir}/firmware/qca
    install -m 0755 ${S}/qca/nvm_usb_00000302.bin ${D}${nonarch_base_libdir}/firmware/qca
    install -m 0755 ${S}/qca/rampatch_usb_00000302.bin ${D}${nonarch_base_libdir}/firmware/qca
}

FILES_${PN}-dbg += "${nonarch_base_libdir}/firmware/.debug"
FILES_${PN} += "${nonarch_base_libdir}/firmware/"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
