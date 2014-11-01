#-*- coding: utf-8 -*-
import requests
from bs4 import BeautifulSoup

def game_info_ajaxs(input_name, output_folder):
    link = 'http://isthereanydeal.com/ajax/game/info?plain={0}'.format(input_name)
    res = requests.get(link)
    soup = BeautifulSoup(res.text.encode('utf-8'))
    game_info = soup.find('a', {'class' : r'shopTitle steam'})
    if game_info is None:
        print input_name + ' -- null'
        with open(output_folder + 'isthereanydeal_to_Steam_null.txt', 'a') as file_w:
            file_w = file_w.write(input_name + '\n')
    else:
        print input_name
        try:
            with open(output_folder + 'isthereanydeal_to_Steam.txt', 'a') as file_w:
                game_info = game_info['href']
                file_w = file_w.write(input_name+ ',' + game_info + '\n')   
        except Exception as inst:
            print input_name + ' -- error'
            print inst
            with open(output_folder + 'error.txt', 'a') as file_w:
                file_w = file_w.write(input_name + '\n')
def main():
    with open('C:/Users/BigData/Desktop/asdlinks.txt', 'r') as read_links:
        links = read_links.readlines()
        [game_info_ajaxs(link.strip(), 'C:/Users/BigData/Desktop/') for link in links]

if __name__ == "__main__":
    main()
