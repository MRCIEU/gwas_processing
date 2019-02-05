#!/usr/bin/env python

import argparse
import math
import os

parser = argparse.ArgumentParser(description = 'Wrapper for LD score regression')
parser.add_argument('--bcf', required=True)
parser.add_argument('--bcftools_binary', default='bcftools')
parser.add_argument('--ldsc_repo', default='/ldsc')
parser.add_argument('--ldsc_ref', default='/ref/eur_w_ld_chr/')
parser.add_argument('--snplist', default='/ref/vars.txt')
parser.add_argument('--out', required=True)
args = parser.parse_args()

cmd = "{0} query -R {1} -f'%ID %EFFECT %SE %N\n' {2} | awk 'BEGIN {{print \"SNP Z N\"}}; {{ print $1, $2/$3, $4 }}' > {3}.temp".format(args.bcftools_binary, args.snplist, args.bcf, args.out)
os.system(cmd)

cmd = "{0}/ldsc.py --h2 {1}.temp --ref-ld-chr {2} --w-ld-chr {2} --out {1}".format(args.ldsc_repo, args.out, args.ldsc_ref)
os.system(cmd)

[os.remove(args.out + x) for x in ['.temp'] if os.path.isfile(args.out + x)]
