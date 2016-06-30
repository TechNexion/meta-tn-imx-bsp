# Freescale imx extra configuration 
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_mx6 = " file://rc_mxc.S"

# overirde do_install
do_install_append_mx6() {
    install -m 0755 ${WORKDIR}/rc_mxc.S ${D}${sysconfdir}/init.d
    
    # Install rc_gpu.S to /etc/init.d
    sed -i -e 's/.*gpu::sysinit:\/etc\/init.d\/rc_gpu.S.*/gpu::once:\/\etc\/\init.d\/rc_gpu.S/' ${D}${sysconfdir}/inittab
}
