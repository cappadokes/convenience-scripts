import os
import csv

def sort_and_write_csv(input_file, output_file):
    data = []
    with open(input_file, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)
        for row in csv_reader:
            data.append((int(row[0]), int(row[1]), int(row[2]), int(row[3]), int(row[4])))

    sorted_data = sorted(data, key=lambda x: x[0])

    with open(output_file, 'w', newline='') as file:
        csv_writer = csv.writer(file)
        csv_writer.writerow(['id', 'lower', 'upper', 'size', 'offset'])
        for entry in sorted_data:
            csv_writer.writerow(entry)


def process_dir(input_directory, output_directory):
    for filename in os.listdir(input_directory):
        if filename.endswith('out.csv'):
            input_file_path = os.path.join(input_directory, filename)
            output_file_path = os.path.join(output_directory, filename)
            sort_and_write_csv(input_file_path, output_file_path)

input_directory = '/workspace/results/time-makespan/minimalloc-benchmarks/xla-desc-size-heap-sim/csv-out'
output_directory = input_directory
process_dir(input_directory, output_directory)

input_directory = '/workspace/results/time-makespan/mindspore-benchmarks/xla-desc-size-heap-sim/csv-out'
output_directory = input_directory
process_dir(input_directory, output_directory)

