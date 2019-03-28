# Copyright 2017-2018 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

SRCBRANCH = "tn-imx_4.14.78_1.0.0_ga-wip"
LOCALVERSION = "-${SRCBRANCH}"
KERNEL_SRC = "git://github.com/TechNexion/linux.git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "7ff5de3f5d79c77ab7ecaa6e346ad0e7fb7f0570"

S = "${WORKDIR}/git"
