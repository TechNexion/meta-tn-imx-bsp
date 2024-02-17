FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tevi = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tevi = "tn-imx_5.15.71_2.2.0-next"
KERNEL_SRC:tevi = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:tevi = "45d3db9701efcb43fbf06c68fef2a9b4eba9ae3d"
DELTA_KERNEL_DEFCONFIG:tevi = "tn-camera.cfg"
