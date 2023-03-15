import matplotlib.pyplot as plt
import csv
import operator
x=[]
y=[]



with open('C:\\ColdFusion2018\\cfusion\\wwwroot\\NFLCode\\Data\\GameInsights3.csv', 'r') as csvfile:
    plots= csv.reader(csvfile, delimiter=',')

    #sortedlist = sorted(plots, key=operator.itemgetter(1), reverse=False)
    
    for row in plots:
        x.append(row[0])
        y.append(float(row[1]))


plt.plot(x,y, marker='o')

plt.title('Week 1 Team Performance')

plt.xlabel('Team')
plt.ylabel('Rating')

plt.show()

