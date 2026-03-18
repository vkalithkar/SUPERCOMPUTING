#!/bin/bash
set -ueo pipefail

# Clone to programs dir
cd ~/programs

# Clone it
git clone https://github.com/fenderglass/Flye
cd Flye
make
