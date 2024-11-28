#!/bin/bash

p4rt-ctl set-pipe br0 $PWD/calc.pb.bin $PWD/p4Info.txt

p4rt-ctl add-entry br0 ingress.calculate "hdr.p4calc.op=0x2b,action=ingress.operation_add" 

p4rt-ctl add-entry br0 ingress.calculate "hdr.p4calc.op=0x2d,action=ingress.operation_sub" 
