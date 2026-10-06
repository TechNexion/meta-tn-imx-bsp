FILESEXTRAPATHS:prepend:tn-camera := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " file://tn-camera.cfg"
SRCBRANCH:tn-camera = "tn-imx_6.18.37_2.1.0-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;nobranch=1;branch=${SRCBRANCH}"
SRCREV:tn-camera = "3aa0bb46809d994656c787d0f9afce7f6bb5a957"

