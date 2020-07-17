# Copyright 2017-2018 NXP
# Copyright 2019 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

PR = "r1"
SRCBRANCH = "tn-imx_4.14.98_2.0.0_ga-next"
LOCALVERSION = "-${SRCREV}"
KERNEL_SRC = "git://github.com/TechNexion/linux-tn-imx.git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "13c263c8cc42ef66ae4c8e6010dcb14c6fc0ccdb"

S = "${WORKDIR}/git"
