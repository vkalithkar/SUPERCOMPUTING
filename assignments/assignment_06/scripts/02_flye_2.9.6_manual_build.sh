#!/bin/bash
set -ueo pipefail

cd ~/programs

git clone https://github.com/fenderglass/Flye
cd Flye
make
