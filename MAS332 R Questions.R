


# INSTRUCTIONS
#   1) All data cleaning should be done using a dplyr chain connected directly to the read.csv() line (only one read.csv() per part, do not re-clean for each question)
#   2) You only need to "clean" anything that you need to clean to answer the questions asked. I am not asking you to fix EVERY column or problem you see in the data.
#   3) All visualizations should be completed using the ggplot2 package
#   4) All questions should print an answer directly to the console, no saving additional datasets or variables to the environment
#   5) All questions should be answered in a single dplyr line (i.e. you should hit "run" one single time and see a solution)
#   6) You may use notes, internet, etc, anything BUT OTHER PEOPLE OR YOUR CLASSMATES!
#   7) Solutions may not include functions or topics not covered in the course



# Question 0: What is your name: Nicholas Vowinkel


# Please load any packages used in this script here. Do not include packages that you will not need.
# Packages used:

library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)

##################################
# Part 1 - Inc 5000 (Inc 4,998?) #
##################################
# Data represents the Inc 5000 list from (I believe) 2023. Yes, I know there are only 4,998 companies in the data; I do not know why!

# Question 1: Data Cleaning of inc dataset

inc = read.csv('https://dxl-datasets.s3.amazonaws.com/data/inc2023.csv') 

inc_clean = read.csv('https://dxl-datasets.s3.amazonaws.com/data/inc2023.csv') %>%
  mutate(
    Rank = as.numeric(X_...rank),
    Growth = as.numeric(gsub('[,%]', '', X_...growth)),
    Workers = as.numeric(X_...workers),
    Company = X_...company,
    State = X_...state_s,
    Revenue = as.numeric(gsub('[$,]', '', X_...revenue)),
    YearFounded = as.numeric(X_...founded),
    Industry = X_...industry,
    YearsOnList = as.numeric(gsub('[ Years]', '', X_...yrs_on_list))) %>%
  select(Rank, Growth, Workers, Company, State, Revenue, YearFounded, Industry, YearsOnList)
    

# Question 2: How many companies are on the list for the first time?

inc_clean %>%
  filter(YearsOnList == 1) %>%
  nrow()

# Question 3: What percent of companies on the list for 5 years or more are in the software industry?

inc_clean %>%
  filter(YearsOnList >= 5) %>%
  summarise(PercentageDecimal = mean(Industry == "Software"))

# Question 4: What is the average revenue among companies in the software industry on the list for the first time?

inc_clean %>%
  filter(YearsOnList == 1, Industry == "Software") %>%
  summarise(AverageRevenue = mean(Revenue))

# Question 5: Return a table of the average revenue by industry, sorted high to low by average revenue.

inc_clean %>%
  group_by(Industry) %>%
  summarise(AverageRevenue = mean(Revenue)) %>%
  arrange(desc(AverageRevenue))

# Question 6: Visualize the relationship between years on list and growth rate with a barplot.
#       * Set the x-axis breaks to be at every integer from 1 to 13
#       * Set y-axis breaks as desired and display them as percentages (i.e. 20% rather than .2, for example)

inc_clean %>%
  group_by(YearsOnList) %>%
  summarise(GrowthRate = mean(Growth)) %>%
  ggplot(aes(x=YearsOnList, y=GrowthRate)) +
  labs(title = "Years On List Vs. Growth Rate", x = "Year", y = "Growth Rate Percentage") +
  geom_col(color='black', fill='blue') +
  scale_y_continuous(seq(0, 900, by = 100), labels = function(x) paste0(sprintf("%.0f", x), "%")) +
  scale_x_continuous(breaks = 1:13)

#######################################################################
# Part 2 - AI, Algorithmic and Automation Incidents and Controversies #
#######################################################################


# AIAAIC (AI, Algorithmic, and Automation Incidents and Controversies) is an independent, non-partisan, public interest initiative that examines and makes the 
# case for real AI, algorithmic, and automation transparency and openness.

# AIAAIC is looking to make AI, algorithms, and automation more transparent by:
  
# **Empowering** civil society entities including researchers, academics, teachers, NGOs, journalists, and think tanks
# **Educating** end users, citizens, students, and others
# **Making the case** to policymakers, regulators, and businesses



# Question 7: Data Cleaning of aidata dataset
aidata = read.csv('https://dxl-datasets.s3.amazonaws.com/data/exam_part2.csv')

aidata_clean <- read.csv('https://dxl-datasets.s3.amazonaws.com/data/exam_part2.csv') %>%
  mutate(
    Year = as.numeric(Year),
    Countries = case_when(
      grepl("Global", Countries) ~ "USA; UK; China; (Global)",
      TRUE ~ Countries),
    Developers = case_when(
      grepl("OpenAI", Developers) ~ "OpenAI",
      grepl("Google|Alphabet", Developers) ~ "Google/Alphabet",
      grepl("Tesla", Developers) ~ "Tesla",
      grepl("Facebook|Meta", Developers) ~ "Facebook/Meta",
      grepl("Amazon", Developers) ~ "Amazon",
      grepl("Microsoft", Developers) ~ "Microsoft",
      TRUE ~ "Others")) %>%
  select(Year, Countries, Developers, Issues, Type)

# Question 8: Visualize the number of safety issues by year in the USA with a bar plot.

aidata_clean %>%
  group_by(Year) %>%
  filter(grepl('USA', Countries)) %>%
  summarise(NumberofSafetyIssues = sum(grepl("Safety", Issues))) %>%
  ggplot(aes(x=Year, y=NumberofSafetyIssues)) +
  geom_col(color='black', fill='blue') +
  labs(title = "Number of Safety Issues in the USA", x = "Year", y = "Number of Safety Issues")
  
# Question 9: Visualize the number of incidents by developer. 
#     Given the number of developers in the data, please display this as: OpenAI, Google/Alphabet, Tesla, Facebook/Meta, Amazon, Microsoft, Others.
#     NOTE: If an incident involves multiple developers, you can just pick one and assign it there 
#           You do not need to count it towards each developer
#           For example, if Developers = "Google; OpenAI", you can assign it to either Google or OpenAI
#           You are welcome to accurately count it toward both - it's a bit more complicated, but not by much - but you do not have to do that

aidata_clean %>%
  group_by(Developers) %>%
  filter(grepl("OpenAI|Google/Alphabet|Tesla|Facebook/Meta|Amazon|Microsoft|Others", Developers)) %>%
  summarise(NumberofIncidents = sum(grepl("Incident", Type))) %>%
  ggplot(aes(x = Developers, y = NumberofIncidents, fill = Developers)) +
  geom_col(color = 'black') +
  labs(title = "Number of Incidents by Developer", y = "Number of Incidents") +
  theme(axis.text.x = element_blank(), axis.title.x = element_blank())

 
  
  




