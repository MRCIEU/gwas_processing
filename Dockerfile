FROM continuumio/miniconda3

# Setup LDSC
RUN git clone https://github.com/explodecomputer/ldsc.git /ldsc
RUN conda env create -f /ldsc/environment.yml
RUN echo "source activate ldsc" > ~/.bashrc


# Get reference data
RUN mkdir -p /ref \
	&& curl -SL https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2 \
	| tar -xvjC /ref
# RUN zcat ref/eur_w_ld_chr/*gz | awk '{ print $1"\t"$3 }' | grep -v "CHR" > /ref/vars.txt
ADD w_hm3.noMHC.snplist.gz /ref/snplist.gz

RUN curl -SL https://www.dropbox.com/s/yuo7htp80hizigy/ \
	| tar -xzvC /ref

# Compile bcftools because conda version has dependency problem
RUN apt-get update && apt-get install -y make gcc zlib1g-dev libbz2-dev lzma-dev lzma liblzma-dev
RUN curl -SL https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 \
| tar -xvj \
&& bcftools-1.9/configure \
&& make -C bcftools-1.9 \
&& mv bcftools-1.9/bcftools /opt/conda/envs/ldsc/bin


RUN mkdir -p /home/bin

# Get clumping reference
RUN apt-get install -y unzip
RUN wget -O plink.zip http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20181202.zip && mkdir -p /plink && mv plink.zip /plink && cd /plink && unzip plink.zip && mv plink /home/bin


ADD clump.py /home/bin
ADD ldsc.py /home/bin


# Add watcher
RUN wget -O /home/bin/watcher.py https://raw.githubusercontent.com/MRCIEU/bgc-upload-orchestrator/master/watcher.py?token=AB1fTMa-e8fsZrhTfgrH2VEnYtpvjtCBks5cgZIdwA%3D%3D && chmod 775 /home/bin/watcher.py

# Path
ENV PATH /opt/conda/envs/ldsc/bin:/home/bin:$PATH

# Keep container persistent
CMD tail -f /dev/null
