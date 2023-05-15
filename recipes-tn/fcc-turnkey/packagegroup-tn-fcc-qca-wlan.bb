# Copyright (C) 2020 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Detemine Correct TechNexion's WIFI FCC firmware and drivers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit packagegroup distro_features_check
REQUIRED_DISTRO_FEATURES = "fcc"

PACKAGES_remove_brcm = "linux-firmware-brcm"
PACKAGES_remove_ath-pci = "linux-firmware-ath10k"
PACKAGES_remove_qca = "linux-firmware-qca"
RDEPENDS_${PN}_append_qca = " linux-firmware-qca-fcc-tn"

# Extra Kernel Modules
RDEPENDS_${PN}_append = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '',d)}"
