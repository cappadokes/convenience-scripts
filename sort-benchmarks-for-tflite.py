import os
import csv


def sort_and_write_csv(input_file, output_file):
    data = []
    with open(input_file, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)
        for row in csv_reader:
            data.append((int(row[0]), int(row[1]), int(row[2]), int(row[3])))

    sorted_data = sorted(data, key=lambda x: (x[1], x[2]))

    with open(output_file, 'w', newline='') as file:
        csv_writer = csv.writer(file)
        csv_writer.writerow(['id', 'lower', 'upper', 'size'])
        for entry in sorted_data:
            csv_writer.writerow(entry)


def process_dir(input_directory, output_directory):
    for filename in os.listdir(input_directory):
        if filename.endswith('.csv'):
            input_file_path = os.path.join(input_directory, filename)
            output_file_path = os.path.join(output_directory, filename)
            sort_and_write_csv(input_file_path, output_file_path)


input1 = "/workspace/benchmarks/minimalloc"
output1 = "/workspace/benchmarks/presorted/minimalloc"
input2 = "/workspace/benchmarks/mindspore"
output2 = "/workspace/benchmarks/presorted/mindspore"

process_dir(input1, output1)
process_dir(input2, output2)