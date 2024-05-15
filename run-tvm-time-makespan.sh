#!/bin/bash

algorithms=("greedy-size" "greedy-conflict")
bin="/workspace/tvm-wrapper/tvm_packer"
adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"

benchmark_types=("minimalloc" "mindspore")
for algo in "${algorithms[@]}"; do
    for benchmark_type in "${benchmark_types[@]}"; do
        time_file="/workspace/results/time-makespan/$benchmark_type-benchmarks/tvm-$algo/time/time.csv"
        > $time_file

        echo -e "\n\nRunning TVM-$algo for $benchmark_type-benchmarks\n\n"

        for ((i=1; i<=20; i++)) do  
            echo "$i out of 20 runs"
            for input in /workspace/benchmarks/$benchmark_type/*.csv; do
                base_filename=$(basename "$input")
                filename_no_ext="${base_filename%.*}"
                time=$(BASE_PATH=/workspace/results/time-makespan/$benchmark_type-benchmarks/tvm-$algo TRACE_NAME=$filename_no_ext timeout 3m $bin $input $algo 1)
                ret=$?
                if [ $ret -eq 124 ]; then
                    echo -n "Failed," >> $time_file
                    if [ -f "/workspace/results/time-makespan/$benchmark_type-benchmarks/tvm-$algo/csv-out/$filename_no_ext-out.csv" ]; then
                        rm /workspace/results/time-makespan/$benchmark_type-benchmarks/tvm-$algo/csv-out/$filename_no_ext-out.csv
                    fi
                else
                    echo -n "$time," >> "$time_file"
                fi
            done
            echo "" >> $time_file
        done

        outfiles="/workspace/results/time-makespan/$benchmark_type-benchmarks/tvm-$algo/csv-out"
        makespan_file="/workspace/results/time-makespan/$benchmark_type-benchmarks/tvm-$algo/makespan/makespan.txt"
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
done


time_file="/workspace/results/time-makespan/minimalloc-benchmarks/tvm-hillclimb/time/time.csv"
> $time_file

echo -e "\n\nRunning TVM-hillclimb for minimalloc-benchmarks\n\n"

for ((i=1; i<=20; i++)) do  
    echo "$i out of 20 runs"
    for input in /workspace/benchmarks/minimalloc/*.csv; do
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        time=$(BASE_PATH=/workspace/results/time-makespan/minimalloc-benchmarks/tvm-hillclimb TRACE_NAME=$filename_no_ext timeout 3m $bin $input hillclimb 1048576)
        ret=$?
        if [ $ret -eq 124 ]; then
            echo -n "Failed," >> $time_file
            if [ -f "/workspace/results/time-makespan/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-out.csv" ]; then
                rm /workspace/results/time-makespan/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-out.csv
            fi
        else
            echo -n "$time," >> "$time_file"
        fi
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/minimalloc-benchmarks/tvm-hillclimb/csv-out"
makespan_file="/workspace/results/time-makespan/minimalloc-benchmarks/tvm-hillclimb/makespan/makespan.txt"
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

time_file="/workspace/results/time-makespan/mindspore-benchmarks/tvm-hillclimb/time/time.csv"
> $time_file

echo -e "\n\nRunning TVM-hillclimb for mindspore-benchmarks\n\n"

idealloc_res=()

while read -r _ number; do
    idealloc_res+=("$number")
done < /workspace/results/time-makespan/mindspore-benchmarks/idealloc-r21/makespan/makespan.txt

for ((i=1; i<=20; i++)) do  
    echo "$i out of 20 runs"
    index=0
    for input in /workspace/benchmarks/mindspore/*.csv; do
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        capacity=$(( ${idealloc_res[$index]} * 4096 ))
        time=$(BASE_PATH=/workspace/results/time-makespan/mindspore-benchmarks/tvm-hillclimb TRACE_NAME=$filename_no_ext timeout 3m $bin $input hillclimb $capacity)
        ret=$?
        if [ $ret -eq 124 ]; then
            echo -n "Failed," >> $time_file
            if [ -f "/workspace/results/time-makespan/mindspore-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-out.csv" ]; then
                rm /workspace/results/time-makespan/mindspore-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-out.csv
            fi
        else
            echo -n "$time," >> "$time_file"
        fi
        ((index++))
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/mindspore-benchmarks/tvm-hillclimb/csv-out"
makespan_file="/workspace/results/time-makespan/mindspore-benchmarks/tvm-hillclimb/makespan/makespan.txt"
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
