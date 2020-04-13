DESCRIPTION = "Package to create Docker data partition image using DinD container"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

INSANE_SKIP_${PN} += "already-stripped"
SKIP_FILEDEPS_${PN} = "1"
EXCLUDE_FROM_SHLIBS_${PN} = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI += " \
	file://Dockerfile \
	file://entry.sh \
	"

S = "${WORKDIR}"
B = "${S}/build"

# JENKINS_HOMEDIR ?= "/home/admin/jenkins_home" for jenkins running in container
JENKINS_HOMEDIR ?= "${HOME}"
SHAREDSRC = "${@ '%s' % (d.getVar('S', True).replace(d.getVar('HOME', True), d.getVar('JENKINS_HOMEDIR', True)))}"
SHAREDBUILD = "${@ '%s' % (d.getVar('B', True).replace(d.getVar('HOME', True), d.getVar('JENKINS_HOMEDIR', True)))}"

inherit deploy
require docker-disk.inc

# By default pull technexion dockerhub's images
TARGET_REPOSITORY ?= "${TN_DOCKER_REPOSITORY}"
TARGET_TAG ?= "${TN_DOCKER_TAG}"

python () {
    import re
    repo = d.getVar("TARGET_REPOSITORY", True)
    tag = d.getVar("TARGET_TAG", True)
    pv = re.sub(r"[^a-z0-9A-Z_.-]", "_", "%s-%s" % (repo,tag))
    d.setVar('PV', pv)
}

PV = "${TARGET_TAG}"

# multiconfig dependancy only works on yocto warrior onward
do_postfetch[mcdepends] = "multiconfig:container:tn-container-image-glmark2:do_image_complete"
do_postfetch () {
	if [ -f ${TOPDIR}/tmp-container/deploy/images/tn-container/${TN_DOCKER_CONTAINER_IMAGE} ]; then
		mkdir -p ${S}/container
		install -m 644 ${TOPDIR}/tmp-container/deploy/images/tn-container/${TN_DOCKER_CONTAINER_IMAGE} ${S}/container/${TN_DOCKER_CONTAINER_IMAGE}
	else
		bbwarn "${TOPDIR}/tmp-container/deploy/images/tn-container/${TN_DOCKER_CONTAINER_IMAGE} not found. For yocto version earlier than warrior, please build ${TN_DOCKER_CONTAINER_IMAGE} separately with the following command:\n\tbitbake multiconfig:container:tn-container-image-glmark2"
	fi
}
addtask postfetch before do_compile and after do_fetch

do_patch[noexec] = "1"
do_configure[noexec] = "1"

do_compile () {
	# Some sanity first for the technexion docker variables
	if [ -z "${TARGET_REPOSITORY}" ] || [ -z "${TARGET_TAG}" ]; then
		bbfatal "docker-disk: TARGET_REPOSITORY and/or TARGET_TAG not set."
	fi
	if [ -z "${TN_DOCKER_PARTITION_SIZE}" ]; then
		bbfatal "docker-disk: TN_DOCKER_PARTITION_SIZE needs to have a value (megabytes)."
	fi
	if [ -z "${TN_DOCKER_PARTITION_IMAGE}" ]; then
		bbfatal "docker-disk: TN_DOCKER_PARTITION_IMAGE needs to have an image name."
	fi

	# At this point we really need Internet connectivity for building the docker image
	if [ "x${@connected(d)}" != "xyes" ]; then
		bbfatal "docker-disk: Can't compile as there is no Internet connectivity on this host."
	fi

	# We force the PATH to be the standard linux path in order to use the host's
	# docker daemon instead of the result of docker-native. This avoids version
	# mismatches
	DOCKER=$(PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" which docker)

	bbnote "docker-disk: starting docker..."
	bbnote "docker-disk: SHAREDSRC=${SHAREDSRC}/container"
	bbnote "docker-disk: SHAREDBUILD=${SHAREDBUILD}"

	# Generate the data filesystem (i.e. /var/lib/docker) using DinD with docker daemon
	RANDOM=$$
	_image_name="docker-disk-$RANDOM"
	_container_name="docker-disk-$RANDOM"
	$DOCKER rmi ${_image_name} > /dev/null 2>&1 || true
	$DOCKER build -t ${_image_name} -f ${WORKDIR}/Dockerfile ${WORKDIR}
	$DOCKER run --privileged --rm \
		-e STORAGE_DRIVER=${TN_STORAGE_DRIVER} \
		-e USER_ID=$(id -u) -e USER_GID=$(id -u) \
		-e TARGET_REPOSITORY="${TARGET_REPOSITORY}" \
		-e TARGET_TAG="${TARGET_TAG}" \
		-e CONTAINER_IMAGE="${TN_DOCKER_CONTAINER_IMAGE}" \
		-e CONTAINER_SUFFIX="${TN_CONTAINER_IMAGE_TYPE}" \
		-e HEALTHCHECK_REPOSITORY="${HEALTHCHECK_REPOSITORY}" \
		-e HEALTHCHECK_PLATFORM="${HEALTHCHECK_PLATFORM}" \
		-e HEALTHCHECK_EXPORT_IMAGE="${HEALTHCHECK_EXPORT_IMAGE}" \
		-e PRIVATE_REGISTRY="${PRIVATE_REGISTRY}" \
		-e PRIVATE_REGISTRY_USER="${PRIVATE_REGISTRY_USER}" \
		-e PRIVATE_REGISTRY_PASSWORD="${PRIVATE_REGISTRY_PASSWORD}" \
		-e PARTITION_SIZE="${TN_DOCKER_PARTITION_SIZE}" \
		-e PARTITION_IMAGE="${TN_DOCKER_PARTITION_IMAGE}" \
		-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
		-v ${SHAREDSRC}/container:/src \
		-v ${SHAREDBUILD}:/build \
		--name ${_container_name} ${_image_name}
	$DOCKER rmi ${_image_name}
}

do_deploy () {
	if [ -f ${B}/${TN_DOCKER_PARTITION_IMAGE} ]; then
		install -m 644 ${B}/${TN_DOCKER_PARTITION_IMAGE} ${DEPLOYDIR}/${TN_DOCKER_PARTITION_IMAGE}
	else
		bbfatal "${B}/${TN_DOCKER_PARTITION_IMAGE} not found. Please ensure docker-disk exported docker container images correctly."
	fi
}
addtask deploy before do_package after do_install
