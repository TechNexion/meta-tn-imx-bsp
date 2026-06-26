FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-pipeline-neo-keep-all-YUV-sensor-resolutions-for-mul.patch \
            file://0002-pipeline-neo-safely-reconfigure-YUV-frontend-formats.patch"

