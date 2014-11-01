#-*- coding: utf-8 -*-
import re
import os

def main():
    for dirPath, dirNames, fileNames in os.walk('C:\\Users\\BigData\\Desktop\\10\\csv_10'):
        with open('C:\\Users\\BigData\\Desktop\\001\\data.csv', 'a') as file_W:
            file_W.write('id,company,date,price,price_have_special_before,price_special\n')
            for f in fileNames:
                li = []
                print f
                
                with open(os.path.join(dirPath, f), 'r') as file_R:
                    for line in file_R.readlines()[1:]:
                        li.append(f.replace(r'.csv', '') + ',' + line.replace('"', '').replace(',null,', ',,'))
                file_W.write(''.join(li))

if __name__ == "__main__":
    main()

