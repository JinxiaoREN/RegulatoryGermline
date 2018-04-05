#
gcloud alpha genomics pipelines run --pipeline-file gatk_germline.yaml --inputs fafile=gs://dinglab/reference/GRCh37-lite.fa,faifile=gs://dinglab/reference/GRCh37-lite.fa.fai,dictfile=gs://dinglab/reference/GRCh37-lite.dict,bamfile=gs://5aa919de-0aa0-43ec-9ec3-288481102b6d/tcga/BLCA/DNA/WGS/HMS-RK/ILLUMINA/TCGA-BL-A13J-11A-13D-A10R_120920_SN1222_0151_BD1D5CACXX_s_2_rg.sorted.bam,baifile=gs://5aa919de-0aa0-43ec-9ec3-288481102b6d/tcga/BLCA/DNA/WGS/HMS-RK/ILLUMINA/TCGA-BL-A13J-11A-13D-A10R_120920_SN1222_0151_BD1D5CACXX_s_2_rg.sorted.bam.bai,id=TCGA-BL-A13J-11A-13D-A10R-02,chrlist=gs://dinglab/wliang_germlinevariantcalling/interval.list --outputs outputPath=gs://dinglab/wliang_germlinevariantcalling/output/gatk/ --logging gs://dinglab/wliang_germlinevariantcalling/logging --disk-size datadisk:100