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
command = "gsutil ls -l gs://dinglab/wliang_ENCODEcov/output/WXS/*.regions.bed.gz | grep -v objects | awk '($1!=28){print $3}'"
files=subprocess.check_output(command, shell=True, universal_newlines=True).splitlines()

vals = None
for num, filename in enumerate(files, 1):
    downloadcommand = 'gsutil cp '+str(filename)+' '+tsv_pth
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

subprocess.run('gsutil cp '+files[1]+' '+tsv_pth, shell=True)
template=tsv_pth+"/"+files[1].split('/')[6]
with gzip.open(Path(template), "rt") as fin, codecs.open('TCGA.WXS.avgcov.txt', 'w', encoding='utf-8', errors='ignore') as fout:
    writer = csv.writer(fout, delimiter='\t', lineterminator='\n')
    for row, val in zip(csv.reader(fin, delimiter='\t'), meanvals):
        row[4] = val
        writer.writerow(row)
subprocess.run('rm '+template, shell=True)
print("All the calculation has been done")
