SUMMARY = "Podman Base Image"
DESCRIPTION = "Yocto Linux with no containers pre-provisioned."

require recipes-fsl/images/imx-image-core.bb
inherit extrausers

CORE_IMAGE_BASE_INSTALL:append = " \
    podman \
    podman-compose \
"

IMAGE_INSTALL:remove = " \
    packagegroup-tn-vizionsdk \
    packagegroup-tn-tools \
    packagegroup-tn-nfc \
    docker \
"

export IMAGE_BASENAME = "tn-image-podman"
