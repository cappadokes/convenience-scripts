#!/bin/bash

algorithms=("equality" "greedy-breadth" "greedy-size" "greedy-inorder" "mincostflow" "naive")
bin="/workspace/tensorflow/bazel-bin/tensorflow/lite/delegates/gpu/common/packing_profile_test"
adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"

for algo in "${algorithms[@]}"; do
    time_file="/workspace/results/time-makespan/minimalloc-benchmarks/tflite-$algo/time/time.csv"
    > $time_file

    echo -e "\n\nRunning TFLite-$algo for minimalloc-benchmarks\n\n"

    for ((i=1; i<=2; i++))
    do  
        echo "$i out of 20 runs"
        for input in /workspace/benchmarks/presorted/minimalloc/*.csv; do
            base_filename=$(basename "$input")
            filename_no_ext="${base_filename%.*}"
            time=$(BASE_PATH=/workspace/results/time-makespan/minimalloc-benchmarks/tflite-$algo TRACE_NAME=$filename_no_ext timeout 3m $bin $input $algo)
            ret=$?
            if [ $ret -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/time-makespan/minimalloc-benchmarks/tflite-$algo/csv-out/$filename_no_ext-out.csv" ]; then
                    rm /workspace/results/time-makespan/minimalloc-benchmarks/tflite-$algo/csv-out/$filename_no_ext-out.csv
                fi
            else
                echo -n "$time," >> "$time_file"
            fi
        done
        echo "" >> $time_file
    done

    outfiles="/workspace/results/time-makespan/minimalloc-benchmarks/tflite-$algo/csv-out"
    makespan_file="/workspace/results/time-makespan/minimalloc-benchmarks/tflite-$algo/makespan/makespan.txt"
    > $makespan_file

    for file in $outfiles/*.csv; do
        if [ -f "$file" ]; then
            $adapt_bin $file
            filename_no_ext=$(basename -- "$file" .csv)
            output=$($report_bin "$filename_no_ext.plc")
            makespan=$(echo "$output" | sed -n '3 s/[^0-9]*\([0-9]*\).*/\1/p')
            echo "$filename_no_ext: $makespan" >> "$makespan_file"
            rm "$filename_no_ext.plc"
            rm -rf '"'$filename_no_ext'"_m_62'
        fi
    done

    time_file="/workspace/results/time-makespan/mindspore-benchmarks/tflite-$algo/time/time.csv"
    > $time_file

    echo -e "\n\nRunning TFLite-$algo for mindspore-benchmarks\n\n"

    for ((i=1; i<=2; i++))
    do  
        echo "$i out of 20 runs"
        for input in /workspace/benchmarks/presorted/mindspore/*.csv; do
            base_filename=$(basename "$input")
            filename_no_ext="${base_filename%.*}"
            time=$(BASE_PATH=/workspace/results/time-makespan/mindspore-benchmarks/tflite-$algo TRACE_NAME=$filename_no_ext timeout 3m $bin $input $algo)
            ret=$?
            if [ $ret -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/time-makespan/mindspore-benchmarks/tflite-$algo/csv-out/$filename_no_ext-out.csv" ]; then
                    rm /workspace/results/time-makespan/mindspore-benchmarks/tflite-$algo/csv-out/$filename_no_ext-out.csv
                fi
            else
                echo -n "$time," >> "$time_file"
            fi
        done
        echo "" >> $time_file
    done

    outfiles="/workspace/results/time-makespan/mindspore-benchmarks/tflite-$algo/csv-out"
    makespan_file="/workspace/results/time-makespan/mindspore-benchmarks/tflite-$algo/makespan/makespan.txt"
    > $makespan_file

    for file in $outfiles/*.csv; do
        if [ -f "$file" ]; then
            $adapt_bin $file
            filename_no_ext=$(basename -- "$file" .csv)
            output=$($report_bin "$filename_no_ext.plc")
            makespan=$(echo "$output" | sed -n '3 s/[^0-9]*\([0-9]*\).*/\1/p')
            echo "$filename_no_ext: $makespan" >> "$makespan_file"
            rm "$filename_no_ext.plc"
            rm -rf '"'$filename_no_ext'"_m_62'
        fi
    done
done
