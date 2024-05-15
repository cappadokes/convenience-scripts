#!/bin/bash

adapt_bin="/workspace/idealloc/adapt"
report_bin="/workspace/idealloc/report"
bin="/workspace/tvm-wrapper/tvm_packer"

# loads=()

# while read -r number; do
#     loads+=("$number")
# done < /workspace/results/capacity-experiment/loads/minimalloc-loads.csv

# time_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/time/time.csv"
# > $time_file

# echo -e "\n\nRunning TVM-hillclimb for minimalloc-benchmarks (capacity experiment data)\n\n"

# percentages=("125" "130" "135")

# for percentage in "${percentages[@]}"; do  
#     echo "Capacity=$percentage% of maximum load"

#     capacities=()

#     for num in "${loads[@]}"; do
#         result=$(echo "scale=2; $num * $percentage / 100" | bc)
#         ceiling=$(echo "$result" | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}')
#         capacities+=("$ceiling")
#     done

#     index=0
#     for input in /workspace/benchmarks/minimalloc/*.csv; do
#         capacity=${capacities[$index]}
#         base_filename=$(basename "$input")
#         filename_no_ext="${base_filename%.*}"
#         time=$(BASE_PATH=/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb TRACE_NAME=$filename_no_ext-$percentage timeout 3m $bin $input hillclimb $capacity)
#         ret=$?
#         if [ $ret -eq 124 ]; then
#             echo -n "Failed," >> $time_file
#             if [ -f "/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-$percentage-out.csv" ]; then
#                 rm /workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-$percentage-out.csv
#             fi
#         else
#             echo -n "$time," >> "$time_file"
#         fi
#         ((index ++))
#     done
#     echo "" >> $time_file
# done

# outfiles="/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out"
# makespan_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/makespan/makespan.txt"
# > $makespan_file

# for file in $outfiles/*.csv; do
#     if [ -f "$file" ]; then
#         $adapt_bin $file
#         filename_no_ext=$(basename -- "$file" .csv)
#         output=$($report_bin "$filename_no_ext.plc" | grep Makespan | grep pages)
#         makespan=$(echo "$output" | awk '{print $NF}')
#         echo "$filename_no_ext: $makespan" >> "$makespan_file"
#         rm "$filename_no_ext.plc"
#         rm -rf '"'$filename_no_ext'"_m_62'
#     fi
# done

loads=()

while read -r number; do
    loads+=("$number")
done < /workspace/results/capacity-experiment/loads/mindspore-loads.csv

time_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/time/time.csv"
> $time_file

echo -e "\n\nRunning TVM-hillclimb for mindspore-benchmarks (capacity experiment data)\n\n"

percentages_resnet50=("100.5" "100.75" "101")
percentages_tiny_bert=("103.5" "105" "106.5")
inputs=("/workspace/benchmarks/minimalloc/resnet50.csv" "/workspace/benchmarks/minimalloc/tiny_bert.csv")

for i in {0..2}; do
    index=0
    for input in "${inputs[@]}"; do
        percentage=${capacities[$i]}
        load=${loads[$index]}

        result=$(echo "scale=4; $load * $percentage / 100" | bc)
        capacity=$(echo "$result" | awk '{print ($0-int($0)>0)?int($0)+1:int($0)}')

        echo "$(basename "$input") - $percentage - $load - $result - $capacity"

        # base_filename=$(basename "$input")
        # filename_no_ext="${base_filename%.*}"
        # time=$(BASE_PATH=/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb TRACE_NAME=$filename_no_ext-$percentage timeout 3m $bin $input hillclimb $capacity)
        # ret=$?
        # if [ $ret -eq 124 ]; then
        #     echo -n "Failed," >> $time_file
        #     if [ -f "/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-$percentage-out.csv" ]; then
        #         rm /workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-$percentage-out.csv
        #     fi
        # else
        #     echo -n "$time," >> "$time_file"
        # fi
        ((index++))
    done
    echo "" >> $time_file
done

# outfiles="/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out"
# makespan_file="/workspace/results/capacity-experiment/minimalloc-benchmarks/tvm-hillclimb/makespan/makespan.txt"
# > $makespan_file

# for file in $outfiles/*.csv; do
#     if [ -f "$file" ]; then
#         $adapt_bin $file
#         filename_no_ext=$(basename -- "$file" .csv)
#         output=$($report_bin "$filename_no_ext.plc" | grep Makespan | grep pages)
#         makespan=$(echo "$output" | awk '{print $NF}')
#         echo "$filename_no_ext: $makespan" >> "$makespan_file"
#         rm "$filename_no_ext.plc"
#         rm -rf '"'$filename_no_ext'"_m_62'
#     fi
# done

