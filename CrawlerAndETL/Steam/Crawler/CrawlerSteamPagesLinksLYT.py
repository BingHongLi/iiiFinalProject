 #-*- coding: utf-8 -*-
import requests
from bs4 import BeautifulSoup

def crawler_steam_pages_links(input_file, output_folder):
    return_index = []
    return_limited_area = []
    return_limited_18 = []
    return_200 = []
    i = 1

    for link in open(input_file):
        res = requests.get(link)
        soup = BeautifulSoup(res.text.encode('utf-8'))
        if soup.title.text == 'Welcome to Steam' or  soup.title.text.encode('utf-8') == '歡迎來到 Steam':
            return_index.append(link.strip())
        elif soup.title.text == 'Site Error':
                    return_limited_area.append(link.strip())
        elif soup.find('body', class_='v6 agecheck') is not None:
            return_limited_18.append(link.strip())
        else:
            return_200.append(link.strip())
        print i
        print link.strip()
        i = i + 1

    file_W_return_index = open(output_folder + 'return_index.txt', 'a')
    file_W_return_index.write('\n'.join(return_index))
    file_W_return_index.close()

    file_W_return_limited_area = open(output_folder + 'limited_area.txt', 'a')
    file_W_return_limited_area.write('\n'.join(return_limited_area))
    file_W_return_limited_area.close()

    file_W_return_limited_18 = open(output_folder + 'limited_18.txt', 'a')
    file_W_return_limited_18.write('\n'.join(return_limited_18))
    file_W_return_limited_18.close()

    file_W_return_200 = open(output_folder + '200.txt', 'a')
    file_W_return_200.write('\n'.join(return_200))
    file_W_return_200.close()

def main():
    crawler_steam_pages_links('C:/Users/BigData/Desktop/200.txt', 'C:/Users/BigData/Desktop/001/')

if __name__ == "__main__":
    main()
