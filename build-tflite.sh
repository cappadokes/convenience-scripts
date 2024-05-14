#!/bin/bash

cd /workspace/tensorflow
bazel build --test_output=all --spawn_strategy=sandboxed //tensorflow/lite/delegates/gpu/common:packing_profile_test
cd /workspace