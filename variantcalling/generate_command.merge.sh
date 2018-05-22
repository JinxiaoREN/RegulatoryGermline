####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh ${List_of_BAMs} ${JobName} ${DiskSize(in gb)}
#1. bash generate_command.gatk.sh TCGA_WGS_gspath_WWL_Mar2018.HighPass.txt HighPass 
#2. bash generate_command.gatk.sh TCGA_WGS_gspath_WWL_Mar2018.LowPass.txt LowPass
#Author: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > ~/job/cloud/gcloud_command.$2.merge.sh
while read lines; do
	id=$(echo $lines | awk -F " " '{print $3}')
	passvalue=$2
	size=$(echo $lines | awk -F " " '{print ($10*1.1)/1000000000}' | awk '{printf "%.0f", $1}' | awk '{if ($1 <=50) print "50"; else print $1}')
	ref=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "gs://dinglab/reference/Homo_sapiens_assembly19.fasta"; else print "gs://dinglab/reference/GRCh37-lite.fa"}')
	yaml=$(echo $lines | awk -F " " '{if ($8=="HG19_Broad_variant") print "~/RegulatoryGermline/variantcalling/merge_germline.hg19.yaml"; else print "~/RegulatoryGermline/variantcalling/merge_germline.37.yaml"}')
	dict=$(echo $ref | awk -F "." '{print $1}')
	gatk_snp_path="gs://dinglab/wliang_germlinevariantcalling/output/gatk/${id}/${id}.${passvalue}.gatk.snp.vcf"
	gatk_indel_path="gs://dinglab/wliang_germlinevariantcalling/output/gatk/${id}/${id}.${passvalue}.gatk.indel.vcf"
	varscan_snp_path="gs://dinglab/wliang_germlinevariantcalling/output/varscan/${id}/${id}.${passvalue}.varscan.raw.snp.vcf"
	varscan_indel_path="gs://dinglab/wliang_germlinevariantcalling/output/varscan/${id}/${id}.${passvalue}.varscan.raw.indel.vcf"
	pindel_path="gs://dinglab/wliang_germlinevariantcalling/output/pindel/${passvalue}/${id}/pindel.out.raw.CvgVafStrand_pass.Homopolymer_pass.vcf"

	echo "gcloud alpha genomics pipelines run --pipeline-file ${yaml} --inputs fafile=${ref},faifile=${ref}.fai,dictfile=${dict}.dict,id=${id},passvalue=${passvalue},gsnp=${gatk_snp_path},gindel=${gatk_indel_path},vsnp=${varscan_snp_path},vindel=${varscan_indel_path},pindel=${pindel_path} --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/merge/${id}/ --logging gs://dinglab/wliang_germlinevariantcalling/logging/merge/${passvalue}/ --disk-size datadisk:${size}" >> ~/job/cloud/gcloud_command.$2.merge.sh
done < $1
