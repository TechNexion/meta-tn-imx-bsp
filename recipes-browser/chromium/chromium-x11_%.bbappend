FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
            file://could-not-find-the-gbm-header-file-provided-by-minigbm.patch \
"

GN_ARGS_append_mx6 = " use_system_minigbm=false "
GN_ARGS_append_mx7 = " use_system_minigbm=false "

