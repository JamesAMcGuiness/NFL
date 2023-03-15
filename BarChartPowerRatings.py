import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pandas import DataFrame

df = pd.read_csv("C:\\ColdFusion2018\\cfusion\\wwwroot\\NFLCode\\Data\\GameInsights3.csv",sep=",")

df.plot.bar(x = 'NFL Team', y ='PowerPts')

plt.ylabel('Power Rating')
plt.title('NFL Power Ratings')
plt.show()



#df.plot.bar(x = 'Team', y ='LuckFactor', alpha=0.5)

#plt.ylabel('Luck Rating')
#plt.title('What Percent Of A Teams Turnovers (+/-) Were From Fumbles Lost ')
#plt.show()



#df.plot.bar(x = 'Team', y ='Performance Rating', alpha=0.5)

#plt.ylabel('Performance Rating')
#plt.title('Team Weekly Performance Ratings')

#plt.show()
