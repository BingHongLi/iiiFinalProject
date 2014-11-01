#!/usr/bin/python
# -*- coding: utf-8 -*-

#植入json套件，要將抓到的資料存入Dic內，再轉存成json檔
import json

#範例，設定ID、其值又為多組key-value的集合
ID=123;
SteamPrice={ID:{'recordTime':'','recordPrice':'','discount':''}}
SteamPrice[ID]['recordTime']='2013-10-05'
SteamPrice[ID]['recordPrice']='60'
SteamPrice[ID]['discount']='0.25'
print SteamPrice

#轉成json格式
JSteamPrice=json.dumps(SteamPrice)
print "ENCODED:",JSteamPrice

decoded=json.loads(JSteamPrice)
print "DECODED:",decoded

print "ORIGINAL:",type(SteamPrice[ID]['discount'])
print "DECODED:",type(SteamPrice[ID]['discount'])