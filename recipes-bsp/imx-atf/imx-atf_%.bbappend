FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/:"

SRC_URI += "\
    file://0001-imx8mm-rdc-assign-uart4-to-a53-domain.patch \
"

COMPATIBLE_MACHINE = "axon-imx8mm"
