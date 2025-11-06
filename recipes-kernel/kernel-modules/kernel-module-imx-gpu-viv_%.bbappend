# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2021 TechNexion Ltd.
# Copyright 2017-2021 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

LOCALVERSION = "${@'-%s' % '-'.join(d.getVar('SRCBRANCH', True).split('_')[2:]).lower()}"
LINUX_IMX_SRC = "git://github.com/TechNexion/linux-tn-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCBRANCH = "tn-imx_6.12.34_2.1.0-next"
SRCREV = "f2c12b057db42b6eca93d11fde9d4add4c4e2068"
