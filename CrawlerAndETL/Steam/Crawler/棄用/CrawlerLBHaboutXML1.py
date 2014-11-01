#初版
#設定套件
import requests
from bs4 import BeautifulSoup
import HTMLParser
import urlparse
import time
import re
from math import ceil

'''
抓取XML及content，如此一來可確立有XML的檔案必有content 
並且記錄成功與失敗的連結數

'''
#設定記錄數值
success=0
fail=0
#開啟名冊檔案
f=open('test2.txt')
for i in f.readlines():
    #設定正規表示法抓取種類及標號
	category=re.search('(\w+):(...)(\w+).(\w+).(\w+).(\w+).(\w+)',i)
    rs=requests.session()
	'''
	若連結為video，必須先行轉成app或sub，
	在此按大數法則，先將video都轉址為app，再進行判定。
	'''
    if(category.group(6)=='video'):
        dataFormat='http://steamsales.rhekua.com/xml/sales/app_%d.xml?curr=78'
        response=rs.get(dataFormat%(int(category.group(7))))
        if(response.status_code!=404):
            tempFile='try/'+'app_'+category.group(7)+'.txt'
            content='content/'+'app_'+category.group(7)+'.txt'
            t=open(tempFile,'w')
            t.write(response.text)
            t.close()
            t=open(content,'w')
            temp2=rs.get(i).text.encode('utf8')
            t.write(temp2)
            t.close()
            success=success+1
        else:
            fail=fail+1
    else:
        dataFormat='http://steamsales.rhekua.com/xml/sales/%s_%d.xml?curr=78'
        response=rs.get(dataFormat%(category.group(6),int(category.group(7))))
        if(response.status_code!=404):
            tempFile='try/'+category.group(6)+'_'+category.group(7)+'.txt'
            content='content/'+category.group(6)+'_'+category.group(7)+'.txt'
            t=open(tempFile,'w')
            t.write(response.text)
            t.close()
            t=open(content,'w')
            temp2=rs.get(i).text.encode('utf8')
            t.write(temp2)
            t.close()
            success=success+1
        else:
            fail=fail+1    
    print tempFile
    print content
    print response.status_code
    print success,fail
f.close()
