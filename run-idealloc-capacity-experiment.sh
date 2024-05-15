#!/bin/bash

adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"
coreba_bin="/workspace/idealloc/coreba"

loads=()

while read -r number; do
    loads+=("$number")
done < /workspace/results/capacity-experiment/loads/minimalloc-loads.csv

idealloc_versions=("idealloc-r1" "idealloc-montecarlo-0" "idealloc-montecarlo-0.1" "idealloc-montecarlo-0.4")

for idealloc_version in "${idealloc_versions[@]}"; do
    flags=""
    case $idealloc_version in
        "idealloc-r1")
            flags="1 MCTS:RAND"
            ;;
        "idealloc-montecarlo-0")
            flags="MCTS:UCT\(0\)"
            ;;
        "idealloc-montecarlo-0.1")
            flags="MCTS:UCT\(0.1\)"
            ;;
        "idealloc-montecarlo-0.4")
            flags="MCTS:UCT\(0.4\)"
            ;;
    esac

    time_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/$idealloc_version/time/time.csv"
    > $time_file

    makespan_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/$idealloc_version/makespan/makespan.txt"
    > $makespan_file

    echo -e "\n\nRunning Idealloc($idealloc_version) for minimalloc-benchmarks (capacity experiment data)\n\n"

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
            # $adapt_bin $input
            # filename_no_ext=$(basename -- "$input" .csv)
            # output=$(timeout 3m $coreba_bin --capacity=$capacity $flags "$filename_no_ext.plc")
            # ret=$?
            # makespan=$(echo "$output" | grep -oE 'Improved! Current best = [0-9]+' | tail -n 1 | awk '{print $5}')
            # time=$(echo "$output" | grep -oE 'Allocation time was [0-9]+' | awk '{print $4}')

            # if [ $ret -eq 124 ]; then
            #     echo -n "Failed," >> "$time_file"
            # else
            #     echo "$filename_no_ext: $makespan" >> "$makespan_file"
            #     echo -n "$time," >> "$time_file"
            # fi
            
            # rm "$filename_no_ext.plc"
            # rm optimized*
            echo "Running $idealloc_version with capacity $capacity for input $(basename -- "$input" .csv)"
            ((index ++))
        done
        echo "" >> $time_file
    done

    loads=()

    while read -r number; do
        loads+=("$number")
    done < /workspace/results/capacity-experiment/loads/mindspore-loads.csv

    time_file="/workspace/results/capacity-experiment/mindspore-benchmarks/$idealloc_version/time/time.csv"
    > $time_file

    makespan_file="/workspace/results/capacity-experiment/mindspore-benchmarks/$idealloc_version/makespan/makespan.txt"
    > $makespan_file

    echo -e "\n\nRunning Idealloc($idealloc_version) for mindspore-benchmarks (capacity experiment data)\n\n"

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

            # $adapt_bin $input
            # filename_no_ext=$(basename -- "$input" .csv)
            # output=$(timeout 3m $coreba_bin --capacity=$capacity $flags "$filename_no_ext.plc")
            # ret=$?
            # makespan=$(echo "$output" | grep -oE 'Improved! Current best = [0-9]+' | tail -n 1 | awk '{print $5}')
            # time=$(echo "$output" | grep -oE 'Allocation time was [0-9]+' | awk '{print $4}')

            # if [ $ret -eq 124 ]; then
            #     echo -n "Failed," >> "$time_file"
            # else
            #     echo "$filename_no_ext: $makespan" >> "$makespan_file"
            #     echo -n "$time," >> "$time_file"
            # fi
            
            # rm "$filename_no_ext.plc"
            # rm optimized*
            echo "Running $idealloc_version with capacity $capacity for input $(basename -- "$input" .csv)"
        done
        echo "" >> $time_file
    done
done
