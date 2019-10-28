#!/usr/bin/env python
# Usage: ldsc.py --bcf /path/to/<id>/data.bcf --out /path/to/<id>/ldsc.txt

import argparse
import math
import os

parser = argparse.ArgumentParser(description="Wrapper for LD score regression")
parser.add_argument("--bcf", required=True)
parser.add_argument("--ldsc_repo", default="./ldsc")
parser.add_argument("--ldsc_ref", default="/data/ref/eur_w_ld_chr/")
parser.add_argument("--out", required=True)
args = parser.parse_args()


cmd = " ".join(
    [
        "{0}/ldsc.py --h2 {1} --ref-ld-chr {2}",
        " --w-ld-chr {2} --out {3}",
    ]
).format(args.ldsc_repo, args.bcf, args.ldsc_ref, args.out)
os.system(cmd)
