import requests
import bs4
import csv
import time
from datetime import datetime
from bs4 import SoupStrainer



#firstname = []
#midlename = []
#lastname = []
#cash_or_amount = []
#propertype = []
#state = []
#zipcode5_character = []
#zipcode4_character = []
#street_address = []
#property_number = []
#reported_by = []
#property_type = []
filter_header = SoupStrainer(id="tbl_HeaderInformation")
filter_property = SoupStrainer(id="PropertyDetailsTable")


try:
    connection = requests.get('https://ucpi.sco.ca.gov/ucp/PropertyDetails.aspx?propertyRecID=7370000')
    pageobject_header = bs4.BeautifulSoup(connection.text, "html.parser",parse_only=filter_header)
    pageobject_property = bs4.BeautifulSoup(connection.text, "html.parser",parse_only=filter_property)
except HTTPErrot as he:
    print(he)
except AttributeError as ae: 
    print(ae)
    exit

time.sleep(2)
# firstname/midlename/lastname/cash_or_amount/propertype/state
# /zipcode5_character/zipcode4_character/street_address/property_number/reported_by/property_type/

#Date ['\r\n 10/16/2016\r\n ']
#tbl_HeaderInformation table information
data_from_header = pageobject_header.select("#tbl_HeaderInformation span")
Date = data_from_header[0].contents[0].strip()
print(Date+' Line 44')
Source = data_from_header[1].contents[0].strip()
print(Source+' Line 46')
ID_number = data_from_header[2].contents[0].strip()
print(ID_number+' Line 48')




# Owner'\r\n NEVES MELVIN W\r\n '
# Address'\r\n 301 SOUTH WITHER ST #202LOS ANGELES CA 90017-\n'
# Proper_type'\r\n Matured/terminated policies\r\n '
# Cash'\r\n $458.35\r\n \r\n '
# ReportedBy '\r\n ALLSTATE LIFE INSURANCE COMPANY \r\n '
#PropertyDetailsTable information
OwnersNameList = pageobject_property.select('#ctl00_ContentPlaceHolder1_dlOwners')
AddressList = pageobject_property.select('#ReportedAddressData')
Property_typeList = pageobject_property.select('#PropertyTypeData')
CashList = pageobject_property.select('#ctl00_ContentPlaceHolder1_CashReportData')
ReportedByList = pageobject_property.select('#ReportedByData')

OwnersName = tuple(OwnersNameList[0].contents[0].stripped_strings)[0]
print(OwnersName+' Line 66')
Address = AddressList[0].contents[0].strip()
print(Address+' Line 68')
Property_type = Property_typeList[0].contents[0].strip()
print(Property_type+' Line 70')
Cash = CashList[0].contents[0].strip()
print(Cash +' Line 72')
ReportedBy = ReportedByList[0].contents[0].strip()
print(ReportedBy+' Line 74')

#with open('output.csv','a') as csv_file:
#    writer = csv.writer(csv_file)
#    writer.writerow([datetime.now(), ID_number, Source, Date, OwnersName, Address, Property_type, Cash, ReportedBy])