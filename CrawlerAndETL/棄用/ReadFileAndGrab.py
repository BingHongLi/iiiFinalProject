from bs4 import BeautifulSoup
import HTMLParser
import json

#遊戲基本資料json檔
'''gameProfile={ID:{'gameName':'','introduce':'','releaseDate':'','story':'',
                 'score':'','developer':'','publisher':'',
                 'systemRequire':''}}'''



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
#contentHeader=content.find('div',{'class':'apphub_AppName'}).text

#找出遊戲描述
'''for i in content.findAll('div',{'id':'game_area_description'}):
    print i.text'''

#找出發售日
#print content.find('div',{'class':'release_date'})
#.find('span',{'class':'date'}).text


#遊戲描述 建議使用第一個
#print content.find('div',{'id':'game_area_description'}).text.replace('\t','').replace('\n','') 
#print content.find('div',{'id':'game_area_description'}).text#.replace('\t','').replace('\n','')


#找出開發商、發行商、遊戲標籤
#print content.find('div',{'class':'details_block'}).text

'''Developer_detail={'Genre:':'','Developer:':'','Publisher:':'','Release Date:':''}
con_list=str(content.find('div',{'class':'details_block'}))
split_list=con_list.split('<br>')
for event in split_list:
    htmlevent=BeautifulSoup(event)
    #print htmlevent
    #遊戲標籤
    if htmlevent.b.text in 'Genre:':
        temp=htmlevent.findAll('a')
        for i in temp:
            print i.text
    #開發商
    elif htmlevent.b.text == 'Developer:':
        temp=htmlevent.findAll('a')
        for i in temp:
            print i.text
    #發行商
    elif htmlevent.b.text == 'Publisher:':
        temp=htmlevent.findAll('a')
        for i in temp:
            print i.text  
    #發行日
    elif htmlevent.b.text == 'Release Date:':
        temp=str(htmlevent)
        print temp.split('<b>Release Date:</b>')[1]
    print "------------------------------"
'''

#找出系統需求
'''for i in content.findAll('div',{'id':'game_area_sys_req'}):
    print i.text'''
'''
for i in range(len(content.findAll('div',{'id':'game_area_sys_req_full'}))):
    print content.findAll('div',{'id':'game_area_sys_req'})[i].find('h2').text.replace('\t','').replace('\n','').replace(' ','')
    print content.findAll('div',{'id':'game_area_sys_req_full'})[i].text.replace('\t','').replace('\n','')
'''
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