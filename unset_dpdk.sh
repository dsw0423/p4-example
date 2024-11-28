#!/bin/bash

#echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
dpdk-devbind.py -b igb 0000:04:00.0 0000:04:00.1 --force

sleep 1

ip link set enp4s0f0 up
ip link set enp4s0f1 up

