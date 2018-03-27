FROM biocontainers/biocontainers:latest

LABEL base.image="biocontainers:latest"
LABEL description="GermlineWrapper: Call germline variants from WXS/WGS BAMs"
LABEL tags="Genomics"

MAINTAINER Wen-Wei Liang <liang.w@wustl.edu>

USER root

RUN conda install pindel varscan

WORKDIR /data/

