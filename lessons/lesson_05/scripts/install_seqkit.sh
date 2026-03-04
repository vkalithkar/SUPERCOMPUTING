#!/bin/bash

# usage: ./install_seqkit.sh [install location]
# this location needs to be added to your $PATH
# if you dont know what that is, dont run this.

# Install seqkit
cd $1
wget https://github.com/shenwei356/seqkit/releases/download/v2.10.1/seqkit_linux_amd64.tar.gz
tar -xzf seqkit_linux_amd64.tar.gz
rm seqkit_linux_amd64.tar.gz


