__author__ = 'LIN,MING-CIAN'

# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import sys

#change encode
reload(sys)
sys.setdefaultencoding('utf8')


#define input method then output HTML
def MetacriticCrawler(inputUrl):         
    if __name__=='__main__':
	
		#find steam game name
        mGameName = inputUrl.split('.')[0]
		path ="/home/bigdata/IdeaProjects/Metacritic/details/"+inputUrl

        f =open(path,"r")
		
		#if your cod need recoding
        #b= f.read().encode('utf8')
		
        b= f.read()

        #catch down HTML
		soup = BeautifulSoup(b)                                        
        f.close()
		
		
		#open MetaCritic_link_.txt        
        f =open('MetaCritic_link_.txt','r')  
		othername =''
        index = f.readlines()
        
		#to figure out how much lines in index 
		#print index.__len__()
        for i in range(0,index.__len__()):

            link =index[i].split('|||||')[0].split('?full_summary=1')[0]
            if link.split('/')[5] ==mGameName:
                othername= index[i].split('|||||')[1].split()[0]
                break
        f.close()
        print othername


        MProfile={'MGameName':mGameName,'SteamGamename':othername,'Introduce':'','ReleaseDate':'','MetaScore':'','UserScore':'','Developer':''}


        #introduce content loop
        if soup.findAll('div',{"class":"summary_detail product_summary"}):
            introduce=soup.findAll('div',{"class":"summary_detail product_summary"})                         
            for i in introduce:
                point = (' '.join(i.text.encode('utf-8').split())).split(':')[1].replace('â','-').replace('â','\'')
                MProfile['Introduce'] = point
        else:
            introduce=soup.findAll('li',{"class":"summary_detail product_summary"})         
            for i in introduce:
                point = ' '.join(i.text.split(':')).replace('â','-').replace('â','\'')
                MProfile['Introduce'] = point

        #releaseDate content catch
        point = ' '.join(soup.find('li',{"class":"summary_detail release_data"}).find('span',{"class":"data"}).text.split())
        MProfile['ReleaseDate'] = point                                                                                     
        
		#meta score and user score catch
        metascore = soup.find('div',{"class":"metascore_wrap feature_metascore"}).text.encode('utf-8').split()[1]
        userscore = soup.find('div',{"class":"userscore_wrap feature_userscore"}).text.encode('utf-8').split()[2]
		
		#kick out To Be Discussed content
        if metascore != 'tbd' and userscore != 'tbd':
            MProfile['MetaScore'] =metascore
            MProfile['UserScore'] =userscore


       
        MGameTag={'MGameName':mGameName,'SteamGamename':othername,'GameTag':''}

		#developer & gameTag
        if soup.find('table',{"cellspacing":"0"}) :
            table = soup.find('table',{"cellspacing":"0"})                                                                                       

            gameTag=list()
            developer=list()
			
			#take content from table one by one
            for tag in table.findAll('tr'):                                                                                                     
                information = ''.join(tag.text.encode('utf-8').split())
                if information.split(':')[0] == 'Genre(s)' or information.split(':')[0] == 'ESRBDescriptors':
                    gameTag.append(information.split(':')[1])
                if information.split(':')[0] == 'Developer':
                    developer.append(information.split(':')[1])
            for i in range(0,developer.__len__()):
                MProfile['Developer']=(developer[i])
            for i in range(0,gameTag.__len__()):
                MGameTag['GameTag'] = gameTag[i]
		
		#out put to 'MProfile3'
        f =open('MProfile3.txt','a')
        f.write('\"'+MProfile['MGameName']+'\"|\"'+MProfile['SteamGamename']+'\"|\"'+MProfile['Developer']+'\"|')
        f.write('\"'+MProfile['ReleaseDate']+'\"|\"'+MProfile['MetaScore']+'\"|\"'+MProfile['UserScore']+'\"|\"'+MProfile['Introduce']+'\"')
        f.write("\n")
        f.close()


        
        #out put gameTag
        f =open('MGameTag3.txt','a')
        f.write('\"'+MGameTag['MGameName']+'\"|\"'+MGameTag['SteamGamename']+'\"|\"'+ MGameTag['GameTag']+'\"')
        f.write("\n")
        f.close()



        #this is programming to catch HTML from web before
        #time.sleep()
		
        path ="/home/bigdata/IdeaProjects/Metacritic/critic-reviews/"+inputUrl
        f =open(path,"r")
		#take content about gameReview
        c= f.read()#.encode('utf8')		
        soup2 = BeautifulSoup(c)                                        
        f.close()                                                                                                             



        MGameReview={'MGameName':mGameName,'SteamGamename':othername,'GameReview':'','Date':'','Score':'','Writer':''}

        # help from PINGCHUN to take three kind tag match function
        def match_class(target):
            def do_match(tag):
                classes = tag.get('class', [])
                return all(c in classes for c in target)
            return do_match

        

        i=0
        f =open('MGameReview3.txt','a')
        if soup2.find('div',{"class":"body product_reviews"}).find('div',{"class":"msg msg_no_reviews"}) is None:
            content =soup2.findAll('div',{"class":"review_btm review_btm_r"})
			
			#take content one by one
            while soup2.find('div',{"class":"body product_reviews"}).find('div',{"class":"msg msg_no_reviews"}) is None:
			
                if content[i].find('div',{"class":"date"}):
                    #print content[i].find('div',{"class":"date"}).text.encode('utf-8').split()
                    Date = content[i].find('div',{"class":"date"}).text.encode('utf-8').split()
                    MGameReview['Date'] =' '.join(Date)
                    #print Date
					
                if content[i].find('div',{'class':'source'}):
                    Writer = ' '.join(content[i].find('div',{'class':'source'}).text.encode('utf-8').split())
                    MGameReview['Writer'] = Writer
					#print Writer
					
                if content[i].find('div',{'class':'review_body'}):
                    GameReview = ' '.join(content[i].find('div',{'class':'review_body'}).text.encode('utf-8').split()).replace('â','-').replace('â','\'')
                    MGameReview['GameReview'] =GameReview
                    #print GameReview
				
				#to take three kind tag
                if content[i].find(match_class(["metascore_w", "medium", "game"])): 
                    Score = content[i].find(match_class(["metascore_w", "medium", "game"])).text.encode('utf-8').split()[0]
                    MGameReview['Score'] =Score
					#print Score
					#print MGameReview



                f.write('\"'+MGameReview['MGameName']+'\"|\"'+MGameReview['SteamGamename']+'\"|\"'+MGameReview['Writer']+'\"|')
                f.write('\"'+MGameReview['Date']+'\"|\"'+MGameReview['Score']+'\"|\"'+MGameReview['GameReview']+'\"')
                f.write("\n")
                MGameReview={'MGameName':mGameName,'SteamGamename':othername,'GameReview':'','Date':'','Score':'','Writer':''}

                i+=1

                if soup2.find('div',{"class":"body product_reviews"}).findAll('div',{"class":"review_body"}).__len__() == i:
                    f.close()
                    break
#MetacriticCrawler method End


#if you need to test MetacriticCrawler function you can use this block
#a= 'http://www.metacritic.com/game/pc/1701-ad'
#MetacriticCrawler('king-arthur-the-role-playing-wargame.txt')


#Call function to actually run
import os
for dirPath, dirNames, fileNames in os.walk("/home/bigdata/IdeaProjects/Metacritic/details/"):
    for fileName in fileNames:
        print fileName
        MetacriticCrawler(fileName)


