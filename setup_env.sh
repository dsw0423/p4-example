#!/bin/bash

export SDE_INSTALL=/root/ipdk/sde/install
export DEPEND_INSTALL=/root/ipdk/stratum-deps/install
export P4CP_INSTALL=/root/ipdk/networking-recipe/install

source $P4CP_INSTALL/sbin/setup_env.sh $P4CP_INSTALL $SDE_INSTALL $DEPEND_INSTALL
$P4CP_INSTALL/sbin/copy_config_files.sh $P4CP_INSTALL $SDE_INSTALL
