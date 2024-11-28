#!/bin/bash

p4rt-ctl del-entry br0 ingress.ipv4_table "headers.ipv4.dst_addr=10.0.1.1"

