FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tn-camera = "tn-imx_6.1.55_2.2.0-next"
KERNEL_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:tn-camera = "c271cb61f96a6f27acc32ebd9c27aa2c91e980d1"
DELTA_KERNEL_DEFCONFIG:tn-camera = "tn-camera.cfg"
