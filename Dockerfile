FROM continuumio/miniconda3

# Setup LDSC
COPY ldsc /ldsc
RUN conda env create -f /ldsc/environment.yml
RUN echo "source activate ldsc" > ~/.bashrc

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
ADD watcher.py /home/bin
RUN chmod 775 /home/bin/watcher.py

# Path
ENV PATH /opt/conda/envs/ldsc/bin:/home/bin:$PATH

# Keep container persistent
CMD tail -f /dev/null
