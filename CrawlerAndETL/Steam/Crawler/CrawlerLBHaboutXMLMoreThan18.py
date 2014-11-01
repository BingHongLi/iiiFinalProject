# -*- coding: utf-8 -*-
'''
在headers進行掩飾 越過年齡限制的要求
再進行爬取網頁內容及價格
'''
#設定header的條件
headers1={'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
'Accept-Encoding':'gzip,deflate,sdch',
'Accept-Language':'zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4',
'Cache-Control':'no-cache',
'Connection':'keep-alive',
'Cookie':'Steam_Language=tchinese; browserid=662349100006364786; sessionid=MTEyODY2NTY3MA%3D%3D; recentapps=%7B%2242700%22%3A1411438705%2C%2210%22%3A1411132329%2C%22290730%22%3A1411132321%2C%22265463%22%3A1410955152%2C%22202970%22%3A1410949212%2C%228690%22%3A1410945879%2C%22272510%22%3A1410933653%2C%22288470%22%3A1410919275%2C%22206610%22%3A1410841240%2C%22211800%22%3A1410594210%7D; app_impressions=241930@undefined|227680@1_4_4__123|319250@1_4_4__123|321190@1_4_4__123|2029794@1_7_7_151_150_1|2029800@1_7_7_151_150_1|42700@1_7_7_151_150_1|7940@1_7_7_151_150_1|209650@1_7_7_151_150_1|2630@1_7_7_151_150_1|282620@1_7_7_151_150_1|263680@1_7_7_151_150_1|2034365@1_7_7_151_150_1|317660@1_7_7_151_150_1|274123@1_7_7_151_150_1|998@1_7_7_151_150_1|10090@1_7_7_151_150_1|202970@1_7_7_151_150_1|10180@1_7_7_151_150_1|115300@1_7_7_151_150_1|7940@1_7_7_151_150_1|42700@1_7_7_151_150_1|2630@1_7_7_151_150_1|209650@1_7_7_151_150_1|2620@1_7_7_151_150_1|2640@1_7_7_151_150_1|209160@1_7_7_151_150_1|6810@1_7_7_151_150_1; steamCC_140_115_236_15=TW; timezoneOffset=28800,0; __utma=128748750.965391176.1410256114.1411438691.1411643599.15; __utmb=128748750.0.10.1411643599; __utmc=128748750; __utmz=128748750.1411438691.14.11.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); birthtime=231750001; lastagecheckage=6-May-1977',
'Host':'store.steampowered.com',
'Pragma':'no-cache',
'Referer':'http://store.steampowered.com/agecheck/app/220050/',
'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36'}
success=0
fail=0
#設定網址格式
priceFormat='http://steamsales.rhekua.com/xml/sales/%s_%d.xml?curr=78'
#讀取名冊
moreThan18=open('./gameLink/limited_18.txt','r')
for i in moreThan18.readlines():
    #設定request取得的條件
	user_get=requests.get(i,headers=headers1)
    if(user_get.status_code!=404):
        temp=re.search('(\w+).(\d+)',i)
        filePath='./all18Content/'+temp.group(1)+'_'+temp.group(2)+'.txt'
        response_text=user_get.text.encode('utf8')
        lim18Content=open(filePath,'w')
        lim18Content.write(response_text)
        lim18Content.close()
        filePath='./all18Price/'+temp.group(1)+'_'+temp.group(2)+'.txt'
        user_get=requests.get(priceFormat%(temp.group(1),int(temp.group(2))))
        response_text=user_get.text.encode('utf8')
        lim18Price=open(filePath,'w')
        lim18Price.write(response_text)
        lim18Price.close()
        success+=1
    else:
        fail+=1
    print filePath
    print success,fail
moreThan18.close()