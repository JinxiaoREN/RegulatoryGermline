####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName} ${DiskSize(in gb)}
#1. bash generate_command.varscan.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 1500
#2. bash generate_command.varscan.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass 100
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > cloud/gcloud_command.$2.varscan.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $14}')
	bai=$(echo $lines | awk -F " " '{print $15}')
	id=$(echo $lines | awk -F " " '{print $3}')
	passvalue=$2
	size=$3

	echo "gcloud alpha genomics pipelines run --pipeline-file ../varscan_germline.yaml --inputs fafile=gs://dinglab/reference/GRCh37-lite.fa,faifile=gs://dinglab/reference/GRCh37-lite.fa.fai,bamfile=${bam},baifile=${bai},id=${id},chrlist=gs://dinglab/wliang_germlinevariantcalling/chrlist.txt,pass=${passvalue} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/varscan/${id}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/varscan/${passvalue}/ --disk-size datadisk:${size}" >> cloud/gcloud_command.$2.varscan.sh
done < $1
