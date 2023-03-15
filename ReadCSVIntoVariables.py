import matplotlib.pyplot as plt
import csv
import operator

import matplotlib.pyplot as plt; plt.rcdefaults()
import numpy as np
import pandas as pd
from pandas import DataFrame


#with open('C:\\ColdFusion2018\\cfusion\\wwwroot\\NFLCode\\Data\\GameInsights3.csv', 'r') as csvfile:
PATH = r'C:\ColdFusion2018\cfusion\wwwroot\NFLCode\Data\\GameInsights3' + '.csv'
#(use "r" before the path string to address special character, such as '\'). Don't forget to put the file name at the end of the path + '.csv'
csvfile = pd.read_csv (PATH)   #read the csv file using the 'PATH' varibale 

df = DataFrame(csvfile,columns=['Team','Performance Rating','LuckFactor','NFL Team','PowerPts'])

objects = df["NFL Team"]
y_pos = np.arange(len(objects))

performance = df["PowerPts"]

plt.barh(y_pos, performance, align='center', alpha=0.5)
plt.yticks(y_pos, objects)
plt.xlabel('Usage')
plt.title('Power Ratings')
plt.show()
