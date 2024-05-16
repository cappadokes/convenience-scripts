#!/bin/bash

adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"

loads=()

while read -r number; do
    loads+=("$number")
done < /workspace/results/capacity-experiment/loads/minimalloc-loads.csv

time_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/time/time.csv"
> $time_file

echo -e "\n\nRunning Minimalloc for minimalloc-benchmarks (capacity experiment data)\n\n"

percentages=("125" "130" "135")

for percentage in "${percentages[@]}"; do  
    echo "Capacity=$percentage% of maximum load"

    capacities=()

    for num in "${loads[@]}"; do
        result=$(echo "scale=2; $num * $percentage / 100" | bc)
        ceiling=$(echo "$result" | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}')
        capacities+=("$ceiling")
    done

    index=0
    for input in /workspace/benchmarks/minimalloc/*.csv; do
        capacity=${capacities[$index]}
        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        new_filename="${filename_no_ext}-$percentage-out.csv"
        time=$(timeout --foreground 3m /workspace/minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/csv-out/$new_filename 2>&1)

        if [ $? -eq 124 ]; then
            time=$(timeout --foreground 3m /workspace/minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/csv-out/$new_filename --canonical_only=false --check_dominance=false --monotonic_floor=false 2>&1)
            if [ $? -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/csv-out/$new_filename" ]; then
                    rm /workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/csv-out/$new_filename
                fi
            else
                time=$(awk -v seconds="$time" 'BEGIN { printf "%.0f", seconds * 1000000 }')
                echo -n "$time," >> $time_file
            fi
        else
            time=$(awk -v seconds="$time" 'BEGIN { printf "%.0f", seconds * 1000000 }')
            echo -n "$time," >> $time_file
        fi
        ((index ++))
    done
    echo "" >> $time_file
done

outfiles="/workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/csv-out"
makespan_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/minimalloc/makespan/makespan.txt"
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

loads=()

while read -r number; do
    loads+=("$number")
done < /workspace/results/capacity-experiment/loads/mindspore-loads.csv

time_file="/workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/time/time.csv"
> $time_file

echo -e "\n\nRunning Minimalloc for mindspore-benchmarks (capacity experiment data)\n\n"

percentages_resnet50=("100.5" "100.75" "101")
percentages_tiny_bert=("103.5" "105" "106.5")
inputs=("/workspace/benchmarks/mindspore/resnet50.csv" "/workspace/benchmarks/mindspore/tiny_bert.csv")

for i in {0..2}; do
    for input in "${inputs[@]}"; do
        percentage=""
        load=""
        case $input in
            "/workspace/benchmarks/mindspore/resnet50.csv")
                load=${loads[0]}
                percentage=${percentages_resnet50[$i]}
                ;;
            "/workspace/benchmarks/mindspore/tiny_bert.csv")
                load=${loads[1]}
                percentage=${percentages_tiny_bert[$i]}
                ;;
        esac

        result=$(echo "scale=2; $load * $percentage / 100" | bc)
        capacity=$(echo "$result" | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}')

        base_filename=$(basename "$input")
        filename_no_ext="${base_filename%.*}"
        new_filename="${filename_no_ext}-$percentage-out.csv"
        time=$(timeout --foreground 3m /workspace/minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/csv-out/$new_filename 2>&1)

        if [ $? -eq 124 ]; then
            time=$(timeout --foreground 3m /workspace/minimalloc/minimalloc --capacity=$capacity --input=$input --output=/workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/csv-out/$new_filename --canonical_only=false --check_dominance=false --monotonic_floor=false 2>&1)
            if [ $? -eq 124 ]; then
                echo -n "Failed," >> $time_file
                if [ -f "/workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/csv-out/$new_filename" ]; then
                    rm /workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/csv-out/$new_filename
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

outfiles="/workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/csv-out"
makespan_file="/workspace/results/capacity-experiment/mindspore-benchmarks/minimalloc/makespan/makespan.txt"
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

