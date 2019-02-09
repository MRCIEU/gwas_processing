#!/usr/bin/env python

import argparse
import math
import os

parser = argparse.ArgumentParser(description = 'Wrapper for LD score regression')
parser.add_argument('--bcf', required=True)
parser.add_argument('--ldsc_repo', default='/ldsc')
parser.add_argument('--ldsc_ref', default='/ref/eur_w_ld_chr/')
parser.add_argument('--snplist', default='/ref/vars.txt')
parser.add_argument('--out', required=True)
args = parser.parse_args()


cmd = "{0}/ldsc.py --h2 {1} --snplist {2} --ref-ld-chr {3} --w-ld-chr {3} --out {4}".format(args.ldsc_repo, args.bcf, args.snplist, args.ldsc_ref, args.out)
os.system(cmd)

