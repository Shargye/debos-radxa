#!/bin/bash

CMD=`realpath $0`
CONFIG_BOARD_DIR=`dirname $CMD`
TOP_DIR=$(realpath $CONFIG_BOARD_DIR/../../../)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
[[ ! -d "$BUILD_DIR" ]] && mkdir -p $BUILD_DIR

# env
export CPU=s905y2
export BOARD=radxa-zero
export MODEL=debian
export DISTRO=bullseye
export VARIANT=xfce4
export ARCH=arm64
export FORMAT=mbr
export IMAGESIZE=3000MB

# Add pre-installed packages for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list <<EOF
amlogic-adbd*.deb
dthelper*.deb
libreelec-alsa-utils*.deb
EOF

# Add yaml variable
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-variable.yaml <<EOF
{{- \$cpu := or .cpu "${CPU}" -}}
{{- \$board := or .board "${BOARD}" -}}
{{- \$architecture := or .architecture "${ARCH}" -}}
{{- \$model :=  or .model "${MODEL}" -}}
{{- \$suite := or  .suite "${DISTRO}" -}}
{{- \$imagesize := or .imagesize "${IMAGESIZE}" -}}
{{- \$bootpartitionend := or .bootpartitionend "1081343S" -}}
{{- \$rootpartitionstart := or .rootpartitionstart "1081344S" -}}
{{- \$apt_repo := or .apt_repo "radxa" -}}

EOF

# Add images yaml
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-yaml.list <<EOF
00_architecture.yaml
01_debootstrap_debian.yaml
02_partitions_amlogic.yaml
03_filesystem_deploy.yaml
20_packages_start.yaml
21_packages_base.yaml
21_packages_bluetooth.yaml
21_packages_devel.yaml
21_packages_libs.yaml
21_packages_kernel.yaml
21_packages_math.yaml
21_packages_sound.yaml
21_packages_utilities.yaml
21_packages_net.yaml
21_packages_xfce.yaml
21_packages_web.yaml
22_packages_end.yaml
70_system_common_setup.yaml
85_u_boot_amlogic.yaml
90_clean_rootfs.yaml
EOF
