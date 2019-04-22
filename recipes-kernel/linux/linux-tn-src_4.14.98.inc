# Copyright 2017-2018 NXP
# Copyright 2019 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

SRCBRANCH = "tn-imx_4.14.98_2.0.0_ga-wip"
LOCALVERSION = "-${SRCBRANCH}"
KERNEL_SRC = "git://github.com/TechNexion/linux.git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "e1352fe45dcb97a53098d92ea474f92f40dc0a0e"

S = "${WORKDIR}/git"
