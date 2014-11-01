
# coding: utf-8

# In[19]:

import requests
from bs4 import BeautifulSoup
import urlparse
import os

# To bypass the website preventing crawler, use the headers to mimic browser.
hder =  {'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36'} 
s_url = 'http://www.metacritic.com/browse/games/title/pc'
root = 'E:\\python\\workspace\\MetacriticCrawler\\res'
#root = 'D:\\YB802\\python\\workspace\\MetacriticCrawler\\res' 

if not os.path.exists(root + '\\' + 'link'): 
    os.makedirs(root + '\\' + 'link')

navlink_file = open(root + '\\' + 'link' + '\\' + 'nav_link.txt', 'r')
for line in navlink_file.readlines():
    nav_alink = line.strip()
    
    #Get the nav name.
    nav_name = '#'
    if len(nav_alink.split('/')) >= 8:
        nav_name = nav_alink.encode('utf8').split('/')[7]     
        
    #Catch game's link
    page_format = nav_alink + '?view=condensed&page=%d'    
    nav_res = requests.get(nav_alink, headers = hder).text.encode('utf8')     
    page_tot = BeautifulSoup(nav_res).find('li', {'class':'last_page'})
    page_num = 0
    if page_tot is not None:  #Condition with several pages
        page_num = int(page_tot.find('a').text) - 1
    
    #Write game's link into file
    gamelink_file = open(root + '\\' + 'link' + '\\' + nav_name+'_link.txt', 'w')
    for page in range(0, page_num + 1):
        generepage_res = requests.get(page_format%(page), headers = hder).text.encode('utf8')
        for li in BeautifulSoup(generepage_res).findAll('li', {'class':'game_product'}):
            if li.find('div', {'class':'tbd'}) is None:
                game_link = urlparse.urljoin(s_url, li.find('a', {'href':True})['href'])
                gamelink_file.write(game_link + '\n')
                print game_link
                
    gamelink_file.close()    
navlink_file.close()


# In[ ]:



