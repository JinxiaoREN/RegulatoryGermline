#!/bin/bash
#define parameters which are passed in.
TUMOR=$1
NORMAL=$2
SAMPLE=$3

#define the template.
cat  << EOF
tumor_bam = $TUMOR
normal_bam = $NORMAL
sample_name = $SAMPLE

reference_fasta = /mnt/data/input/Homo_sapiens_assembly19.fasta
reference_dict = /mnt/data/input/Homo_sapiens_assembly19.dict
assembly = GRCh37

dbsnp_db = /mnt/data/input/00-All.brief.pass.cosmic.vcf
strelka_config = /usr/local/somaticwrapper/params/strelka.WGS.ini
varscan_config = /usr/local/somaticwrapper/params/varscan.WGS.ini

# This creates VEP data annotated with gene names both as final output and for key intermediate files
output_vep = 1
annotate_intermediate = 1
EOF
