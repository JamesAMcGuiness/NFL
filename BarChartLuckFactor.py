import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pandas import DataFrame

df = pd.read_csv("C:\\ColdFusion2018\\cfusion\\wwwroot\\NFLCode\\Data\\GameInsights3.csv",sep=",")

df.plot.bar(x = 'Team', y ='LuckFactor', alpha=0.5)

plt.ylabel('Luck Rating')
plt.title('What Percent Of A Teams Turnover Differential (+/-) Were From Fumbles Lost (Since fumbles are more due to luck, a high Luck Factor could mean overrated results)')
plt.show()
