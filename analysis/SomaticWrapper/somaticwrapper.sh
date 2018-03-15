#!/bin/bash

cat $1 | read sample coverage tumor normal disksize
do
	gcloud alpha genomics pipelines run \
		--pipeline-file somaticwrapper.yaml \
		--logging gs://dinglab/wliang_somaticwrapper/logging \
		--inputs sample=$sample,fasta="gs://somaticwrapper_tcga/references/Homo_sapiens_assembly19.fasta",faidx="gs://somaticwrapper_tcga/references/Homo_sapiens_assembly19.fasta.fai",dict="gs://somaticwrapper_tcga/references/Homo_sapiens_assembly19.dict",config="gs://dinglab/wliang_somaticwrapper/scripts/gen_config.sh",dbsnp="gs://somaticwrapper_tcga/dbSNP/00-All.brief.pass.cosmic.vcf",tumor_bam=$tumor,tumor_bai=$tumor.bai,normal_bam=$normal,normal_bai=$normal.bai \
		--outputs output_path="gs://dinglab/wliang_somaticwrapper/output"
done
