
# coding: utf-8

# In[21]:

import requests
from bs4 import BeautifulSoup
import urlparse
import os
import re

# To bypass the website preventing crawler, use the headers to mimic browser.
hder =  {'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36'} 
s_url = 'http://www.metacritic.com/browse/games/title/pc'
root = 'E:\\python\\workspace\\MetacriticCrawler\\res'
#root = 'D:\\YB802\\python\\workspace\\MetacriticCrawler\\res' 
url_dic = {'critic-reviews', 'user-reviews', 'details'}  
retry = 3

# Read all the files of links in the 'root\\link'
for source, dirs, files in os.walk(root + '\\' + 'link'):       
    for f in files:
        link_file = open(root  + '\\' + 'link' + '\\' + f, 'r')
        
        
        for line in link_file.readlines():
            game_link = line.strip()

#Catch names of the games
            game_name = game_link.encode('utf8').split('/')[5]            
                
#Catch detail page of games                
            for content in url_dic:
                if not os.path.exists(root + '\\' + content):    
                    os.makedirs(root + '\\' + content)
                
                main = None                
                times = 0
                while main is None and times < retry:
                    game_res = requests.get(game_link + '/' + content, headers = hder).text.encode('utf8')
                    game_soup = BeautifulSoup(game_res)
                    main = game_soup.find('div', {'id':'main'})
                    #recomm = game_soup.find('div', {'id':'yad-widget-2'})
                    times += 1      
                
                #Write page content into file
                if main is not None:
                    #Catch total page number in content page 
                    page_format = game_link + '/' + content + '?page=%d'                        
                    page_tot = main.find('li', {'class':'page last_page'})
                    page_num = 0
                    if page_tot is not None:  #Condition with several pages
                        page_num = int(page_tot.find('a').text) - 1  
                        
                    content_file = open(root + '\\' + content + '\\' + game_name + '.txt', 'w')                
                    #content_file.write(main.prettify('utf-8') + '\n' + '\n' + '\n' + recomm.prettify('utf-8'))
                    
                    #Catch content in each page
                    for page in range(0, page_num + 1):
                        contentpage_res = requests.get(page_format%(page), headers = hder).text.encode('utf8')
                        main = BeautifulSoup(contentpage_res).find('div', {'id':'main'})
                        
                        #Write content into file
                        if main is not None:
                            content_file.write(main.prettify('utf-8') + '\n')
                            print game_link +'/'+ content + '.' + str(page)
                        else:
                            #If page's main is none then print error
                            print 'error' 
                        
                    content_file.close()                    
                else:
                    #If game's main cannot be caught then print error
                    print game_link +'/'+ content + '.error' 
        
        link_file.close()                    

