#!/bin/bash

echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
dpdk-devbind.py -b vfio-pci enp4s0f0 enp4s0f1 --force

