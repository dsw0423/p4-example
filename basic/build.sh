#!/bin/bash

p4c-dpdk --arch psa \
       	--p4runtime-files $PWD/p4Info.txt \
       	--bf-rt-schema $PWD/bf-rt.json \
	--context $PWD/context.json \
	-o $PWD/basic.spec \
	$PWD/basic.p4

sleep 1

tdi_pipeline_builder --p4c_conf_file=basic.conf \
    --bf_pipeline_config_binary_file=basic.pb.bin

