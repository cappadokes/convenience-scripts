#!/bin/bash

output_dir="/workspace/results/time-makespan/minimalloc-benchmarks/xla-desc-size-heap-sim/csv-out"
load_file="/workspace/capacity-experiment/loads/minimalloc-loads.csv"
> $load_file

for file in $output_dir/*.csv; do
    if [ -f "$file" ]; then
        $adapt_bin $file
        filename_no_ext=$(basename -- "$file" .csv)
        output=$($report_bin "$filename_no_ext.plc" | grep "Max load:" | grep at)
        load=$(echo "$output" | awk '{print $3}')
        echo "$load," >> "$load_file"
        rm "$filename_no_ext.plc"
        rm -rf '"'$filename_no_ext'"_m_62'
    fi
done