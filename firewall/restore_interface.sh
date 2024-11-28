#!/bin/bash

ip netns del ns0
ip netns del ns1


dpdk-devbind.py -b vfio-pci 0000:05:00.0 0000:05:00.1 --force

sleep 1

dpdk-devbind.py -b igb 0000:05:00.0 0000:05:00.1 --force

sleep 1

ip link set enp5s0f0 up
ip link set enp5s0f1 up

