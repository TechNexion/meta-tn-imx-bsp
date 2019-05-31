# Copyright 2017-2018 TN
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Detemine Correct TechNexion's WIFI firmware and drivers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit packagegroup

# Extra Kernel Firmwares
FW = "${@'' if d.getVar('RF_FIRMWARES', True) is None else ':'.join([fw.lower() for fw in d.getVar('RF_FIRMWARES', True).split(' ') if fw])}"
OVERRIDES .= ":${FW}"
# QCA
PACKAGES_${PN}_remove_qca = " linux-firmware-qca"
RDEPENDS_${PN}_append_qca = " linux-firmware-qca-tn"
# BRCM
PACKAGES_${PN}_remove_brcm = " linux-firmware-brcm"
RDEPENDS_${PN}_append_brcm = " linux-firmware-brcm-tn"
# ATH10K
PACKAGES_${PN}_remove = " linux-firmware-ath10k"
RDEPENDS_${PN}_append_ath-pci = " linux-firmware-ath10k-tn"

# Extra Kernel Modules
#MACHINE_EXTRA_RRECOMMENDS_append = " kernel-module-qcacld-tn"
RRECOMMENDS_${PN}_append_qca = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '',d)}"
