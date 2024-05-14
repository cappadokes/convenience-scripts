#!/bin/bash

time_file="/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/time/time.csv"
> $time_file

for ((i=1; i<=2; i++))
do
    echo "$i out of 20 runs"
    for input in /workspace/benchmarks/minimalloc/*.csv; do
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        new_filename="${filename_no_ext}-out.csv"

        echo "./minimalloc/minimalloc --capacity=1048576 --input=$input --output=new-outputs/$new_filename"

        start_time=$(date +%s%N)
        timeout 3m ./minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename
        ret=$?
        end_time=$(date +%s%N)

        if [ $ret -eq 124 ]; then
            echo "Timeout occurred for $input, running with new flags..."
            start_time=$(date +%s%N)
            timeout 3m ./minimalloc/minimalloc --capacity=1048576 --input=$input --output=/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename --canonical_only=false --check_dominance=false --monotonic_floor=false
            ret=$?
            end_time=$(date +%s%N)
            if [ $ret -eq 124 ]; then
                echo -n "Failed," >> $time_file
                rm /workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out/$new_filename
            else
                elapsed_time=$(( ($end_time - $start_time) / 1000 ))
                echo -n "$elapsed_time," >> $time_file
            fi
        else
            elapsed_time=$(( ($end_time - $start_time) / 1000 ))
            echo -n "$elapsed_time," >> $time_file
        fi
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/csv-out"
makespan_file="/workspace/results/time-makespan/minimalloc-benchmarks/minimalloc/makespan/makespan.csv"
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

idealloc_res=()

while IFS=',' read -ra line; do
    for num in "${line[@]}"; do
        idealloc_res+=("$num")
    done
done < /workspace/results/time-makespan/mindspore-benchmarks/idealloc-r21/makespan/makespan.csv

time_file="/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/time/time.csv"
> $time_file

for ((i=1; i<=2; i++))
do
    index=0
    for input in /workspace/benchmarks/mindspore/*.csv; do
        capacity=$(( ${idealloc_res[$index]} * 4096 ))
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        new_filename="${filename_no_ext}-out.csv"

        echo "./minimalloc/minimalloc --capacity=$capacity --input=$input --output=new-outputs/$new_filename"

        start_time=$(date +%s%N)
        timeout 3m ./minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename
        ret=$?
        end_time=$(date +%s%N)

        if [ $ret -eq 124 ]; then
            echo "Timeout occurred for $input, running with new flags..."
            start_time=$(date +%s%N)
            timeout 3m ./minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename --canonical_only=false --check_dominance=false --monotonic_floor=false
            ret=$?
            end_time=$(date +%s%N)
            if [ $ret -eq 124 ]; then
                echo -n "Failed," >> $time_file
                rm /workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out/$new_filename
            else
                elapsed_time=$(( ($end_time - $start_time) / 1000 ))
                echo -n "$elapsed_time," >> $time_file
            fi
        else
            elapsed_time=$(( ($end_time - $start_time) / 1000 ))
            echo -n "$elapsed_time," >> $time_file
        fi

        ((index++))
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/csv-out"
makespan_file="/workspace/results/time-makespan/mindspore-benchmarks/minimalloc/makespan/makespan.csv"
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