#!/bin/bash

cd /workspace/tvm

mkdir /workspace/tvm/build
cp /workspace/tvm/cmake/config.cmake /workspace/tvm/build

config_path=/workspace/tvm/build/config.cmake
sed -i 's/set(BUILD_STATIC_RUNTIME OFF)/set(BUILD_STATIC_RUNTIME ON)/g' "$config_path"
sed -i 's/set(USE_CCACHE AUTO)/set(USE_CCACHE ON)/g' "$config_path"
sed -i 's/set(USE_LIBBACKTRACE AUTO)/set(USE_LIBBACKTRACE COMPILE)/g' "$config_path"