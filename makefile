FASTA_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

# The URL to the annotation.
GFF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.gff.gz

# The name of the genome.
GENOME_NAME=ebola-mayinga

# The path to the genome FASTA file.
GENOME_FASTA=refs/${GENOME_NAME}.fasta

# The path to the genome GFF file.
GENOME_GFF=refs/${GENOME_NAME}.gff

# The SRR ID of the sample.
SRR=SRR1553425

# The name of the alignment BAM file
BAM=bam/${SRR}.bam

# The number of reads to download.
LIMIT=100000

# The path to the read files
R1_READS=reads/${SRR}_1.fastq
R2_READS=reads/${SRR}_2.fastq

# ----- No CHANGES BELOW THIS LINE

help:
	@echo "Available targets:"
	@echo "  make download   Download the reference genome FASTA and GFF files"
	@echo "  make fastq      Download and split reads from SRA"
	@echo "  make index      Index the reference genome for BWA"
	@echo "  make align      Align reads to the reference and produce a sorted BAM"
	@echo "  make workflow   Run the complete analysis workflow"
	@echo "  make clean      Remove generated data directories"

# Download and unzip the reference FASTA and GFF files.
download:
	mkdir -p refs
	wget -O ${GENOME_FASTA}.gz ${FASTA_URL}
	wget -O ${GENOME_GFF}.gz ${GFF_URL}
	gunzip -f ${GENOME_FASTA}.gz
	gunzip -f ${GENOME_GFF}.gz

# Download the reads from SRA and limit to LIMIT reads.
fastq:
	mkdir -p reads
	fastq-dump -X ${LIMIT} --outdir reads --split-files ${SRR}

# Index the genome for BWA.
index:
	bwa index ${GENOME_FASTA}

# Align the reads to the genome and build a sorted, indexed BAM file.
align: download fastq index
	mkdir -p bam
	bwa mem -t 4 ${GENOME_FASTA} ${R1_READS} ${R2_READS} | samtools view -bS - > ${BAM}
	samtools sort ${BAM} -o ${BAM}.sorted.bam
	samtools index ${BAM}.sorted.bam

# Run the entire workflow from data download to alignment.
workflow: align

# Remove generated data.
clean:
	rm -rf refs reads bam

.PHONY: help download fastq index align workflow clean




