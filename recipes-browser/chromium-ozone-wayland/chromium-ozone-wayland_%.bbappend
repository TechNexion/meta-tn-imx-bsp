FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:imx-nxp-bsp = " \
    file://0001-refactor-simplify-build-config-and-GN-allowlist-assi.patch \
"

GN_ARGS:append:imx-nxp-bsp = " \
        use_siso=false \
        is_linux=true \
        is_android=false \
        is_chromeos_device=false \
        is_castos=false \
"