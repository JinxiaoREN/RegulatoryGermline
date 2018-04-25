####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName} ${DiskSize(in gb)}
#1. bash generate_command.pindel.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 1500
#2. bash generate_command.pindel.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass 100
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > cloud/gcloud_command.$2.pindel.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $14}')
	bai=$(echo $lines | awk -F " " '{print $15}')
	id=$(echo $lines | awk -F " " '{print $3}')
	size=$(echo $lines | awk -F " " '{print ($10*1.1)/1000000000}' | awk '{printf "%.0f", $1}')
	ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
	yaml=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "../pindel_germline.hg19.yaml"; else print "../pindel_germline.37.yaml"}')
	config=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/wliang_germlinevariantcalling/pindel.input.hg19.txt"; else print "gs://dinglab/wliang_germlinevariantcalling/pindel.input.37.txt"}')
	passvalue=$2

	echo "gcloud alpha genomics pipelines run --pipeline-file ${yaml} --inputs fafile=${ref},faifile=${ref}.fai,bamfile=${bam},baifile=${bai},id=${id},chrlist=gs://dinglab/wliang_germlinevariantcalling/chrlist.txt,centromerelist=gs://dinglab/wliang_germlinevariantcalling/pindel-centromere-exclude.bed,inputfile=${config} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/pindel/${id}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/pindel/${passvalue}/ --disk-size datadisk:${size}" >> cloud/gcloud_command.$2.pindel.sh
done < $1
