FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tn-camera = "tn-imx_6.6.52_2.2.2-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:tn-camera = "e29b8d74531b06b6f9e3c4d7dd3b5f567a663057"
DELTA_KERNEL_DEFCONFIG:tn-camera = "tn-camera.cfg"
