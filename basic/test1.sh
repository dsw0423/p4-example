#!/bin/bash

ip netns del ns0
ip netns del ns1

sleep 1

ip netns add ns0
ip netns add ns1

ip link set enp5s0f0 netns ns0
ip link set enp5s0f1 netns ns1

ip netns exec ns0 ip link set enp5s0f0 up
ip netns exec ns1 ip link set enp5s0f1 up

ip netns exec ns0 ip link set lo up
ip netns exec ns1 ip link set lo up

ip netns exec ns0 ip addr add 10.1.1.1/24 dev enp5s0f0
ip netns exec ns1 ip addr add 10.2.2.2/24 dev enp5s0f1

ip netns exec ns0 route add default gw 10.1.1.10 dev enp5s0f0
ip netns exec ns1 route add default gw 10.2.2.20 dev enp5s0f1

ip netns exec ns0 arp -s 10.1.1.10 a0:36:9f:d8:97:36
ip netns exec ns1 arp -s 10.2.2.20 a0:36:9f:d8:97:37

# ip netns exec ns0 ping 10.0.0.2 -c 5
# ip netns exec ns1 ping 10.0.0.1 -c 5
