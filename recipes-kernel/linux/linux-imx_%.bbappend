FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tn-camera = "tn-imx_6.12.3_1.0.0-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:tn-camera = "ffc8d1087868c92f4232f691f02bdd6635f850d8"
DELTA_KERNEL_DEFCONFIG:tn-camera = "tn-camera.cfg"
