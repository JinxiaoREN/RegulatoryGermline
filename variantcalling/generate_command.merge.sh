####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName} ${DiskSize(in gb)}
#1. bash generate_command.gatk.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 
#2. bash generate_command.gatk.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > cloud/gcloud_command.$2.merge.sh
while read lines; do
	id=$(echo $lines | awk -F " " '{print $3}')
	passvalue=$2
	size=$(echo $lines | awk -F " " '{print ($10*1.1)/1000000000}' | awk '{printf "%.0f", $1}')
	dict=$(echo $ref | awk -F "." '{print $1}')
	ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
	yaml=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "../merge_germline.hg19.yaml"; else print "../merge_germline.37.yaml"}')
	gatk_snp_path="gs://dinglab/wliang_germlinevariantcalling/output/gatk/${id}/${id}.${passvalue}.gatk.snv.vcf"
	gatk_indel_path="gs://dinglab/wliang_germlinevariantcalling/output/gatk/${id}/${id}.${passvalue}.gatk.indel.vcf"
	varscan_snp_path="gs://dinglab/wliang_germlinevariantcalling/output/varscan/${id}/${id}.${passvalue}.varscan.raw.snv.vcf"
	varscan_indel_path="gs://dinglab/wliang_germlinevariantcalling/output/varscan/${id}/${id}.${passvalue}.varscan.raw.snv.vcf"
	pindel_path="gs://dinglab/wliang_germlinevariantcalling/output/pindel/${id}/pindel.out.raw.CvgVafStrand_pass.vcf"

	echo "gcloud alpha genomics pipelines run --pipeline-file ${yaml} --inputs fafile=${ref},faifile=${ref}.fai,id=${id},pass=${passvalue},gsnp=${gatk_snp_path},gindel=${gatk_indel_path},vsnp=${varscan_snp_path},vindel=${varscan_indel_path},pinde=${pindel_path} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/merge/${id}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/merge/${passvalue}/ --disk-size datadisk:${size}" >> cloud/gcloud_command.$2.merge.sh
done < $1
