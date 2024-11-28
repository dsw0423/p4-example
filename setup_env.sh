#!/bin/bash

WORKING_DIR=/root/ipdk_workdir

SCRIPTS_DIR="${WORKING_DIR}"/scripts
DEPS_INSTALL_DIR="${WORKING_DIR}"/networking-recipe/deps_install
P4C_INSTALL_DIR="${WORKING_DIR}"/p4c/install
SDE_INSTALL_DIR="${WORKING_DIR}"/p4-sde/install
NR_INSTALL_DIR="${WORKING_DIR}"/networking-recipe/install

# Update SDE Install variable
export SDE_INSTALL="${SDE_INSTALL_DIR}"
export PATH="${SDE_INSTALL_DIR}"/bin:"${PATH}"

# Update SDE libraries
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}":"${SDE_INSTALL_DIR}"/lib
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}":"${SDE_INSTALL_DIR}"/lib64
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}":"${SDE_INSTALL_DIR}"/lib/x86_64-linux-gnu

# Update NETWORKING-RECIPE libraries
export LD_LIBRARY_PATH="${NR_INSTALL_DIR}"/lib:"${NR_INSTALL_DIR}"/lib64:"${LD_LIBRARY_PATH}"
export PATH="${NR_INSTALL_DIR}"/bin:"${NR_INSTALL_DIR}"/sbin:"${PATH}"

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}":/usr/local/lib
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}":/usr/local/lib64

# Update Dependent libraries
export LD_LIBRARY_PATH="${DEPS_INSTALL_DIR}"/lib:"${DEPS_INSTALL_DIR}"/lib64:"${LD_LIBRARY_PATH}"
export PATH="${DEPS_INSTALL_DIR}"/bin:"${DEPS_INSTALL_DIR}"/sbin:"${PATH}"
export LIBRARY_PATH="${DEPS_INSTALL_DIR}"/lib:"${DEPS_INSTALL_DIR}"/lib64:"${LIBRARY_PATH}"
export PATH="${P4C_INSTALL_DIR}"/bin:"${PATH}"

"${SCRIPTS_DIR}"/set_hugepages.sh

#... Create required directories and copy the config files ...#
# Create networking-recipe directories for configs/logs/runtime file..
mkdir -p /etc/stratum/
mkdir -p /var/log/stratum/
mkdir -p /usr/share/stratum/dpdk
mkdir -p /usr/share/target_sys/
cp "${NR_INSTALL_DIR}"/share/stratum/dpdk/dpdk_port_config.pb.txt /usr/share/stratum/dpdk/
cp "${NR_INSTALL_DIR}"/share/stratum/dpdk/dpdk_skip_p4.conf /usr/share/stratum/dpdk/
cp "${SDE_INSTALL_DIR}"/share/target_sys/zlog-cfg /usr/share/target_sys/

# "${NR_INSTALL_DIR}"/sbin/infrap4d

