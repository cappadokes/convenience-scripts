#!/bin/bash

# Gather benchmarks in one place.

mkdir /workspace/benchmarks/minimalloc

cp /workspace/minimalloc/benchmarks/challenging/* /workspace/benchmarks/minimalloc/
cd /workspace/benchmarks/mindspore && unzip mindspore.zip

# Create result directory tree

mkdir /workspace/results

mkdir /workspace/results/time-makespan
mkdir /workspace/results/time-makespan/minimalloc-benchmarks
mkdir /workspace/results/time-makespan/mindspore-benchmarks

packers=("idealloc-r1" "idealloc-r21")

for packer in "${packers[@]}"
do
    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer

    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer/time
    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer/makespan

    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer

    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer/time
    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer/makespan
done

packers=("minimalloc" "triton" "tflite-equality" "tflite-greedy-breadth" "tflite-greedy-inorder" "tflite-greedy-size" "tflite-mincostflow" "tflite-naive" "xla-best-fit-repacker" "xla-desc-size-heap-sim" "tvm-greedy-conflict" "tvm-greedy-size" "tvm-hillclimb" "mindspore")

for packer in "${packers[@]}"
do
    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer

    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer/time
    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer/csv-out
    mkdir /workspace/results/time-makespan/minimalloc-benchmarks/$packer/makespan

    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer

    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer/time
    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer/csv-out
    mkdir /workspace/results/time-makespan/mindspore-benchmarks/$packer/makespan
done

mkdir /workspace/results/capacity-experiment
mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks
mkdir /workspace/results/capacity-experiment/mindspore-benchmarks

packers=("minimalloc" "tvm-hillclimb")

for packer in "${packers[@]}"
do
    mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/$packer

    mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/$packer/time
    
    mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/$packer

    mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/$packer/time

    percs=("125" "150" "175" "200")

    for perc in "${percs[@]}"
    do
        mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/$packer/$perc
        mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/$packer/$perc/csv-out
        mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/$packer/$perc/makespan

        mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/$packer/$perc
        mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/$packer/$perc/csv-out
        mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/$packer/$perc/makespan
    done
done

mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/idealloc

mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/idealloc/time

mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/idealloc

mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/idealloc/time

percs=("125" "150" "175" "200")

for perc in "${percs[@]}"
do
    mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/idealloc/$perc
    mkdir /workspace/results/capacity-experiment/minimalloc-benchmarks/idealloc/$perc/makespan

    mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/idealloc/$perc
    mkdir /workspace/results/capacity-experiment/mindspore-benchmarks/idealloc/$perc/makespan
done
