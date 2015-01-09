rm(list=ls())


# Library install
#==================================
install.packages("lubridate")
library(lubridate)
install.packages("data.table")
library("chron")
library(plyr)


# set working directory
#==================================
setwd("H:/NVROI/Data/Hg comparison/GH/data")


# load GH Tekran data
#==================================
GHTekHg=read.csv('GH_Tekran_20131110_20141001.csv', comment.char="", as.is=TRUE)


# GHTekHg=read.csv("H:/NVROI/Data/Hg comparison/GH/data/GH_Tekran_20131110_20141001.csv")
# GHTekHg=read.xlsx('GH_Tekran_20131110_20141001.xlsx', sheetIndex = 3)


# Format DateTime
#==================================
## strptime needs character strings as input
GHTekHg$DateTime=strptime(GHTekHg$DateTime, format="%m/%e/%Y %H:%M")


# make data into data.table or time series ?
#==================================
# GHTekHgDT=data.table(GHTekHg)
# GHTekHgTS=ts(GHTekHg)


# average Tekran data by year, month, day
#==================================
#avgGEM=GHTekHg[,list(avg=mean(GHTekHg$GEM, na.rm=TRUE)),by=list(DateTime(as.POSIXct(GHTekHg$DateTime, format = "%m/%e/%Y")))]
# Average GEM
avgGEM=aggregate(GHTekHg['GEM'], format(GHTekHg["DateTime"], "%Y/%m/%e"), mean, na.rm=TRUE)
# Average GOM
avgGOM=aggregate(GHTekHg['GOM'], format(GHTekHg["DateTime"], "%Y/%m/%e"), mean, na.rm=TRUE)
# Average PBM
avgPBM=aggregate(GHTekHg['PBM'], format(GHTekHg["DateTime"], "%Y/%m/%e"), mean, na.rm=TRUE)
# Average RM
avgRM=aggregate(GHTekHg['RM'], format(GHTekHg["DateTime"], "%Y/%m/%e"), mean, na.rm=TRUE)
# Average RM_blank
avgRM_blank=aggregate(GHTekHg['RM_blank'], format(GHTekHg["DateTime"], "%Y/%m/%e"), mean, na.rm=TRUE)

#combines average data into one matrix
TekHg24Avg=cbind(avgGEM$DateTime,avgGEM$GEM,avgGOM$GOM,avgPBM$PBM,avgRM$RM,avgRM_blank$RM_blank)
colnames(TekHg24Avg)=c('Date','avg GEM','avg GOM','avg PBM','avg RM','avg RM-blank')


# load particulate Hg data
#==================================
# load TAPI Hg data, only keep the first 25 columns (the rest are NaN values)
GHPMHg=read.csv('Total Hg 2600 CEM TAPI BetaPlus filters.csv', comment.char="", as.is=TRUE)[,1:25]

# Format DateTime
#==================================
## strptime needs character strings as input
GHTekHg$DateTime=strptime(GHTekHg$DateTime, format="%m/%e/%Y %H:%M")


# load passive Hg data
#==================================


# merge files
###################################
# merge using lapply method
full_data=do.call("cbind",lapply(file_list, FUN="mean"(files){read.table(files,header=TRUE, sep="\t")})))[3])

# merge using plyr method
file_list=list.files("H:/NVROI/Data/Hg comparison/GH/data")
dataset=ldply(file_list, read.table, header=TRUE, sep="\t")
