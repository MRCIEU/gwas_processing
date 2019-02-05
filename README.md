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
