FILESEXTRAPATHS:prepend:tn-camera := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " file://tn-camera.cfg"
SRCBRANCH:tn-camera = "tn-imx_6.18.20_2.0.0-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;nobranch=1;branch=${SRCBRANCH}"
SRCREV:tn-camera = "5dc71dbf171c458a958392ea9c6e63ffffa8eb5f"

