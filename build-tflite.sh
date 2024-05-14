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

cd /workspace/tensorflow
bazel build --test_output=all --spawn_strategy=sandboxed //tensorflow/lite/delegates/gpu/common:packing_profile_test --jobs=$num_jobs
cd /workspace