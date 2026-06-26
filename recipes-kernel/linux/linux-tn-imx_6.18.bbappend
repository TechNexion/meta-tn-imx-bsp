FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:rescue = " \
       file://logo.ppm \
       file://rescue-fragment.cfg \
       "

do_kernel_localversion:append:rescue () {
    cp ${UNPACKDIR}/logo.ppm ${S}/drivers/video/logo/logo_linux_clut224.ppm
}
