import os
import subprocess

# Define the parent directory and the qc_output directory
parent_dir = '/home/pc/master/deadlines_assignments_papers_lectures/fmp/fmp_tagliaferri/tagliaferri_marabotti_task/raw_data'
output_dir = os.path.join(parent_dir, 'qc_output')

# List of trimmed FASTQ files
fastq_files = [
    'SRR7052564_trimmed.fq.gz',
    'SRR7052565_trimmed.fq.gz',
    'SRR7052566_trimmed.fq.gz',
    'SRR7052567_trimmed.fq.gz',
    'SRR7052568_trimmed.fq.gz',
    'SRR7052569_trimmed.fq.gz'
]

# Create the rRNA_removed directory inside qc_output
rrna_removed_dir = os.path.join(output_dir, 'rRNA_removed')
os.makedirs(rrna_removed_dir, exist_ok=True)

# Path to SortMeRNA executable
sortmerna_exec = '/home/pc/miniconda3/envs/tagliaferri_task/bin/sortmerna'

# Path to rRNA databases (update these paths according to your setup)
rrna_db = '/home/pc/master/deadlines_assignments_papers_lectures/fmp/fmp_tagliaferri/tagliaferri_marabotti_task/raw_data/human_rRNA_2.fa'

# Check if SortMeRNA is installed and accessible
try:
    subprocess.run([sortmerna_exec, '--version'], check=True)
except FileNotFoundError:
    print(f"Error: {sortmerna_exec} not found. Please ensure SortMeRNA is installed and in your PATH.")
    exit(1)
except subprocess.CalledProcessError as e:
    print(f"Error checking SortMeRNA version: {e}")
    exit(1)

# Perform rRNA removal on each trimmed FASTQ file
for fastq in fastq_files:
    try:
        # Construct the full path to the FASTQ file
        fastq_path = os.path.join(output_dir, fastq)
        
        # Define the output file paths
        output_prefix = os.path.join(rrna_removed_dir, os.path.basename(fastq).replace('_trimmed_fq.gz', '_rRNA_removed'))
        aligned_file = f"{output_prefix}_aligned.fq"
        other_file = f"{output_prefix}_other.fq"
       
        # Ensure kvdb directory is empty
        subprocess.run('rm -rf /home/pc/sortmerna/run/kvdb/*', shell=True, check=True)


        # Run SortMeRNA
        sortmerna_cmd = [
            sortmerna_exec,
            '--ref', rrna_db,
            '--reads', fastq_path,
            '--aligned', aligned_file,
            '--other', other_file,
            '--fastx',
            '--log'
        ]
        
        subprocess.run(sortmerna_cmd, check=True)
        
        # Compress the resulting files if not already compressed
        for file in [aligned_file, other_file]:
            if not file.endswith('.gz'):
                subprocess.run(['gzip', file])
                print(f"Compressed {file} to {file}.gz")
        
        print(f"rRNA removed files for {fastq}: {aligned_file}.gz, {other_file}.gz")
    
    except subprocess.CalledProcessError as e:
        print(f"Error processing {fastq} with SortMeRNA: {e}")
    except Exception as e:
        print(f"Unexpected error processing {fastq}: {e}")
