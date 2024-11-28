#!/bin/bash

p4rt-ctl set-pipe br0 $PWD/l2fwd.pb.bin $PWD/p4Info.txt

p4rt-ctl add-entry br0 ingress.l2fwd_table "headers.ethernet.dst_addr=a0:36:9f:d8:97:8a,action=ingress.l2fwd(0)"

p4rt-ctl add-entry br0 ingress.l2fwd_table "headers.ethernet.dst_addr=a0:36:9f:d8:97:8b,action=ingress.l2fwd(1)"

