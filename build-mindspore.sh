#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <number_of_jobs>"
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Error: The argument must be an integer."
    exit 1
fi

num_jobs=$1

cd /workspace/mindspore-wrapper
git clone https://github.com/martinus/robin-hood-hashing.git
cd /workspace/mindspore-wrapper/robin-hood-hashing
cmake . -G Ninja
ninja -j $num_jobs

cd /workspace/mindspore-wrapper
conan install . --build=missing
cmake . -G Ninja
ninja -j $num_jobs

cd /workspace