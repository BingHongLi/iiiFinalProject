import requests
from bs4 import BeautifulSoup
from math import ceil

#使用設定代理伺服器 http://www.us-proxy.org/
http_proxy = {'http' : '216.189.0.235:3127'} #
requests.adapters.DEFAULT_RETRIES = 100
res = requests.get('http://store.steampowered.com/search/results' , proxies = http_proxy)
soup = BeautifulSoup(res.text.encode('utf-8'))
#抓取總網頁頁數
search_pagination_right = soup.find_all('div', class_ = 'search_pagination_left') 
page = int(ceil(float(search_pagination_right[0].text.split()[5])/25))

file_W = open('C:/Users/BigData/All_Pages.txt', 'a')
i = 1
while i <= page:
    links = []
    #抓取第i頁
    try:
        res = requests.get('http://store.steampowered.com/search/results?all&page={0}'.format(i), proxies = http_proxy)
    except:
        try:
            res = requests.get('http://store.steampowered.com/search/results?all&page={0}'.format(i), proxies={'http' : '199.200.120.140:3127'})
        except:
            res = requests.get('http://store.steampowered.com/search/results?all&page={0}'.format(i), proxies={'http' : '198.52.217.44:3127'})
    soup = BeautifulSoup(res.text.encode('utf-8'))
    #將資料丟到links內
    links.extend(soup.find_all('a', class_ = 'search_result_row even'))
    links.extend(soup.find_all('a', class_ = 'search_result_row odd'))
    for link in links:
        file_W.write(link['href'].encode('utf-8') + '\n')
    i = i + 1
    
file_W.close()