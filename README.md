# Clumping GWAS files and performing LDSC

## Clone repo & submodules
```
git clone --recurse-submodules https://github.com/MRCIEU/gwas_processing
cd gwas_processing
```

## Docker

To create the container:

```
docker build -t gwas_processing .
docker rm -f gwas_processing
docker run -d --name gwas_processing -v /path/to/data:/data gwas_processing 
```

To perform clumping:

```
docker run -v /path/to/data:/data gwas_processing clump.py --bcf /data/path/to/data.vcf.gz --out /data/path/to/clump.txt
```

To perform LD score regression:

```
docker run -v /path/to/data:/data gwas_processing ldsc.py --bcf /data/path/to/data.vcf.gz --out /data/path/to/ldsc.txt
```

## BC4

```
module load languages/anaconda3/2018.12
virtualenv venv
source ./venv/bin/activate
python clump.py -h
python ldsc.py -h
```

## Reference data

The `/data` directory linked in the docker run commands above should have a directory called `ref` containing LD score files and an LD reference panel e.g.

## Get LD score files

```
curl -SL https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2 | tar -xvjC /data/ref
cp ../gwas_processing/w_hm3.noMHC.snplist.gz /data/bgc/temp/snplist.gz
```

# Get LD reference panel
```
curl -SL https://www.dropbox.com/s/yuo7htp80hizigy/ | tar -xzvC /data/ref
```
