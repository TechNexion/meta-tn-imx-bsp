FILESEXTRAPATHS:prepend := "${THISDIR}/file:"

SRC_URI:append:tevi = " \
       file://tn-camera.cfg \
       "
SRCBRANCH:tevi = "tn-imx_5.15.71_2.2.0-next"
KERNEL_SRC:tevi = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:tevi = "68e255452bd413131d242d35e02309a8f5bc8b1e"
DELTA_KERNEL_DEFCONFIG:tevi = "tn-camera.cfg"
