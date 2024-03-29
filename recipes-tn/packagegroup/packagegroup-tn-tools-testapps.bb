# Copyright (C) 2012-2014, 2016 Freescale Semiconductor
# Copyright (C) 2015, 2016 O.S. Systems Software LTDA.
# Copyright (C) 2019, 2016 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Packagegroup used by TechNexion to provide a set of packages and utilities \
for hardware test."
SUMMARY = "TechNexion packagroup - tools/testapps"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

SOC_TOOLS_TEST = ""

RDEPENDS:${PN} = " \
    alsa-utils \
    alsa-tools \
    dosfstools \
    evtest \
    e2fsprogs-mke2fs \
    fsl-rc-local \
    fbset \
    i2c-tools \
    iproute2 \
    tcpdump \
    memtester \
    stress-ng \
    hdparm \
    glmark2 \
    python-subprocess \
    python-datetime \
    python-json \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'v4l-utils', '', d)} \
    ethtool \
    mtd-utils \
    mtd-utils-ubifs \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'gtk+3-demo', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
                         'weston-examples clutter-1.0-examples', '', d)} \
    ${SOC_TOOLS_TEST} \
"

# FIXME: i.MX6SL cannot use mesa for Graphics and it lacks GL support,
#        so for now we skip it.
RDEPENDS_IMX_TO_REMOVE = ""
RDEPENDS_IMX_TO_REMOVE:imxgpu2d = "clutter-1.0-examples"
RDEPENDS_IMX_TO_REMOVE:imxgpu3d = ""

RDEPENDS_${PN}:remove = "${RDEPENDS_IMX_TO_REMOVE}"
