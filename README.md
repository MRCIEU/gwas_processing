# Clumping GWAS files and performing LDSC

## Setup

```
git clone https://github.com/bulik/ldsc.git
cd ldsc
mkdir ref
cd ref
wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
bunzip2 eur_w_ld_chr.tar.bz2
tar xvf eur_w_ld_chr.tar
zcat eur_w_ld_chr/*gz | awk '{ print $1"\t"$3 }' | grep -v "CHR" > vars.txt
wget -O ld_files.tgz https://www.dropbox.com/s/yuo7htp80hizigy/ld_files.tgz?dl=0
tar xzvf ld_files.tgz 
rm ld_files.tgz
rm eur_w_ld_chr.tar
rm ld_files/data_maf0.01.*
conda env create -f ldsc/environment.yml
source activate ldsc
```

To run clumping

```{r}
./clump.py --bcf <BCF> --plink_ref ref/ld_files/data_maf0.01_rs --out <OUTPUT>
```

To run LDSC

```{r}
bcftools query -R ref/vars.txt -f'%ID %EFFECT %SE %N\n' <BCF> | awk 'BEGIN {print "SNP Z N"}; { print $1, $2/$3, $4 }' > <BCF>.temp

ldsc/ldsc.py --h2 <BCF>.temp --ref-ld-chr ../ref/eur_w_ld_chr/ --w-ld-chr ../ref/eur_w_ld_chr/ --out <OUT>
```

## Docker

To create the container:

```
docker build -t gwas_processing .
docker rm -f gwas_processing
docker run -d --name gwas_processing -v /home/gh13047/gwas_processing:/data gwas_processing 
```

To perform clumping:

```
docker exec gwas_processing clump.py --bcf /data/data.bcf --out /data/clump.txt
```

To perform LD score regression:

```
docker exec gwas_processing ldsc.py --bcf /data/data.bcf --out /data/ldsc.txt
```


