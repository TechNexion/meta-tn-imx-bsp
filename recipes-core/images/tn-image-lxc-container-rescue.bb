SUMMARY = "A small lxc container image with python3."

PREFERRED_PROVIDER_virtual/kernel = "linux-dummy"

IMAGE_INSTALL_lxc = "\
	${CORE_IMAGE_BASE_INSTALL} \
	packagegroup-core-basic \
	libvirt \
	libvirt-python \
	openflow \
	dhcp-client \
	python3 \
"

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

# cloud-image-compute
#IMAGE_INSTALL = "\
#    ${CORE_IMAGE_BASE_INSTALL} \
#    packagegroup-core-basic \
#    openvswitch \
#    libvirt \
#    openflow \
#    "

# cloud-image-controller
#IMAGE_INSTALL = "\
#    ${CORE_IMAGE_BASE_INSTALL} \
#    packagegroup-core-basic \
#    openvswitch \
#    openvswitch-controller \
#    openvswitch-switch \
#    openvswitch-brcompat \
#    criu \
#    libvirt \
#    libvirt-libvirtd \
#    libvirt-python \
#    libvirt-virsh \    
#    openflow \
#    qemu \   
#    kernel-modules \
#    dhcp-client \
#    perl-modules \
#    grub \
#    mysql5 \
#    python-twisted \ 
#    python-lxml \
#    "

# cloud-image-guest
#IMAGE_INSTALL = "\
#    ${CORE_IMAGE_BASE_INSTALL} \
#    packagegroup-core-basic \
#    openflow \
#    qemu \   
#    kernel-modules \
#    tcpdump \
#    dhcp-client \
#    "

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

