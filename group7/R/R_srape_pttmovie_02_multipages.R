#rm(list=ls(all.names=TRUE))
#library
library(XML)
library(httr)
library(bitops)
library(RCurl)
Sys.setlocale(category = "LC_ALL", locale = "cht")

#preset variables
startNo = 4652
endNo   = 4652
alldata = data.frame()
subUrlPath = "https://www.ptt.cc/bbs/movie/index"

#for loop 1 
for(page in startNo:endNo){
  urlPath = paste(subUrlPath, page, ".html", sep='')  
  temp    = getURL(urlPath, encoding="big5")
  xmldoc  = htmlParse(temp)
  title   = xpathSApply(xmldoc, "//div[@class=\"title\"]",xmlValue)
  title   = gsub("\\n", "", title)
  title   = gsub("\\t", "", title)
  author  = xpathSApply(xmldoc, "//div[@class='author']", xmlValue)
  date    = xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
  responseCount = xpathSApply(xmldoc, "//div[@class='nrec']", xmlValue)
  path    = xpathSApply(xmldoc, "//div[@class='title']/a//@href")
  ErrorResult = tryCatch({
    subdata = data.frame(title, path, date)
    alldata = rbind(alldata, subdata)
  },warning = function(war){print(paste("WARNING!!!:  ", urlPath))
  },error   = function(err){print(paste("ERROR!!!:  ",urlPath))
  },finally = {print(paste("End Try&Catch", urlPath))
  })
}

write.table(alldata, file = "movie4652.csv")
subPath <- "https://www.ptt.cc"

for( i in 1:length(alldata[,1]) )
{
  ipath    = paste(subPath, alldata$path[i], sep='')
  print(ipath)
  content  = getURL(ipath, encoding = "big5")
  xmldoc   = htmlParse(content)
  article  = xpathSApply(xmldoc, "//div[@id=\"main-content\"]", xmlValue)
  
  
  filename = paste("./data/", i, ".csv", sep='')
  write.csv(article,filename)
}


