#Load libraries:
import pandas as pd
import matplotlib.pyplot as plt

#########################################

#Load Journal of Informetrics Data:
j_of_inf_yd = pd.read_csv("/home/jovyan/{query_id_here}.csv", sep=',', header = 0)
print(j_of_inf_yd)

#########################################

#Load Scientometrics Data:
scien_yd = pd.read_csv("/home/jovyan/{query_id_here}.csv", sep=',', header = 0)
print(scien_yd)

#########################################

#Merge datasets and print:

scien_yd2 = scien_yd[scien_yd.journal_name == 'SCIENTOMETRICS']

scien_yd2 = scien_yd[['wos_id', 'year']]

scien_yd = scien_yd2.groupby(['year']).count()

j_of_inf_yd2 = j_of_inf_yd[['wos_id', 'year']]

j_of_inf_yd = j_of_inf_yd2.groupby(['year']).count()

yd = scien_yd.merge(j_of_inf_yd, left_on='year', right_on='year', how = 'outer')

yd.reset_index(inplace=True)

yd = yd.sort_values('year')

yd.columns = ['year', 'Scientometrics', 'Journal of Informetrics']

yd = yd.fillna(0)
print(yd)

##########################################

#Create plot:
yd.plot(x='year', y=['Journal of Informetrics', 'Scientometrics'], color=['blue', 'red'], kind='line')
plt.legend(loc = 2)
plt.ylabel(ylabel='No. of Publications')
plt.title(label = 'Publication History of Ying Ding in Two Journals')
plt.show()
