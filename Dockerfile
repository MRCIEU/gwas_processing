FROM continuumio/miniconda3

RUN git clone git@github.com:bulik/ldsc.git /ldsc

ADD ldsc/environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml
RUN echo "source activate ldsc" > ~/.bashrc

RUN mkdir -p /ref \
	&& curl -SL https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2 \
	| tar -xvjC /ref

RUN curl -SL https://www.dropbox.com/s/yuo7htp80hizigy/ \
	| tar -xzvC /ref

RUN mkdir -p /home/bin \
&& curl -SL https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 \
| tar -xvj \
&& configure -C bcftools-1.9 \
&& make -C bcftools-1.9 \
&& mv bcftools-1.9 /home/bin

RUN wget -O plink.zip http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20181202.zip && mkdir -p /plink && mv plink.zip /plink && cd /plink && unzip plink.zip && mv plink /home/bin

ENV PATH /opt/conda/envs/ldsc/bin:$PATH

ADD clump.py /home/bin
