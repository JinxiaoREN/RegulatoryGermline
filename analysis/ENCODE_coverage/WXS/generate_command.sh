####
#Aim: Generate google cloud command
#Usage: bash generate_command.sh pca_table.20171019.wclin.tsv WXS
#Authour: Wen-Wen Liang @ Wash U (liang.w@wustl.edu)
####


echo "#" > gcloud_command.$2.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $5}')
	bai=$(echo $lines | awk -F " " '{print $5}').bai
	id=$(echo $lines | awk -F " " '{print $2}')
	size=$(echo $lines | awk -F " " '{print ($6*1.1)/1000000000}' | awk '{printf "%.0f", $1}')

	echo "gcloud alpha genomics pipelines run --pipeline-file site_coverage.yaml --inputs bedfile=gs://dinglab/wliang_ENCODEcov/reference/final.uniq.ENCODE.mirna.sorted.bed,bamfile=${bam},baifile=${bai},id=${id} --outputs outputPath=gs://dinglab/wliang_ENCODEcov/output/WXS/${id} --logging gs://dinglab/wliang_ENCODEcov/logging --disk-size datadisk:${size}"  >> gcloud_command.$2.sh
done < $1
