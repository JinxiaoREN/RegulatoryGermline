####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName} ${DiskSize(in gb)}
#1. bash generate_command.varscan.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 1500
#2. bash generate_command.varscan.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass 100
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > ~/job/cloud/gcloud_command.$2.varscan.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $14}')
	bai=$(echo $lines | awk -F " " '{print $15}')
	id=$(echo $lines | awk -F " " '{print $3}')
	passvalue=$2
	ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
	yaml=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "~/RegulatoryGermline/variantcalling/varscan_germline.hg19.yaml"; else print "~/RegulatoryGermline/variantcalling/varscan_germline.37.yaml"}')
	size=$(echo $lines | awk -F " " '{print ($10*1.1)/1000000000}' | awk '{printf "%.0f", $1}')

	echo "gcloud alpha genomics pipelines run --pipeline-file ${yaml} --inputs fafile=${ref},faifile=${ref}.fai,bamfile=${bam},baifile=${bai},id=${id},chrlist=gs://dinglab/wliang_germlinevariantcalling/chrlist.txt,pass=${passvalue} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/varscan/${id}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/varscan/${passvalue}/ --disk-size datadisk:${size}" >> ~/job/cloud/gcloud_command.$2.varscan.sh
done < $1
