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

cd /workspace/xla
bazel build --test_output=all --spawn_strategy=sandboxed //xla/service:bestfitheap_test --jobs=$num_jobs
bazel build --test_output=all --spawn_strategy=sandboxed //xla/service/memory_space_assignment:best_fit_repacker_prof --jobs=$num_jobs
cd /workspace