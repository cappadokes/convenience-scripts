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

cd /workspace/tvm

mkdir /workspace/tvm/build
cp /workspace/tvm/cmake/config.cmake /workspace/tvm/build

config_path=/workspace/tvm/build/config.cmake
sed -i 's/set(BUILD_STATIC_RUNTIME OFF)/set(BUILD_STATIC_RUNTIME ON)/g' "$config_path"
sed -i 's/set(USE_CCACHE AUTO)/set(USE_CCACHE ON)/g' "$config_path"
sed -i 's/set(USE_LIBBACKTRACE AUTO)/set(USE_LIBBACKTRACE COMPILE)/g' "$config_path"

cd /workspace/tvm/build
cmake .. -G Ninja
ninja -j $num_jobs

cd /workspace/tvm-wrapper

git clone https://github.com/dmlc/dmlc-core.git
cd /workspace/tvm-wrapper/dmlc-core
cmake . -G Ninja
ninja -j $num_jobs

cd /workspace/tvm-wrapper
git clone https://github.com/dmlc/dlpack.git
cd /workspace/tvm-wrapper/dlpack
cmake . -G Ninja
ninja -j num_jobs