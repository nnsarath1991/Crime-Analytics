# --------------------  -------------------- # 
# Author:  Sarathkumar Nachiappan Nallusamy
# Subject: Crime Analysis 
# Date:    September 2017
# --------------------  -------------------- # 

# clear memory 
rm(list=ls())

############################################################################
#
#   Import Data/Loading for arrest data
#
#############################################################################
library(lubridate)
library(dplyr)
library(sqldf)
library(e1071)
library(zoo)
library(RJSONIO)
library(ggmap)
library(data.table)

path <- '~/Documents/Masters/Data_science/ub_crime/'
source(paste(path, 'src/load.src.r', sep=''))
load.src(paste(path, 'src/', sep = ''))

#loading arrest data for 2011
arrest_2011 <- fread(paste(path,'data/Crime excel/','Arrests 2011.csv',
                           sep = ''), sep = "auto", header = "auto", 
                     na.strings = c("","NA"))
head(arrest_2011)
sapply(arrest_2011, function(x) sum(length(which(is.na(x)))))

#pre-processing1
#removing row-NAs
arrest <- clear_only_nas(arrest_2011)

head(arrest)
#pre-processing2 - removing row-NAs
arrest <- arrest[rowSums(!is.na(arrest)) > 8] #secnd removal of rows < 8 
arrest <- clear_only_nas(arrest)

#verified
sapply(arrest, function(x) sum(length(which(is.na(x)))))

#setting up colnames
colnames(arrest) <- c("name","dob","age","sex","race", 
                      "ethnicity","cd_no","arrest_date",
                      "description")

#check redacted while building the app but removing here 
# also making them corresponding vars
arrest <- arrest %>% 
  dplyr::mutate(dob = as.Date(dob, format = "%m/%d/%y"),
                sex = as.factor(sex),
                race = as.factor(race),
                ethnicity = as.factor(ethnicity),
                cd_no=as.factor(cd_no),
                arrest_date = as.Date(arrest_date, 
                               format = "%m/%d/%y")) %>%
  select(-c(name))

str(arrest)
