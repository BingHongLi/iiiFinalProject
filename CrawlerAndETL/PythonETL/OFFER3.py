___author__ = 'BigData'
# -*- coding: utf-8 -*-
f = open('.\working\IPriceSTEAMSTORE.csv','r')
g=f.readlines();

f = open('./working/output.csv','w')
SGAMENAME =''
price=list()

for h in g:
    if h.split(',')[0] != SGAMENAME:
        f.write( SGAMENAME+','+','.join(price)+'\n')
        SGAMENAME=h.split(',')[0]
        price=list()
    else:
        b=h.split(',')[1]
        price.append(b)
f.write( SGAMENAME+','+','.join(price)+'\n')
f.close()
