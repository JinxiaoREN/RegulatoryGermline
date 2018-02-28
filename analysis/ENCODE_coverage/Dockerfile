FROM biocontainers/biocontainers:latest

LABEL base.image="biocontainers:latest"
LABEL description="Calculate coverage based on a provided BED file"
LABEL tags="Genomics"

MAINTAINER Wen-Wei Liang <wenwiliang@gmail.com>

USER root

RUN conda install bedtools samtools
RUN conda update bedtools samtools
