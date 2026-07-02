FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

TN_LIBCAMERA_PATCHES = " \
            file://0001-pipeline-neo-keep-all-YUV-sensor-resolutions-for-mul.patch \
            file://0002-pipeline-neo-safely-reconfigure-YUV-frontend-formats.patch \
            file://0003-pipeline-neo-avoid-resetting-configured-frontend-gra.patch \
            file://0004-pipeline-neo-limit-YUV-modes-by-ISI-pipe-budget.patch \
            "

SRC_URI:append:mx8mm-nxp-bsp = " ${TN_LIBCAMERA_PATCHES}"
SRC_URI:append:mx95-nxp-bsp = " ${TN_LIBCAMERA_PATCHES}"
