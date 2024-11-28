#!/bin/bash

p4c-dpdk --arch pna \
       	--p4runtime-files $PWD/p4Info.txt \
       	--bf-rt-schema $PWD/bf-rt.json \
	--context $PWD/context.json \
	-o $PWD/firewall.spec \
	$PWD/firewall.p4

sleep 1

tdi_pipeline_builder --p4c_conf_file=firewall.conf \
    --bf_pipeline_config_binary_file=firewall.pb.bin

