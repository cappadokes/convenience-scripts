#!/bin/bash

adapt_bin="/workspace/idealloc/adapt"
coreba_bin="/workspace/idealloc/coreba"

tensor_sets_arr=("/workspace/benchmarks/minimalloc" "/workspace/benchmarks/mindspore")

for tensor_sets in "${tensor_sets_arr[@]}"
do
    times=0
    dir=""
    case $tensor_sets in
        "/workspace/benchmarks/minimalloc")
            dir="minimalloc-benchmarks"
            ;;
        "/workspace/benchmarks/mindspore")
            dir="mindspore-benchmarks"
            ;;
    esac

    makespan_file="/workspace/results/time-makespan/$dir/idealloc-r1/makespan/makespan.txt"
    > $makespan_file

    time_file="/workspace/results/time-makespan/$dir/idealloc-r1/time/time.csv"
    > $time_file

    echo -e "\n\nRunning Idealloc (1 iteration) for $dir\n\n"

    for ((i=1; i<=20; i++)); do
        echo "$i out of 20 runs"
        > $makespan_file
        for file in $tensor_sets/*.csv; do
            if [ -f "$file" ]; then
                $adapt_bin $file
                filename_no_ext=$(basename -- "$file" .csv)
                output=$(timeout 3m $coreba_bin 1 MCTS:RAND "$filename_no_ext.plc")
                ret=$?
                makespan=$(echo "$output" | grep -oE 'Improved! Current best = [0-9]+' | tail -n 1 | awk '{print $5}')
                time=$(echo "$output" | grep -oE 'Allocation time was [0-9]+' | awk '{print $4}')

                if [ $ret -eq 124 ]; then
                    echo -n "Failed," >> "$time_file"
                else
                    echo "$filename_no_ext: $makespan" >> "$makespan_file"
                    echo -n "$time," >> "$time_file"
                fi
                
                rm "$filename_no_ext.plc"
                rm optimized*
            fi
        done
        echo "" >> $time_file
    done

    makespan_file="/workspace/results/time-makespan/$dir/idealloc-r21/makespan/makespan.txt"
    > $makespan_file

    time_file="/workspace/results/time-makespan/$dir/idealloc-r21/time/time.csv"
    > $time_file

    echo -e "\n\nRunning Idealloc (21 iterations) for $dir\n\n"

    for ((i=1; i<=20; i++)); do
        echo "$i out of 20 runs"
        > $makespan_file
        for file in $tensor_sets/*.csv; do
            if [ -f "$file" ]; then
                $adapt_bin $file
                filename_no_ext=$(basename -- "$file" .csv)
                output=$(timeout 3m $coreba_bin 21 MCTS:RAND "$filename_no_ext.plc")
                ret=$?
                makespan=$(echo "$output" | grep -oE 'Improved! Current best = [0-9]+' | tail -n 1 | awk '{print $5}')
                time=$(echo "$output" | grep -oE 'Allocation time was [0-9]+' | awk '{print $4}')
                
                if [ $ret -eq 124 ]; then
                    echo -n "Failed," >> "$time_file"
                else
                    echo "$filename_no_ext: $makespan" >> "$makespan_file"
                    echo -n "$time," >> "$time_file"
                fi

                rm "$filename_no_ext.plc"
                rm optimized*
            fi
        done
        echo "" >> $time_file
    done
done