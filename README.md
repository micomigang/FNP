# FNP 
title:
mental health for US
prerequisties:
install R 
import csv file in their file folder
installation:
run in R
ciatation:
contact:
minchuan.qin.gr@dartmouth.edu
# Mental Health: Students and Tech Workers



### U.S Mental Health:

#### Data Acquisition:	

* The data is collected from: https://www.datafiles.samhsa.gov/dataset/mental-health-client-level-data-2019-mh-cld-2019-ds0001

* Citation: Substance Abuse and Mental Health Services Administration, Center for Behavioral Health Statistics
  and Quality. Mental Health Client-Level Data 2019. Rockville, MD: Substance Abuse and
  Mental Health Services Administration, 2021.

#### Data Cleaning:

* The data is pretty cleaned, all are the null data was pre-labeled as not reported.
* I only keep the variables of interest, remove the others using "dplyr select": 
  * AGE: Calculated from the client's date of birth at midpoint of the state's elected reporting period. 14 categories
  * RACE: Specifies the client's most recent reported race at the end of the reporting period
  * SEX: Identifies the client's most recent reported sex at the end of the reporting period.
  * MARSTAT: Identifies the client's marital status.
  * MH1:Specifies the client's current first mental health diagnosis during the reporting period.

#### Analyze Process:

* Use "dplyr select" for columns of interest
  * Use ggplot2 package to plot for raw data (Disorder Distribution, Age distribution, Race Distribution and Marital Status Distribution)
  * Add titles, group by colors, etc. 

* Used United States Census summary statistics in 2019 for calculating the risk ratio: https://www.census.gov/quickfacts/fact/table/US/PST045221
* Use ggplot2 again to plot the risk ratio

### Student Mental Health:

#### Data Acquisition:	

* The data is collected from: https://www.kaggle.com/datasets/shariful07/student-mental-health

#### Data Cleaning:

* Download the data.csv from the website, and open it with Excel.
* Rename the columns.
  * Columns name: gender, age, course, study_year, GPA, mental_status, depression, anxiety, panic, treatment.
* The data only have one missing value, and we remove that row. 
* 0-1.99, 2-2.49, 2.5-2.99, 3-3.49, 3.5-4 in the GPA column are assigned 1, 2.25, 2.75, 3.25, 3.75 respectively.
* Replace all yes and no with numbers 1 and 0 in column "mental_status", "depression", "anxiety", "treatment" and "panic".
* Create one new column named "gendern" from gender, the value corresponding to the male is the number 1, and the value corresponding to the female is the number 0
* Create "unhealth_grade" column as the sum of "depression", "anxiety" and "panic".
* Create "marital_status" column, if one of the "depression", "anxiety" and "panic" columns is 1, then the row's "marital_status" value is 1.
* Create a column named "major", filter out the courses related to Technology and assign them to "Tech", and assign the rest to "Others".
* Save data.csv.

#### Analyze Process:

* Import the data in R.
* Use aov function to analyze the relationship between marital_status, GPA, study_year, age and mental health,including unhealth_grade and marital_status, respectively.
* Calculate the number and proportion of people with mental health problems and who have received treatment.
* Use gather function to reshape our data, then use ggplot to plot the stacked histogram, including
  * the proportion of people with mental health in different majors, 
  * percentages of different performances in unhealth_grade, 
  * contrasting relationships between gender and mental health.
* Use cor to calculate the correlation between different factor. 
* Then use corrplot function from "corrplot" package to plot the correlation heatmap.

### Tech Mental Health:
