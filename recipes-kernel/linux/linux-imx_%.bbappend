FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tn-camera = "tn-imx_6.12.34_2.1.0-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;nobranch=1;branch=${SRCBRANCH}"
SRCREV:tn-camera = "d6a0cc44767774c6872718ae97b8afd6c165e942"
DELTA_KERNEL_DEFCONFIG:tn-camera = "tn-camera.cfg"
