#!/usr/bin/python
# -*- coding: utf-8 -*-
#植入套件
import requests
from bs4 import BeautifulSoup
from math import ceil
import HTMLParser
import urlparse
import time 
import re
#下載美國檔案先跳板
http_proxy = {'http' : '216.189.0.235:3127'}
http_proxy2 = {'http' : '199.200.120.140:3127'}
http_proxy3 = {'http' : '198.52.217.44:3127'}
#紀錄成功下載的數量與失敗的數量
success=0
fail=0
#xml的格式
dataFormat='http://steamsales.rhekua.com/xml/sales/%s_%d.xml?curr=78'
#開啟名冊檔案
openLink=open('./gameLink/limited_area.txt','r')
for i in openLink.readlines():
    rs=requests.session()
    try:
        response=rs.get(i,proxies=http_proxy)
    except:
        try:
            response=rs.get(i,proxies=http_proxy2)
        except:
            response=rs.get(i,proxies=http_proxy3)
    #若網站的status_code為200(正常)，就作下列事項
    if(response.status_code==200):
        #擷取名冊上的連結的產品類別及編號
        tempFileName=re.search('(\w+).(\d+)',i)
        print tempFileName.group(1)+'_'+tempFileName.group(2)+'.txt'
        #設定網頁內容的儲存路徑與檔案名
        siteFileName='./allContentUSA/'+tempFileName.group(1)+'_'+tempFileName.group(2)+'.txt'
        #開啟檔案，準備寫入網頁內容
        siteContent=open(siteFileName,'w')
        siteContent.write(response.text.encode('utf8'))
        siteContent.close()
        #重設網頁session，準備抓xml價格的網頁內容
        rs=requests.session()
        #抓取網頁
        response=rs.get(dataFormat%(tempFileName.group(1),int(tempFileName.group(2))))
        #設定檔案儲存路徑與檔案名
        priceFileName='./allPriceUSA/'+tempFileName.group(1)+'_'+tempFileName.group(2)+'.txt'
        #開啟檔案，準備寫入xml價格內容
        priceContent=open(priceFileName,'w')
        priceContent.write(response.text.encode('utf8'))
        priceContent.close()
        success+=1
    else:
        fail+=1
    print success,fail
openLink.close()