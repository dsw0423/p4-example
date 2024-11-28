#!/bin/bash

killall infrap4d
sleep 1

infrap4d -grpc_open_insecure_mode=true
#infrap4d

sleep 1
#gnmi-ctl set "device:physical-device,name:PORT0,pci-bdf:0000:04:00.0,port-type:link"
gnmi-ctl set "device:physical-device,name:PORT0,pci-bdf:0000:04:00.0,port-type:link" -grpc_use_insecure_mode=true
#gnmi-ctl set "device:physical-device,name:PORT1,pci-bdf:0000:04:00.1,port-type:link"
gnmi-ctl set "device:physical-device,name:PORT1,pci-bdf:0000:04:00.1,port-type:link" -grpc_use_insecure_mode=true
