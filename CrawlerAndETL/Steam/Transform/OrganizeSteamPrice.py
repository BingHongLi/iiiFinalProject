#-*- coding: utf-8 -*-
import re
import time
import datetime


def main():
    with open('C:/Users/BigData/Desktop/sPrice.csv', 'r') as file_R:
        i = 0
        priceLink = []
        for link in file_R.readlines()[1:]:
            linkSplit = link.strip().split(',')
            
            if(i == 0):
                tempID = linkSplit[0]
                tempMillisecond = int(linkSplit[1])
                tempRecordPrice = float(linkSplit[2])
                next
      
            if(linkSplit[0] != tempID):
                with open('C:/Users/BigData/Desktop/steamPrice.csv', 'a') as file_W:
                    file_W.write(''.join(priceLink))
                    del priceLink[:]
                    
            #timeStrftime = time.strftime('%Y-%m-%d', time.gmtime(int(linkSplit[1])/1000))
            #timeMktime = time.mktime(time.strptime(timeStrftime,"%Y-%m-%d"))
            
            while(True):
                if(int(linkSplit[1]) <= tempMillisecond):
                    tempMillisecond = tempMillisecond - 86400000
                    break
                priceLink.append(','.join([tempID, str(time.strftime('%Y-%m-%d %H:%M', time.gmtime(tempMillisecond/1000))), str(tempRecordPrice) + '\n']))
                tempMillisecond = tempMillisecond + 86400000
            
            tempID = linkSplit[0]
            tempMillisecond = int(linkSplit[1])
            tempRecordPrice = float(linkSplit[2])

            i = i + 1

if __name__ == "__main__":
    main()

