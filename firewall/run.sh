#!/bin/bash

p4rt-ctl set-pipe br0 $PWD/firewall.pb.bin $PWD/p4Info.txt

p4rt-ctl add-entry br0 ingress.ipv4_table "headers.ipv4.dst_addr=10.0.1.1,action=ingress.ipv4_fwd(a0:36:9f:d8:97:8a,a0:36:9f:d8:97:36,0)"

p4rt-ctl add-entry br0 ingress.ipv4_table "headers.ipv4.dst_addr=10.0.2.2,action=ingress.ipv4_fwd(a0:36:9f:d8:97:8b,a0:36:9f:d8:97:37,1)"

# p4rt-ctl add-entry br0 pipe.check_ports "istd.input_port=0,action=pipe.set_direction(0)"

# p4rt-ctl add-entry br0 pipe.check_ports "istd.input_port=1,action=pipe.set_direction(1)"

