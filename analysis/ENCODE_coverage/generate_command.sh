echo "#" > gcloud_command.$2.sh
while read lines; do
	bam=$(echo $lines | awk -F " " '{print $14}')
	bai=$(echo $lines | awk -F " " '{print $15}')
	id=$(echo $lines | awk -F " " '{print $3}')

	echo "gcloud alpha genomics pipelines run --pipeline-file site_coverage.yaml --inputs bedfile=gs://dinglab/wliang_ENCODEcov/reference/final.uniq.ENCODE.sorted.bed,bamfile=${bam},baifile=${bai},id=${id} --outputs outputPath=gs://dinglab/wliang_ENCODEcov/output --logging gs://dinglab/wliang_ENCODEcov/logging --disk-size datadisk:1500" >> gcloud_command.$2.sh
done < $1
