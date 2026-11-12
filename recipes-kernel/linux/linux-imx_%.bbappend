FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tn-camera = "tn-imx_6.6.52_2.2.2-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:tn-camera = "6eaffa0aa610172df0877962c59fc954877906cd"
DELTA_KERNEL_DEFCONFIG:tn-camera = "tn-camera.cfg"
