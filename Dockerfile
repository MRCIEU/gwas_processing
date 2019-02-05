FROM continuumio/miniconda3

RUN git clone https://github.com/bulik/ldsc.git /ldsc

RUN conda env create -f /ldsc/environment.yml
RUN echo "source activate ldsc" > ~/.bashrc

RUN mkdir -p /ref \
	&& curl -SL https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2 \
	| tar -xvjC /ref

RUN curl -SL https://www.dropbox.com/s/yuo7htp80hizigy/ \
	| tar -xzvC /ref


RUN apt-get update && apt-get install -y make gcc zlib1g-dev libbz2-dev lzma-dev lzma liblzma-dev
RUN mkdir -p /home/bin
RUN mkdir -p /home/bin \
&& curl -SL https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 \
| tar -xvj \
&& bcftools-1.9/configure \
&& make -C bcftools-1.9 \
&& mv bcftools-1.9/bcftools /opt/conda/envs/ldsc/bin



RUN apt-get install -y unzip
RUN wget -O plink.zip http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20181202.zip && mkdir -p /plink && mv plink.zip /plink && cd /plink && unzip plink.zip && mv plink /home/bin

ENV PATH /home/bin:$PATH
ENV PATH /opt/conda/envs/ldsc/bin:$PATH


ADD clump.py /home/bin
ADD data.bcf /
ADD data.bcf.csi /

# ENTRYPOINT ["plink"]
