#!/bin/bash

sudo rm -rf /usr/share/stratum/certs
COMMON_NAME=localhost ./generate-certs.sh
sudo cp -r ./certs /usr/share/stratum/

