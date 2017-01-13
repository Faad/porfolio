import requests, csv, os

#HTTP/1.1 302 Found
RecID = 0
filesmain= open('link_list.txt','a')
#writer = csv.writer(filesmain) 
filessecond= open('not_posible.txt','a')
statusneeded= 200

header=['url','name']
csv.register_dialect(
    'wwwdialec',
    delimiter = "'",

    )
#url = "https://ucpi.sco.ca.gov/ucp/PropertyDetails.aspx"
#squery =
#connection to website where query string is variable. If connection is possible add to arrays
#If http code is ok 
#    add URL to  list usable 
#else 
# range for use 1, 5*10**6  
#  add list not usable  
for RecID in range(1,30):
    value={'propertyRecID': RecID }
    connection=requests.get('https://ucpi.sco.ca.gov/ucp/PropertyDetails.aspx',params=value, allow_redirects=False, timeout=1)
    print(RecID)
    if connection.status_code == statusneeded:
        filesmain.write(connection.url+'\n')
    else:
        filessecond.write(connection.url+'\n')
filessecond.close()
filesmain.close()
        




        