#!/bin/bash

killall infrap4d

sleep 2
infrap4d

sleep 2
gnmi-ctl set "device:physical-device,name:PORT0,pci-bdf:0000:04:00.0,port-type:link"
gnmi-ctl set "device:physical-device,name:PORT1,pci-bdf:0000:04:00.1,port-type:link"
