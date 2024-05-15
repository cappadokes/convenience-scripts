#!/bin/bash

# Gather benchmarks in one place.

mkdir /workspace/benchmarks/minimalloc

cp /workspace/minimalloc/benchmarks/challenging/* /workspace/benchmarks/minimalloc/
cd /workspace/benchmarks/mindspore && unzip mindspore.zip

# Also, create directory for sorted benchmarks (TFlite expectes pre-sorted tensor usage records, based on liveness interals)

mkdir /workspace/benchmarks/presorted
mkdir /workspace/benchmarks/presorted/minimalloc
mkdir /workspace/benchmarks/presorted/mindspore

# Create result directory tree

mkdir /workspace/results

mkdir /workspace/results/time-makespan
mkdir /workspace/results/time-makespan/minimalloc-benchmarks
mkdir /workspace/results/time-makespan/mindspore-benchmarks

benchmark_types=("minimalloc" "mindspore")

for benchmark_type in "${benchmark_types[@]}"
do
    packers=("idealloc-r1" "idealloc-r21")

    for packer in "${packers[@]}"
    do
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/time
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/makespan
    done

    packers=("minimalloc" "triton" "tflite-equality" "tflite-greedy-breadth" "tflite-greedy-inorder" "tflite-greedy-size" "tflite-mincostflow" "tflite-naive" "xla-best-fit-repacker" "xla-desc-size-heap-sim" "tvm-greedy-conflict" "tvm-greedy-size" "tvm-hillclimb" "mindspore")

    for packer in "${packers[@]}"
    do
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/time
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/csv-out
        mkdir /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/makespan
    done
done

mkdir /workspace/results/capacity-experiment
mkdir /workspace/results/capacity-experiment/loads
mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks
mkdir /workspace/results/capacity-experiment/mindspore-benchmarks

for benchmark_type in "${benchmark_types[@]}"
do
    packers=("minimalloc" "tvm-hillclimb")

    for packer in "${packers[@]}"
    do
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer/time
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer/csv-out
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer/makespan
    done

    packers=("idealloc-r1" "idealloc-montecarlo-0" "idealloc-montecarlo-0.1" "idealloc-montecarlo-0.4")

    for packer in "${packers[@]}"
    do
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer/time
        mkdir /workspace/results/capacity-experiment/$benchmark_type-benchmarks/$packer/makespan
    done
done
