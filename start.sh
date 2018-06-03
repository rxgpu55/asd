#!/bin/bash
sudo sysctl -w vm.nr_hugepages=128
cpulimit -e xmrig -l 35
./xmrig
