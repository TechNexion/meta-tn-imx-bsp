# Copyright 2020 TechNexion Ltd.

EXTRA_OEMAKE_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'fcc', 'CONFIG_LINUX_QCMBR=y', '', d)}"
