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

cd /workspace
wget https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0.tar.gz
tar -zxvf cmake-3.29.0.tar.gz && cd cmake-3.29.0 && ./bootstrap --parallel=$num_jobs && make -j $num_jobs && make install && cd /workspace && rm -rf cmake-3.29.0 && rm cmake-3.29.0.tar.gz