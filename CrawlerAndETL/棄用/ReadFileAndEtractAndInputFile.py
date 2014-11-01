#!/usr/bin/python
# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import HTMLParser
import json

ID='app_10'

#遊戲基本資料json檔
gameProfile={ID:{'gameName':'','introduce':'','releaseDate':'',
                 'score':'','developer':'','publisher':'',
                 'systemRequire':''}}



#讀檔案至暫存區，等待解析
f=open('app_10.txt','r')
t=f.readlines()
f.close()
x=""
for i in t:
    x+=i
#print x
content=BeautifulSoup(x)

#遊戲標題名
#print content.find('div',{'class':'apphub_AppName'}).text
contentHeader=content.find('div',{'class':'apphub_AppName'}).text
gameProfile[ID]['gameName']=contentHeader
#print gameProfile[ID]['gameName']


#遊戲描述 建議使用第一個
introduce=content.find('div',{'id':'game_area_description'}).text.replace('\t','').replace('\n','') 
#print content.find('div',{'id':'game_area_description'}).text#.replace('\t','').replace('\n','')
gameProfile[ID]['introduce']=introduce
#print gameProfile[ID]['introduce']

#找出發售日  新版待處理
#print content.find('div',{'class':'release_date'})
#.find('span',{'class':'date'}).text


#找出開發商、發行商、遊戲標籤、發售日
#print content.find('div',{'class':'details_block'}).text

con_list=str(content.find('div',{'class':'details_block'}))
split_list=con_list.split('<br>')
for event in split_list:
    htmlevent=BeautifulSoup(event)
    #print htmlevent
    #遊戲標籤
    if htmlevent.b.text in 'Genre:':
        temp=htmlevent.findAll('a')
        #for i in temp:
            #print i.text
    #開發商
    elif htmlevent.b.text == 'Developer:':
        temp=htmlevent.findAll('a')
        tempDevelop=''
        for i in temp:
            #print i.text
            tempDevelop+=i.text
            #print tempDevelop 
        gameProfile[ID]['developer']=tempDevelop
    
    #發行商
    elif htmlevent.b.text == 'Publisher:':
        temp=htmlevent.findAll('a')
        tempPublish=''
        for i in temp:
            #print i.text  
            tempPublish+=i.text
        gameProfile[ID]['publisher']=tempDevelop
    #發行日
    elif htmlevent.b.text == 'Release Date:':
        temp=str(htmlevent)
        gameProfile[ID]['releaseDate']=temp.split('<b>Release Date:</b>')[1]
    #print "------------------------------"

#找出遊戲網站評分
#print content.find('div',{'id':'game_area_metascore'}).text.strip()
score=content.find('div',{'id':'game_area_metascore'}).text.strip()
gameProfile[ID]['score']=score    
    
#找出系統需求
'''for i in content.findAll('div',{'id':'game_area_sys_req'}):
    print i.text'''

tempSRQ=''
for i in range(len(content.findAll('div',{'id':'game_area_sys_req_full'}))):
    tempSRQ+=content.findAll('div',{'id':'game_area_sys_req'})[i].find('h2').text.replace('\t','').replace('\n','').replace(' ','').replace('\r','')
    tempSRQ+=' '
    tempSRQ+=content.findAll('div',{'id':'game_area_sys_req_full'})[i].text.replace('\t','').replace('\n','').replace('\r','')
    tempSRQ+=' '
gameProfile[ID]['systemRequire']=tempSRQ

#print gameProfile[ID]

gameProfileJson=json.dumps(gameProfile[ID], indent = 4)
print gameProfileJson

testFile=open('123.json','w')
testFile.write(gameProfileJson)
testFile.close()
#print content.find('div',{'id':'game_area_sys_req'}).find('h2').text.replace('\t','').replace('\n','')
#print content.find('div',{'id':'game_area_sys_req_full'}).text



#語言版本
'''text = content.find('table',{'class':'game_language_options'}).findAll('tr')[1:]
for a in text:
    print a.text'''

#使用者認為的特性

'''chara=content.find('div',{'class':'glance_tags popular_tags'}).findAll('a')
for i in chara:
    #print i.text
    #print i.text.replace('\n','').replace('\t','')
    charaText=i.text.replace('\n','').replace('\t','')'''



#找出評論，未完成，網頁間id可能不同，不能套用
'''if content.find('div',{'id':'review_box partial'}) is None:
    print content.find('div',{'id':'Reviews_all'}).text'''