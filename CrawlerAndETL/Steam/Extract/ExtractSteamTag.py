# -*- coding:utf-8 -*-
#read_steam_tag.py
import re
import os
from BeautifulSoup import BeautifulSoup

def is_steam_tag(soup, steam_tags_list):
    tags = soup.find('div',{"class":"details_block"})\
              .findAll(href=re.compile(r"http://store.steampowered.com/genre/"))
    [steam_tags_list.append('\"' + tag.text.encode('utf-8') + '\"') for tag in tags]
    return steam_tags_list

def is_user_tag(soup, user_tags_list):
    tags = soup.findAll('a',{"class":"app_tag"})
    [user_tags_list.append('\"' + tag.text.strip().encode('utf-8') + '\"') for tag in tags]
    return user_tags_list

def read_tag(input_path):
    with open(input_path,'r') as file_R:
        soup = BeautifulSoup(file_R.read())
        input_name = re.search('(app_[\d]+)|(sub_[\d]+)', input_path).group()
        
        with open('C:/Users/BigData/Desktop/steam_tags.txt','a') as file_steam_tags:
            steam_tags_list = [input_name]
            file_steam_tags.write(','.join(is_steam_tag(soup, steam_tags_list)) + '\n')

        with open('C:/Users/BigData/Desktop/user_tags.txt','a') as file_user_tags:
            user_tags_list = [input_name]
            file_user_tags.write(','.join(is_user_tag(soup, user_tags_list)) + '\n')

def main():
    i = 1
    for dirPath, dirNames, AllfileNames in os.walk("C:\\Users\\BigData\\Desktop\\data\\"):
        for fileName in AllfileNames:
            print i, os.path.join(dirPath, fileName)
            try:
                read_tag(os.path.join(dirPath, fileName))
            except Exception as e:
                with open('C:/Users/BigData/Desktop/tags_error.txt','a') as file_w:
                    file_w.write(fileName + '\n' + e + '\n')
                    print e
            i = i + 1

if __name__ == "__main__":
    main()

