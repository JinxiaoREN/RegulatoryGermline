FROM biocontainers/biocontainers:latest

LABEL base.image="biocontainers:latest"
LABEL description="Call germline variants from WXS/WGS BAMs"
LABEL tags="Genomics"

MAINTAINER Wen-Wei Liang <liang.w@wustl.edu>

USER root

RUN conda install python=3.6 snakemake pindel varscan samtools gatk4
#WORKDIR /home/biodocker
#RUN git clone https://github.com/ding-lab/germlinewrapper.git


