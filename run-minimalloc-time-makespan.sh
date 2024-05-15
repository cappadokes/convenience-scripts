#!/bin/bash

time_file="/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/time/time.csv"
> $time_file

echo -e "\n\nRunning Minimalloc for minimalloc-benchmarks (time-makespan data)\n\n"

for ((i=1; i<=20; i++)) do
    echo "$i out of 20 runs"
    for input in /workspace/benchmarks/minimalloc/*.csv; do
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        new_filename="${filename_no_ext}-out.csv"

        time=$(timeout 3m /workspace/minimalloc/minimalloc --capacity=1048576 --input=$input --output=/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename 2>&1)

        if [ $? -eq 124 ]; then
            time=$(timeout 3m /workspace/minimalloc/minimalloc --capacity=1048576 --input=$input --output=/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename --canonical_only=false --check_dominance=false --monotonic_floor=false 2>&1)
            if [ $? -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename" ]; then
                    rm /workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename
                fi
            else
                time=$(awk -v seconds="$time" 'BEGIN { printf "%.0f", seconds * 1000000 }')
                echo -n "$time," >> $time_file
            fi
        else
            time=$(awk -v seconds="$time" 'BEGIN { printf "%.0f", seconds * 1000000 }')
            echo -n "$time," >> $time_file
        fi
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out"
makespan_file="/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/makespan/makespan.txt"
> $makespan_file

adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"

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

idealloc_res=()

while read -r _ number; do
    idealloc_res+=("$number")
done < /workspace/results/time-makespan/mindspore-benchmarks/idealloc-r21/makespan/makespan.txt

time_file="/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/time/time.csv"
> $time_file

echo -e "\n\nRunning Minimalloc for mindspore-benchmarks (time-makespan data)\n\n"

for ((i=1; i<=20; i++)) do
    echo "$i out of 20 runs"
    index=0
    for input in /workspace/benchmarks/mindspore/*.csv; do
        capacity=$(( ${idealloc_res[$index]} * 4096 ))
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        new_filename="${filename_no_ext}-out.csv"

        time=$(timeout 3m /workspace/minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename 2>&1)

        if [ $? -eq 124 ]; then
            time=$(timeout 3m /workspace/minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename --canonical_only=false --check_dominance=false --monotonic_floor=false 2>&1)
            if [ $? -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename" ]; then
                    rm /workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename
                fi
            else
                time=$(awk -v seconds="$time" 'BEGIN { printf "%.0f", seconds * 1000000 }')
                echo -n "$time," >> $time_file
            fi
        else
            time=$(awk -v seconds="$time" 'BEGIN { printf "%.0f", seconds * 1000000 }')
            echo -n "$time," >> $time_file
        fi

        ((index++))
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out"
makespan_file="/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/makespan/makespan.txt"
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