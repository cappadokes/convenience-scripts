#!/bin/bash

loads=()

while IFS=',' read -ra line; do
    for num in "${line[@]}"; do
        loads+=("$num")
    done
done < /workspace/results/capacity-experiment/loads/minimalloc-loads.csv

printf '%s\n' "${loads[@]}"

# time_file="/workspace/results/capactiy-experiment/minimalloc-benchmarks/tvm-hillclimb/time/time.csv"
# > $time_file

# echo -e "\n\nRunning TVM-hillclimb for minimalloc-benchmarks (capacity experiment data)\n\n"

# for percentage in "${percentages[@]}"; do  
#     echo "Capacity=$percentage% of maximum load"
#     for input in /workspace/benchmarks/minimalloc/*.csv; do
#         base_filename=$(basename "$input")
#         filename_no_ext="${base_filename%.*}"
#         time=$(BASE_PATH=/workspace/results/capactiy-experiment/minimalloc-benchmarks/tvm-hillclimb TRACE_NAME=$filename_no_ext timeout 3m $bin $input hillclimb $capacity)
#         ret=$?
#         if [ $ret -eq 124 ]; then
#             echo -n "Failed," >> $time_file
#             if [ -f "/workspace/results/capactiy-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-out.csv" ]; then
#                 rm /workspace/results/capactiy-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out/$filename_no_ext-out.csv
#             fi
#         else
#             echo -n "$time," >> "$time_file"
#         fi
#     done
#     echo "" >> $time_file
# done

# outfiles="/workspace/results/capactiy-experiment/minimalloc-benchmarks/tvm-hillclimb/csv-out"
# makespan_file="/workspace/results/capactiy-experiment/minimalloc-benchmarks/tvm-hillclimb/makespan/makespan.txt"
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
