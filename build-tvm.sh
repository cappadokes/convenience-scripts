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
cmake=/home/cmake-3.31.4-linux-x86_64/bin/cmake

cd /home/workspace/tvm

mkdir /home/workspace/tvm/build
cp /home/workspace/tvm/cmake/config.cmake /home/workspace/tvm/build

config_path=/home/workspace/tvm/build/config.cmake
sed -i 's/set(BUILD_STATIC_RUNTIME OFF)/set(BUILD_STATIC_RUNTIME ON)/g' "$config_path"
sed -i 's/set(USE_CCACHE AUTO)/set(USE_CCACHE ON)/g' "$config_path"
sed -i 's/set(USE_LIBBACKTRACE AUTO)/set(USE_LIBBACKTRACE COMPILE)/g' "$config_path"

cd /home/workspace/tvm/build
"$cmake" .. -DCMAKE_BUILD_TYPE=Release -G Ninja
ninja -j $num_jobs

cd /home/workspace/tvm-wrapper

git clone https://github.com/dmlc/dmlc-core.git
cd /home/workspace/tvm-wrapper/dmlc-core
"$cmake" . -DCMAKE_BUILD_TYPE=Release -G Ninja
ninja -j $num_jobs

cd /home/workspace/tvm-wrapper
git clone https://github.com/dmlc/dlpack.git
cd /home/workspace/tvm-wrapper/dlpack
"$cmake" . -DCMAKE_BUILD_TYPE=Release -G Ninja
ninja -j $num_jobs

cd /home/workspace/tvm-wrapper
"$cmake" . -DCMAKE_BUILD_TYPE=Release -G Ninja
ninja -j $num_jobs

cd /home/workspace
