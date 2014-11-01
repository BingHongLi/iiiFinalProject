#-*- coding: utf-8 -*-
import re
import time

file_R = open('C:/Users/BigData/Desktop/findingteddy_ajax.txt', 'r')
links = file_R.readlines()
file_R.close()

#print links[3]
m = re.findall('id:\'\w*\'', links[3])
print m
'''
m = re.findall('(v:new Date\(\d{10})',  links[4])
#n = [int(st.replace(r'v:new Date(','')) for st in m]
#print [time.strftime('%Y-%m-%d', time.gmtime(int(dat))) dat aa in n]
#將毫秒轉換為日期
#print links[4].split(r'{c:[{v:new Date(')[1:3]
'''
