#!/bin/bash
set -euo pipefail
# Set common settings.
PROJECT_ID=isb-cgc-06-0004
OUTPUT_BUCKET=gs://dinglab/wliang_deepvariant
# Model for calling whole genome sequencing data.
MODEL=gs://deepvariant/models/DeepVariant/0.6.0/DeepVariant-inception_v3-0.6.0+cl-191676894.data-wgs_standard
IMAGE_VERSION=0.6.1
DOCKER_IMAGE=gcr.io/deepvariant-docker/deepvariant:"${IMAGE_VERSION}"
DOCKER_IMAGE_GPU=gcr.io/deepvariant-docker/deepvariant_gpu:"${IMAGE_VERSION}"

while read lines; do
id=$(echo ${lines} | awk -F " " '{print $3}')
pass=$(echo ${lines} | awk -F " " '{print $18}')
bam=$(echo ${lines} | awk -F " " '{print $14}')
ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
size=$(echo $lines | awk -F " " '{print ($10*1.2)/1000000000}' | awk -F " " '{ if ($1 >=200) printf "%.0f", $1; else print "200"}')
STAGING_FOLDER_NAME=${id}.${pass}.stage
OUTPUT_FILE_NAME=${id}.${pass}.deepvariant.vcf

# Run the pipeline.
gcloud alpha genomics pipelines run \
--project "${PROJECT_ID}" \
--pipeline-file deepvariant_pipeline.yaml \
--logging "${OUTPUT_BUCKET}"/runner_logs \
--zones us-west1-b \
--inputs `echo \
PROJECT_ID="${PROJECT_ID}", \
OUTPUT_BUCKET="${OUTPUT_BUCKET}", \
MODEL="${MODEL}", \
DOCKER_IMAGE="${DOCKER_IMAGE}", \
DOCKER_IMAGE_GPU="${DOCKER_IMAGE_GPU}", \
STAGING_FOLDER_NAME="${STAGING_FOLDER_NAME}", \
OUTPUT_FILE_NAME="${OUTPUT_FILE_NAME}", \
BAM="${bam}", \
REF="${ref}", \
SIZE="${size}" \
| tr -d '[:space:]'`

done < test.txt
