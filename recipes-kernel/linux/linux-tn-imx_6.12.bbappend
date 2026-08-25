FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:rescue = " \
       file://logo.ppm \
       file://rescue-fragment.cfg \
       "
SRC_URI:append:imx95-a1-19x19-lpddr5-evk = " file://imx95-a1-mali-pma.cfg"
SRC_URI:append:imx95-19x19-lpddr5-evk = " file://imx95-mali-pma.cfg"
DELTA_KERNEL_DEFCONFIG:rescue = "rescue-fragment.cfg"
DELTA_KERNEL_DEFCONFIG:imx95-a1-19x19-lpddr5-evk = "imx95-a1-mali-pma.cfg"
DELTA_KERNEL_DEFCONFIG:imx95-19x19-lpddr5-evk = "imx95-mali-pma.cfg"

do_copy_defconfig:append:rescue () {
    cp ${UNPACKDIR}/logo.ppm ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
