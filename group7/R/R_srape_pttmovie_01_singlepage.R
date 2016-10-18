library(XML)
library(httr)
library(bitops)
library(RCurl)

data11 = data.frame()
subUrlPath = "https://www.ptt.cc/bbs/movie/index4650.html"
temp       = getURL(subUrlPath, encoding="big5")
xmldoc     = htmlParse(temp)
author     = xpathSApply(xmldoc, "//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"author\", \" \" ))]", xmlValue)
title      = xpathSApply(xmldoc,"//div[@class=\"title\"]",xmlValue)
url        = xpathSApply(xmldoc, "//div[@class='title']/a//@href")
date       = xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
responseCount = xpathSApply(xmldoc, "//div[@class='nrec']", xmlValue)

title   <- gsub("\\n", "", title)
title   <- gsub("\\t", "", title)

allauthor = data.frame(author)
allurl    = data.frame(url)
alltitle  = data.frame(title)
alldate   = data.frame(date)
allresponseCount = data.frame(responseCount)

alldataFrame = data.frame(author,title,url,date,responseCount)
alldataBind = rbind(data11, alldataFrame)
write.table(alldataFrame, file = "movie4673.csv")
