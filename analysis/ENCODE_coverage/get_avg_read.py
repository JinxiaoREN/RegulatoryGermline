from pathlib import Path
import gzip
from statistics import mean
import csv
import numpy as np
import itertools as IT
import codecs
import pandas as pd
import os,sys
import subprocess

tsv_pth = '/home/wliang/WGSresult/'
p = Path(tsv_pth)

def get_avg(key):
    filelist = pd.read_table("WGS/TCGA_WGS_gspath_WWL_Mar2018."+str(key)+".txt", header=None)
    filelist = filelist[2].tolist()
    files = [x for x in sorted(p.glob('*.regions.bed.gz')) if str(x).split('/')[4].split('.')[0] in filelist][:2]
    vals = None
    for num, filename in enumerate(files, 1):
        print (filename, type(filename))
        arr = np.genfromtxt(filename, dtype=None, delimiter='\t', usecols=(4), encoding="UTF-8")
        print(arr)
        if vals is None:
            vals = arr
        else:
            vals += arr
    meanvals = vals/num

    with gzip.open(files[0], "rt") as fin, codecs.open(str(key)+'avgcov.txt', 'w', encoding='utf-8', errors='ignore') as fout:
        writer = csv.writer(fout, delimiter='\t', lineterminator='\n')
        for row, val in zip(csv.reader(fin, delimiter='\t'), meanvals):
            row[4] = val
            writer.writerow(row)

highpass=get_avg("HighPass")
#lowpass=get_avg("LowPass")

