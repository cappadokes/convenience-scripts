#!/bin/bash
benchmark_types=("minimalloc" "mindspore")
packers=("xla-best-fit-repacker" "xla-desc-size-heap-sim")
for packer in "${packers[@]}"; do
    for benchmark_type in "${benchmark_types[@]}"; do
        bin=""
        case $packer in
            "xla-best-fit-repacker")
                bin="/workspace/xla/bazel-bin/xla/service/memory_space_assignment/best_fit_repacker_prof"
                ;;
            "xla-desc-size-heap-sim")
                bin="/workspace/xla/bazel-bin/xla/service/bestfitheap_test"
                ;;
        esac

        time_file="/workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/time/time.csv"
        > $time_file

        echo -e "\n\nRunning XLA ($packer) for $benchmark_type-benchmarks (time-makespan data)\n\n"

        for ((i=1; i<=20; i++)) do  
            echo "$i out of 20 runs"
            for input in /workspace/benchmarks/$benchmark_type/*.csv; do
                base_filename=$(basename "$input")
                filename_no_ext="${base_filename%.*}"
                time=$(BASE_PATH=/workspace/results/time-makespan/$benchmark_type-benchmarks/$packer TRACE_NAME=$filename_no_ext timeout --foreground 3m $bin $input)
                ret=$?
                if [ $ret -eq 124 ]; then
                    echo -n "Failed," >> $time_file
                    if [ -f "/workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/csv-out/$filename_no_ext-out.csv" ]; then
                        rm /workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/csv-out/$filename_no_ext-out.csv
                    fi
                else
                    echo -n "$time," >> "$time_file"
                fi
            done
            echo "" >> $time_file
        done

        outfiles="/workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/csv-out"
        makespan_file="/workspace/results/time-makespan/$benchmark_type-benchmarks/$packer/makespan/makespan.txt"
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
    done
done

python3 /workspace/convenience-scripts/sort-results-xla-heap.py