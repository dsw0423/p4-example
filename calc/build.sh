#!/bin/bash

p4c-dpdk --arch psa \
       	--p4runtime-files $PWD/p4Info.txt \
       	--bf-rt-schema $PWD/bf-rt.json \
	--context $PWD/context.json \
	-o $PWD/calc.spec \
	$PWD/calc.p4

sleep 1

tdi_pipeline_builder --p4c_conf_file=calc.conf \
    --bf_pipeline_config_binary_file=calc.pb.bin

