from pathlib import Path
import gzip
import csv
import numpy as np
import itertools as IT
import codecs
import pandas as pd
import os,sys
import subprocess

tsv_pth = subprocess.check_output('pwd -P', shell=True, universal_newlines=True).splitlines()[0]
command = "gsutil ls -l gs://dinglab/wliang_ENCODEcov/output/WGS/*.regions.bed.gz | grep -v objects | awk '($1!=28){print $3}'"
files=subprocess.check_output(command, shell=True, universal_newlines=True).splitlines()

key=sys.argv[1]
print(key)
passlist = pd.read_table("WGS/TCGA_WGS_gspath_WWL_Mar2018."+str(key)+".txt", header=None)
passlist = passlist[2].tolist()
importfiles = [x for x in files if str(x).split('/')[6].split('.')[0] in passlist]
vals = None
for num, filename in enumerate(importfiles, 1):
    downloadcommand = 'gsutil cp '+str(filename)+' .'
    print(downloadcommand)
    subprocess.run(downloadcommand, shell=True)
    downloadfile=tsv_pth+"/"+str(filename).split('/')[6]
    arr = np.genfromtxt(Path(downloadfile), dtype=None, delimiter='\t', usecols=(4), encoding="UTF-8")
    print(arr)
    if vals is None:
        vals = arr
    else:
        vals += arr
    rmcommand = 'rm '+str(downloadfile)
    subprocess.run(rmcommand, shell=True)
    print(rmcommand)
meanvals = vals / num

subprocess.run('gsutil cp '+importfiles[1]+' .', shell=True)
template=tsv_pth+"/"+importfiles[1].split('/')[6]
with gzip.open(Path(template), "rt") as fin, codecs.open(str(key)+'avgcov.txt', 'w', encoding='utf-8', errors='ignore') as fout:
    writer = csv.writer(fout, delimiter='\t', lineterminator='\n')
    for row, val in zip(csv.reader(fin, delimiter='\t'), meanvals):
        row[4] = val
        writer.writerow(row)
subprocess.run('rm '+template, shell=True)
