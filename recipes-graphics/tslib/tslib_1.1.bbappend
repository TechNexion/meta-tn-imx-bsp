# Append path for freescale layer to include bsp tslib fixes
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-add-input-layer-calibration-support.patch \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"
