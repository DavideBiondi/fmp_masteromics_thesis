from pyrpipe import sra, qc
import os
import subprocess

# List of FASTQ files
fastq_files = [
    'SRR7052564.fastq.gz',
    'SRR7052565.fastq.gz',
    'SRR7052566.fastq.gz',
    'SRR7052567.fastq.gz',
    'SRR7052568.fastq.gz',
    'SRR7052569.fastq.gz'
]

# Define Trim Galore options
tg_options = {
    "--fastqc": "",  # This enables FastQC after trimming
    "--cores": "3"   # Number of cores to use
}

# Initialize the Trimgalore object with the specified options
trimgalore = qc.Trimgalore(**tg_options)

# Specify the output directory for the quality-controlled files
output_dir = 'qc_output'

# Create the output directory if it does not exist
os.makedirs(output_dir, exist_ok=True)

# Performing quality control on each FASTQ file
for fastq in fastq_files:
    try:
        sra_obj = sra.SRA(fastq=fastq)
        qc_files = sra_obj.trim(trimgalore, out_dir=output_dir)
        
        # Debugging statement to check the returned value
        print(f"Trimmed files for {fastq}: {qc_files}")
        
        if not qc_files or any(f == "" for f in qc_files):
            raise OSError(f"perform_qc failed for: {fastq}")
        
        # Compress each quality-controlled file if not already compressed
        for qc_file in qc_files:
            if not qc_file.endswith('.gz'):
                subprocess.run(['gzip', qc_file])
                print(f"Compressed {qc_file} to {qc_file}.gz")
        
        print(f"Quality controlled files for {fastq}: {qc_files}")
    except Exception as e:
        print(f"Error processing {fastq}: {e}")
