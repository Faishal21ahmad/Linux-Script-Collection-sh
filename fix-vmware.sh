#!/bin/bash
set -e

cd vm-host-modules
git checkout 17.6

sudo make
sudo make install 
