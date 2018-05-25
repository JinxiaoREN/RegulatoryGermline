####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName}
#1. bash generate_command.pipeline.sh ~/job/merge.todo.highpass.txt HighPass
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


while read lines; do
	id=$(echo $lines | awk -F " " '{print $3}')
	passvalue=$2
	ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
	yaml=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "./pipeline_comparison.hg19.yaml"; else print "./pipeline_comparison.37.yaml"}')
	dl_path="gs://dinglab/wliang_germlinevariantcalling/output/merge/${id}/${id}.merged.vcf"
	dv_path="gs://dinglab/wliang_deepvariant/${id}.${passvalue}.deepvariant.vcf"

	gcloud alpha genomics pipelines run --pipeline-file ${yaml} --inputs fafile=${ref},faifile=${ref}.fai,id=${id},passvalue=${passvalue},dlvcf=${dl_path},dpvcf=${dv_path} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/compare/${passvalue}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/compare/${passvalue}/
done < $1
