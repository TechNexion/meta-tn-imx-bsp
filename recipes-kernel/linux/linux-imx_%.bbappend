FILESEXTRAPATHS_prepend := "${THISDIR}/file:"

SRC_URI_append_tevi = " \
       file://tn-camera.cfg \
       "
SRCBRANCH_tevi = "tn-imx_5.10.72_2.2.0-next"
KERNEL_SRC_tevi = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https"
SRCREV_tevi = "915abc79b83c989bccd6df5b9aa314876f23ab8e"
DELTA_KERNEL_DEFCONFIG_tevi = "tn-camera.cfg"
