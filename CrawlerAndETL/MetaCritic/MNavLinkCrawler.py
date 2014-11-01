
# coding: utf-8

# In[1]:

import requests
from bs4 import BeautifulSoup
import urlparse
import os

# To bypass the website preventing crawler, use the headers to mimic browser.
hder =  {'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36'} 
s_url = 'http://www.metacritic.com/browse/games/title/pc'
root = 'E:\\python\\workspace\\MetacriticCrawler\\res'
#root = 'D:\\YB802\\python\\workspace\\MetacriticCrawler\\res' 

res = requests.get(s_url, headers = hder).text.encode('utf8')
nav_box = BeautifulSoup(res).find('ul', {'class':'letternav'})
navlink_file = open(root + '\\' + 'nav_link.txt', 'w')

#Catch nav link
navlink_file.write(s_url + '\n')
for nav_tab in nav_box.findAll('li', {'class':'letter'}):       
  
    #Write nav's link into file
    nav_atab = nav_tab.find('a', {'href':True})
    if nav_atab is not None:      
        nav_alink = urlparse.urljoin(s_url, nav_atab['href'])
        navlink_file.write(nav_alink + '\n')
        print nav_alink

navlink_file.close()


# In[ ]:



