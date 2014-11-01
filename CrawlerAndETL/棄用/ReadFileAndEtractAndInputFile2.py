#!/usr/bin/python
# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import HTMLParser
import json
import os
import re

for dirPath, dirNames, AllfileNames in os.walk("E://Dropbox/iiiProject/data/allContent/"):
    for fileName in AllfileNames:
        print fileName
        #print os.path.join(dirPath, f)
        a=re.search('(\w+)',fileName)
        ID=a.group(1)
        gameProfile={ID:{'ID':ID,'gameName':'','introduce':'','releaseDate':'',
                 'score':'','developer':'','publisher':'',
                 'systemRequire':''}}
        #讀檔案至暫存區，等待解析
        targetFilePath="E://Dropbox/iiiProject/data/allContent/"+fileName
        of=open(targetFilePath,'r')
        t=of.readlines()
        of.close()
        x=""
        for i in t:
            x+=i
        #print x
        content=BeautifulSoup(x)
        
        #遊戲標題名
        #print content.find('div',{'class':'apphub_AppName'}).text
        if content.find('div',{'class':'apphub_AppName'}) is not None:
            contentHeader=content.find('div',{'class':'apphub_AppName'}).text
        #print contentHeader
        gameProfile[ID]['gameName']=contentHeader
        #print gameProfile[ID]['gameName']
        
        #遊戲描述 建議使用第一個
        if content.find('div',{'id':'game_area_description'}) is not None:
            introduce=content.find('div',{'id':'game_area_description'}).text.replace('\t','').replace('\n','') 
        #print content.find('div',{'id':'game_area_description'}).text#.replace('\t','').replace('\n','')
        gameProfile[ID]['introduce']=introduce
        #print gameProfile[ID]['introduce']
        
        #找出開發商、發行商、遊戲標籤、發售日
        #print content.find('div',{'class':'details_block'}).text

        con_list=str(content.find('div',{'class':'details_block'}))
        #print con_list
        split_list=con_list.split('<br>')
        #print split_list
      
        for event in split_list:
            #print event
            #print "-------------"
            event=event.replace('\n','')
            htmlevent=BeautifulSoup(event)
            
            #遊戲標籤
            if htmlevent.b is not None:
                if htmlevent.b.text == 'Genre:':
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

        #找出遊戲網站評分
        #print content.find('div',{'id':'game_area_metascore'}).text.strip()
        if content.find('div',{'id':'game_area_metascore'}) is not None:
            score=content.find('div',{'id':'game_area_metascore'}).text.strip()
            score=re.search('\w+',score)    
            score=score.group(0)
        gameProfile[ID]['score']=score
        
        #找出系統需求
        '''
        tempSRQ=''
        if content.findAll('div',{'id':'game_area_sys_req_full'}) is not None:
            for i in range(len(content.findAll('div',{'id':'game_area_sys_req_full'}))):
                tempSRQ+=content.findAll('div',{'id':'game_area_sys_req'})[i].find('h2').text.replace('\t','').replace('\n','').replace(' ','').replace('\r','')
                tempSRQ+=' '
                tempSRQ+=content.findAll('div',{'id':'game_area_sys_req_full'})[i].text.replace('\t','').replace('\n','').replace('\r','')
                tempSRQ+=' '
            gameProfile[ID]['systemRequire']=tempSRQ
        '''
        if content.findAll('div',{'class':'game_area_sys_req_full'}) is not None:
            tempNewRQ=content.findAll('div',{'class':'game_area_sys_req_full'})
            tempSRQ=''
            for i in tempNewRQ:
                #print i.text.strip().replace('\n','').replace('\t','')
                tempSRQ+=i.text.strip().replace('\n','').replace('\t','').replace('\r','')
            if tempSRQ =='':
                if content.findAll('div',{'class':'game_area_sys_req_leftCol'}) is not None:
                    tempNewRQ=content.findAll('div',{'class':'game_area_sys_req_leftCol'})
                    tempSRQ=''
                    for i in tempNewRQ:
                        #print i.text.strip().replace('\n','').replace('\t','')
                        #print tempSRQ
                        tempSRQ+=i.text.strip().replace('\n','').replace('\t','').replace('\r','')    
                elif tempSRQ=='':
                    tempNewRQ=content.findAll('div',{'class':'sysreq_contents'})
                    tempSRQ=''
                    for i in tempNewRQ:
                        #print i.text.strip().replace('\n','').replace('\t','')
                        #print tempSRQ
                        tempSRQ+=i.text.strip().replace('\n','').replace('\t','').replace('\r','')   
        
        gameProfile[ID]['systemRequire']=tempSRQ
        
        gameProfileJson=json.dumps(gameProfile[ID], indent = 4)
        #print gameProfileJson
        targetFilePath='E://iiiProject/data/extractContent/'+ID+'.json'
        print targetFilePath
        testFile=open(targetFilePath,'w')
        testFile.write(gameProfileJson)
        testFile.close()
        