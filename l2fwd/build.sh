#!/bin/bash

p4c-dpdk --arch psa \
       	--p4runtime-files $PWD/p4Info.txt \
       	--bf-rt-schema $PWD/bf-rt.json \
	--context $PWD/context.json \
	-o $PWD/l2fwd.spec \
	$PWD/l2fwd.p4

sleep 1

tdi_pipeline_builder --p4c_conf_file=l2fwd.conf \
    --bf_pipeline_config_binary_file=l2fwd.pb.bin

