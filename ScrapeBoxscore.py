import csv
import requests
import re
import urllib.request
import time
from bs4 import BeautifulSoup

#Use the Week in NFLSPDS
theweektoload = '24'

myinputfileloc   = 'C:\\ColdFusion2018\\cfusion\\wwwroot\\NFLCode\\Data\\Week' + theweektoload + '\\'
myoutputfileloc  = 'C:\\ColdFusion2018\\cfusion\\wwwroot\\NFLCode\\Data\\Week' + theweektoload + '\\'

theGamesFile = myinputfileloc + 'Week' + theweektoload + '.csv'

GameTime  = []
Week      = []
Fav       = []
Ha        = []
Spd       = []
Und       = []
HomeTeam  = []

#Step1: Need to create a CSV in Weekx folder called Weekx.csv that contains the Game Info.... 
#Must have Gametime,Week,Hometeam,HA
#Output will be the Hometeams name with '.txt'
#Load up the Game Data
with open(theGamesFile) as csvDataFile:
    csvReader = csv.reader(csvDataFile)
    for row in csvReader:
        GameTime.append(row[0])
        Week.append(row[1])
        Fav.append(row[2])
        Ha.append(row[3])
        Spd.append(row[4])
        Und.append(row[5])

        if row[3] == 'A': 
            HomeTeam.append(row[5])
        else:
            HomeTeam.append(row[2])

    #Loop for each game..
    for i in range(len(HomeTeam)):
        Team        = HomeTeam[i]
        #mydate     = '201902030'
        mydate      = GameTime[i] + '0'
        
        myurl       = 'https://www.pro-football-reference.com/boxscores/' + mydate + Team + '.htm'
        print(myurl)

        thegamedata = myoutputfileloc + Team + '.txt'

        print(thegamedata)

        theweekstr = "Week" + Week[0]
        theweekstr = "Week " + "8"


        print(theweekstr)
        
        response = requests.get(myurl)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        thedata = soup.find(string=re.compile(theweekstr))
        
        fo = open(thegamedata,"w")
        fo.write(thedata)

        thedata = soup.find(string=re.compile("First Downs"))
        fo.write(thedata)


        fo.close()





    
