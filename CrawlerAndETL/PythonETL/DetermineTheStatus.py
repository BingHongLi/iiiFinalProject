__author__ = 'LIN,MING-CIAN'
# -*- coding: utf-8 -*-

#Because SQL server can not take the price of the previous day's price movements to determine whether there is today,
#so I took out in order to sort by date price information table,
#and then use Python to determine and output,
#and finally import the SQL server.

f = open('./working/IPrice.csv','r')
g=f.readlines();

f = open('./working/output.csv','w')
id=''
company=''
price=''
preprice=0
for h in g:

    if h.split(',')[3] == 'price':
        continue
		
    #print h.split(',')[3]
    name =h.split(',')[0]
    com=h.split(',')[1]
    time=h.split(',')[2]
    j=float(h.split(',')[3])
    #print j

    if (id !=name) or company!=com:
        id=name;
        company=com
        state ='0';
		
	# This  price cheaper than before
    elif preprice > j:
        state ='1';
	# This pen a price expensive than before
    elif preprice < j: 
        state ='2';
	# This pen a price same as before
    elif preprice ==j: 
        state ='0';
		
    preprice = j
    price =str(h.split(',')[3].split('\n')[0])
    f.write(id+','+company+','+time+','+str(price)+','+state+'\n')
f.close()
