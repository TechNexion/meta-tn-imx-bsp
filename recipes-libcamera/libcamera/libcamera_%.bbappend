FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

TN_LIBCAMERA_PATCHES = " \
            file://0001-pipeline-neo-keep-all-formats-for-shared-ISI-graphs.patch \
            file://0002-pipeline-neo-avoid-relinking-shared-ISI-graph-on-rec.patch \
            file://0003-pipeline-neo-limit-wide-ISI-modes-based-on-camera-co.patch \
            "

SRC_URI:append:mx8mm-nxp-bsp = " ${TN_LIBCAMERA_PATCHES}"
SRC_URI:append:mx95-nxp-bsp = " ${TN_LIBCAMERA_PATCHES}"
