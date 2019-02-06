#!/usr/bin/env python

import argparse
import math
import os

parser = argparse.ArgumentParser(description = 'Extract and clump top hits')
parser.add_argument('--bcf', required=True)
parser.add_argument('--bcftools_binary', default='bcftools')
parser.add_argument('--plink_binary', default='plink')
parser.add_argument('--plink_ref', default='/ref/ld_files/data_maf0.01_rs')
parser.add_argument('--clump_pval', type=float, default=5e-8)
parser.add_argument('--clump_kb', type=int, default=10000)
parser.add_argument('--clump_r2', type=float, default=0.001)
parser.add_argument('--out', required=True)
args = parser.parse_args()

# args = parser.parse_args(['--bcf', 'data.bcf', '--plink_ref', '../../vcf-reference-datasets/1000g_filtered/data_maf0.01_rs', '--out', 'temp'])

cmd = "{0} view -i 'L10PVAL>{1}' {2} | {0} query -f'%ID %L10PVAL\n' | awk 'BEGIN {{print \"SNP P\"}}; {{print $1, 10^-$2}}' | awk '!seen[$1]++' > {3}.tophits".format(args.bcftools_binary, -math.log10(args.clump_pval), args.bcf, args.out)
os.system(cmd)

cmd = "{0} --bfile {1} --clump {2} --clump-kb {3} --clump-r2 {4} --clump-p1 {5} --clump-p2 {5} --out {2}".format(args.plink_binary, args.plink_ref, args.out+".tophits", args.clump_kb, args.clump_r2, args.clump_pval)
os.system(cmd)

if os.path.isfile(args.out+'.tophits.clumped'):
	n=0
	with open(args.out+'.tophits.clumped', 'rt') as fp, open(args.out, 'wt') as fo:
		o=next(fp)
		for line in fp:
			line = line.strip("\n").split()
			if len(line) >= 3:
				n+=1
				fo.write("{0}\n".format(line[2]))
	print("Found "+str(n)+" hits")
else:
	os.system('touch' + args.out)
	print("No hits")

[os.remove(args.out + x) for x in ['.tophits.clumped', '.tophits.log', '.tophits.nosex', '.tophits'] if os.path.isfile(args.out + x)]
