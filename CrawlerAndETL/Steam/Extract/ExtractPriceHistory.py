import os
from bs4 import BeautifulSoup
import re

for root, dirs, files in os.walk("E://Dropbox/iiiProject/data/priceHistory/"):
    #print root
    for f in files:
        inputFile='E://Dropbox/iiiProject/data/priceHistory/'+f
        of=open(inputFile,'r')
        temp=of.readlines()
        of.close()
        tcontent=''
        for raw in temp:
            tcontent+=raw
        content=BeautifulSoup(tcontent)
        target=content.findAll('set')
        m=re.match('(\w+)',f)
        fileName='E://Dropbox/iiiProject/data/ExtractPriceHistory/'+m.group(1)+'.csv'
        print fileName
        test=open(fileName,'w')
        for raw in target:
            test.write(raw['name']+','+raw['value']+'\n')
        test.close()