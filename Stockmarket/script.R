library(plyr)
library(dplyr)
library(reshape2)
library(stringr)
library(ggplot2)
library(caret)
library(RCurl)

asx300<-read.csv("asx300.csv", header=T)
asx300<-asx300[301:1,]
asx300$Date<-as.Date(asx300$Date, format = "%d/%m/%Y")
ggplot(asx300, aes(x=Date, y=Adj.Close)) + geom_line() + scale_x_date()
ggplot(asx300, aes(x=Date, y=Return)) + geom_line() + scale_x_date()



library(forecast)
basic.model<-forecast(asx300$Adj.Close[301:21], h=20)
plot(basic.model)
lines(asx300$Adj.Close[301:1])


library(ForeCA)
Omega(asx300$Return)

library(RCurl)
Total<-c(1:8)
i<-1
while(i<298){ 
Comps<-read.csv("ConstituentsExport.txt", header=T, sep="\t")
foo<-paste("http://real-chart.finance.yahoo.com/table.csv?s=", Comps$Symbol[i], 
".AX&d=7&e=22&f=2014&g=d&a=0&b=29&c=1988&ignore=.csv", sep = "")
x<-getURL(foo)
y<-read.csv(foo)
y$Company<-Comps$Symbol[i]
Total<-rbind(Total, y)
i<-i+1
Sys.sleep(1.5)
}

Total %>%
  group_by(Company) %>%
  group_size()
