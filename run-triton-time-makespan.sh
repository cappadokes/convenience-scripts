#!/bin/bash

adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"

benchmark_types=("minimalloc" "mindspore")
for benchmark_type in "${benchmark_types[@]}"; do
    time_file="/workspace/results/time-makespan/$benchmark_type-benchmarks/triton/time/time.csv"
    > $time_file

    echo -e "\n\nRunning Triton for $benchmark_type-benchmarks (time-makespan data)\n\n"

    for ((i=1; i<=20; i++)) do  
        echo "$i out of 20 runs"
        for input in /workspace/benchmarks/$benchmark_type/*.csv; do
            base_filename=$(basename "$input")
            filename_no_ext="${base_filename%.*}"
            time=$(BASE_PATH=/workspace/results/time-makespan/$benchmark_type-benchmarks/triton TRACE_NAME=$filename_no_ext timeout 3m /workspace/triton/triton_packer $input)
            ret=$?
            if [ $ret -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/time-makespan/$benchmark_type-benchmarks/triton/csv-out/$filename_no_ext-out.csv" ]; then
                    rm /workspace/results/time-makespan/$benchmark_type-benchmarks/triton/csv-out/$filename_no_ext-out.csv
                fi
            else
                echo -n "$time," >> "$time_file"
            fi
        done
        echo "" >> $time_file
    done

    outfiles="/workspace/results/time-makespan/$benchmark_type-benchmarks/triton/csv-out"
    makespan_file="/workspace/results/time-makespan/$benchmark_type-benchmarks/triton/makespan/makespan.txt"
    > $makespan_file

    for file in $outfiles/*.csv; do
        if [ -f "$file" ]; then
            $adapt_bin $file
            filename_no_ext=$(basename -- "$file" .csv)
            output=$($report_bin "$filename_no_ext.plc" | grep Makespan | grep pages)
            makespan=$(echo "$output" | awk '{print $NF}')
            echo "$filename_no_ext: $makespan" >> "$makespan_file"
            rm "$filename_no_ext.plc"
            rm -rf '"'$filename_no_ext'"_m_62'
        fi
    done
done