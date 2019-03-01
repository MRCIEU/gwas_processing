# Clumping GWAS files and performing LDSC


## Docker

To create the container:

```
docker build -t gwas_processing .
docker rm -f gwas_processing
docker run -d --name gwas_processing -v /path/to/data:/data gwas_processing 
```

To perform clumping:

```
docker exec gwas_processing clump.py --bcf /data/<id>/data.bcf --out /data/<id>/clump.txt
```

To perform LD score regression:

```
docker exec gwas_processing ldsc.py --bcf /data/<id>/data.bcf --out /data/<id>/ldsc.txt
```


## Reference data

# Get LD score files
curl -SL https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2 | tar -xvjC /data/bgc/temp
cp ../gwas_processing/w_hm3.noMHC.snplist.gz /data/bgc/temp/snplist.gz

# Get LD reference panel
curl -SL https://www.dropbox.com/s/yuo7htp80hizigy/ | tar -xzvC /data/bgc/temp


