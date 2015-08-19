FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
   file://brcmfmac${CHIP_MODEL}-sdio.txt \
"
COMPATIBLE_MACHINE_edm-fairy-imx6 = "(edm-fairy-imx6)"
COMPATIBLE_MACHINE_edm-toucan-imx6 = "(edm-toucan-imx6)"
