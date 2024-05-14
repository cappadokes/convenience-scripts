#!/bin/bash

cd /workspace/xla
bazel build --test_output=all --spawn_strategy=sandboxed //xla/service/memory_space_assignment:best_fit_repacker_prof
cd /workspace