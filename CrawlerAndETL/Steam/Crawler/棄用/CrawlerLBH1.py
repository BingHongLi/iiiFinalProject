#初版
#設定套件
import requests
from bs4 import BeautifulSoup
import HTMLParser
import urlparse
import time
import re
from math import ceil

rs=requests.session()
#分頁格式
pageFormat='http://store.steampowered.com/search/results?category1=998&genre=Action&sort_order=ASC&page=%d&snr=1_7_7_230_7'

#為取得總筆數進而計算頁面，先跑一次。
getHTML=rs.get(pageFormat%(1))
transformHTMLEncode=getHTML.text.encode('utf8')
soup=BeautifulSoup(transformHTMLEncode)
#抓出顯示頁碼的地方，並用正規表示法找出總筆數
m=re.search(r'(\d+) - (\d+) of (\d+)',soup.find('div',{'class':'search_pagination_left'}).text.strip())
pageNumber=int(ceil(float(int(m.group(3)))/25))

#開啟檔案test2的串流，預計將所有連結寫入檔案內
f=open('test2.txt','w')
#開始寫入連結
for page in range(1,pageNumber+1):
    #取得網頁
    getHTML=rs.get(pageFormat%(page))
    #轉型為utf8
    transformHTMLEncode=getHTML.text.encode('utf8')
    #剖析網頁
    soup=BeautifulSoup(transformHTMLEncode)
    #找出Link位置
    findTarget=soup.findAll('a',{'href':True,'class':True})
    #將Link寫入檔案內
    for row in findTarget:
        print row['href']
        f.write(row['href']+'\r\n')
#關閉檔案串流
f.close()