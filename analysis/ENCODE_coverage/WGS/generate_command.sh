####
#Aim: Generate google cloud command
#Usage:
#1. bash generate_command.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 1500
#2. bash generate_command.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass 100
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > gcloud_command.$2.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $14}')
	bai=$(echo $lines | awk -F " " '{print $15}')
	id=$(echo $lines | awk -F " " '{print $3}')
	size=$3

	echo "gcloud alpha genomics pipelines run --pipeline-file site_coverage.yaml --inputs bedfile=gs://dinglab/wliang_ENCODEcov/reference/final.uniq.ENCODE.sorted.bed,bamfile=${bam},baifile=${bai},id=${id} --outputs outputPath=gs://dinglab/wliang_ENCODEcov/output/WGS --logging gs://dinglab/wliang_ENCODEcov/logging --disk-size datadisk:${size}" >> gcloud_command.$2.sh
done < $1
