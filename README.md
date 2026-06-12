# 2026-genome-project
Genome analysis workflow for the Ebola virus Mayinga reference genome.

## Methodology
This project follows a standard short-read mapping workflow:

1. Download the reference genome FASTA and annotation GFF files from NCBI.
2. Retrieve a limited subset of paired-end sequencing reads from the SRA archive.
3. Index the reference genome with BWA so the reads can be aligned efficiently.
4. Align the reads to the reference using BWA-MEM.
5. Convert the alignment to BAM format, sort it, and index the final file for downstream analysis.

## Required steps
Run the workflow in order with:

```bash
make download
make fastq
make index
make align
```

To run the complete pipeline in one command, use:

```bash
make workflow
```

The final output is a sorted and indexed BAM file stored in the bam directory.
