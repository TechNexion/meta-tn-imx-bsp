FILESEXTRAPATHS:prepend:tn-camera := "${THISDIR}/file:"

SRC_URI:append:tn-camera = " file://tn-camera.cfg"
SRCBRANCH:tn-camera = "tn-imx_6.18.20_2.0.0-next"
LINUX_IMX_SRC:tn-camera = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;nobranch=1;branch=${SRCBRANCH}"
SRCREV:tn-camera = "db7fe9e4fca6f8a87604aadc8e4a2f9c18a472b8"

