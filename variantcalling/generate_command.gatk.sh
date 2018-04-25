####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName} ${DiskSize(in gb)}
#1. bash generate_command.gatk.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 
#2. bash generate_command.gatk.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > cloud/gcloud_command.$2.gatk.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $14}')
	bai=$(echo $lines | awk -F " " '{print $15}')
	id=$(echo $lines | awk -F " " '{print $3}')
	passvalue=$2
	size=$(echo $lines | awk -F " " '{print ($10*1.1)/1000000000}' | awk '{printf "%.0f", $1}')
	ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
	dict=$(echo $ref | awk -F "." '{print $1}')
	yaml=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "../gatk_germline.hg19.yaml"; else print "../gatk_germline.37.yaml"}')

	echo "gcloud alpha genomics pipelines run --pipeline-file ${yaml} --inputs fafile=${ref},faifile=${ref}.fai,dictfile=${dict}.dict,bamfile=${bam},baifile=${bai},id=${id},chrlist=gs://dinglab/wliang_germlinevariantcalling/interval.list,pass=${passvalue} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/gatk/${id}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/gatk/${passvalue}/ --disk-size datadisk:${size}" >> cloud/gcloud_command.$2.gatk.sh
done < $1
