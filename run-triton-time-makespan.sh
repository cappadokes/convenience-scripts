#!/bin/bash

time_file="/workspace/results/time-makespan/minimalloc-benchmarks/triton/time/time.csv"
> $time_file

echo -e "\n\nRunning Triton for minimalloc-benchmarks\n\n"

for ((i=1; i<=20; i++))
do  
    echo "$i out of 20 runs"
    for input in /workspace/benchmarks/minimalloc/*.csv; do
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        time=$(BASE_PATH=/workspace/results/time-makespan/minimalloc-benchmarks/triton TRACE_NAME=$filename_no_ext timeout 3m /workspace/triton/triton_packer $input)
        ret=$?
        if [ $ret -eq 124 ]; then
            echo -n "Failed," >> $time_file
            if [ -f "/workspace/results/time-makespan/minimalloc-benchmarks/triton/csv-out/$filename_no_ext-out.csv" ]; then
                rm /workspace/results/time-makespan/minimalloc-benchmarks/triton/csv-out/$filename_no_ext-out.csv
            fi
        else
            echo -n "$time," >> "$time_file"
        fi
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/minimalloc-benchmarks/triton/csv-out"
makespan_file="/workspace/results/time-makespan/minimalloc-benchmarks/triton/makespan/makespan.txt"
> $makespan_file

adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"

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

time_file="/workspace/results/time-makespan/mindspore-benchmarks/triton/time/time.csv"
> $time_file

echo -e "\n\nRunning Triton for mindspore-benchmarks\n\n"

for ((i=1; i<=20; i++))
do  
    echo "$i out of 20 runs"
    for input in /workspace/benchmarks/mindspore/*.csv; do
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        time=$(BASE_PATH=/workspace/results/time-makespan/mindspore-benchmarks/triton TRACE_NAME=$filename_no_ext timeout 3m /workspace/triton/triton_packer $input)
        ret=$?
        if [ $ret -eq 124 ]; then
            echo -n "Failed," >> $time_file
            if [ -f "/workspace/results/time-makespan/mindspore-benchmarks/triton/csv-out/$filename_no_ext-out.csv" ]; then
                rm /workspace/results/time-makespan/mindspore-benchmarks/triton/csv-out/$filename_no_ext-out.csv
            fi
        else
            echo -n "$time," >> "$time_file"
        fi
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/mindspore-benchmarks/triton/csv-out"
makespan_file="/workspace/results/time-makespan/mindspore-benchmarks/triton/makespan/makespan.txt"
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
