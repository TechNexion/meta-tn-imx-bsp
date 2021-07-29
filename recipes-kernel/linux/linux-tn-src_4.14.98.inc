# Copyright 2017-2018 NXP
# Copyright 2019 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

PR = "r1"
SRCBRANCH = "tn-imx_4.14.98_2.0.0_ga-stable"
LOCALVERSION = "${@'-%s' % '-'.join(d.getVar('SRCBRANCH', True).split('_')[2:]).lower()}"
KERNEL_SRC = "git://github.com/TechNexion/linux-tn-imx.git"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "aa8b26b7ca09cc31d2e0fe4534e72c256dd9aadd"

S = "${WORKDIR}/git"
