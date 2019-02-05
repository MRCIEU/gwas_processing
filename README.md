# Clumping GWAS files and performing LDSC


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
