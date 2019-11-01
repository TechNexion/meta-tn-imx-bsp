# Copyright 2017-2018 NXP
# Copyright 2019 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

PR = "r0"
SRCBRANCH = "tn-imx_4.9.88_2.0.0_ga-test"
LOCALVERSION = "-${SRCREV}"
KERNEL_SRC = "git://github.com/TechNexion/linux.git"

SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "bf1d894d6fddfce855256f833b596606db13e704"

S = "${WORKDIR}/git"
