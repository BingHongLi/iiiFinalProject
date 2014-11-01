#### LYT's Function Require
allTags = readRDS('./data/allTags.RDS')
#install.packages('plyr')
library(plyr)

#### LBH's Function Require
logisticRegressionModel <- readRDS('./data/getDay/logisticRegressionModel.RDS')




#### oGetClusterName
### previous queryGame
### next getDay
oGetClusterName = function(gameName, clusteringMethod = 'pamk_7'){
  v = list(gameName = gameName, clusterNumber = allTags[gameName, clusteringMethod], tag = allTags[gameName,c('GenreAction','Accounting','Action','Adventure','AnimationAndModeling','AudioProduction','Casual','DesignAndIllustration','EarlyAccess','Education','FreeToPlay','Indie','MassivelyMultiplayer','PhotoEditing','Racing','RPG','Simulation','Sports','Strategy','Utilities','VideoProduction','WebPublishing','SoftwareTraining')]) 
  return(v) 
}



#### nGetClusterName
### previous userEntryTag
### next getDay
nGetClusterName = function(tags,clusteringMethod = 'pamk_7'){
  #library(plyr)
  matchGameNumber = function(tags){
    matchTags = c()
    lapply(tags, function(tag){
      matchTags <<- append(matchTags,which(allTags[tag]==1))
    })
    matchTags = count(matchTags)
    return(matchTags$x[matchTags$freq == max(matchTags$freq)])
  }
  matchGameNumbers = matchGameNumber(tags)
  matchGameClusters = count(allTags[[clusteringMethod]][matchGameNumbers])
  cluster = matchGameClusters$x[matchGameClusters$freq == max(matchGameClusters$freq)][1]
  gamesName = row.names(allTags)[allTags[[clusteringMethod]][matchGameNumbers]]
  returnTags = t(data.frame(boolean = rep(0,23), row.names = c('GenreAction','Accounting','Action','Adventure','AnimationAndModeling','AudioProduction','Casual','DesignAndIllustration','EarlyAccess','Education','FreeToPlay','Indie','MassivelyMultiplayer','PhotoEditing','Racing','RPG','Simulation','Sports','Strategy','Utilities','VideoProduction','WebPublishing','SoftwareTraining')))
  returnTags[,tags] = 1
  return(list(clusterNumber = cluster,gameName = unique(gamesName),tag = as.data.frame(returnTags)))
}

#####

#### getDay 
### previous oGetClusterName and nGetClusterName
### next getDiscount

## generate Test File to Examine function getDay
#test.frame <- data.frame(GenreAction=0,Accounting=0,Action=0,Adventure=0,AnimationAndModeling=0,AudioProduction=0,Casual=0,DesignAndIllustration=0,EarlyAccess=0,Education=0,FreeToPlay=0,Indie=0,MassivelyMultiplayer=0,Racing=0,RPG=0,Simulation=0,Sports=0,Strategy=0)
#forTestList <- list(gameName=c('aaa'),clusterNumber=1,tag=test.frame)
#logisticRegressionModel <- readRDS('./data/getDay/forTestLogisticPredict.RDS') #for test Function

getDay <- function(listName){
  gameName=listName$gameName
  clusterNumber=listName$clusterNumber
  tag=listName$tag
  
  tempDataFrame <- data.frame()
  for(i in names(logisticRegressionModel[[clusterNumber]])){
    probability <- predict(logisticRegressionModel[[clusterNumber]][[i]],tag)
    tempDataFrame <- rbind(tempDataFrame,data.frame(modelName=i,probability=probability))
  }
  
  tempDayString <- tempDataFrame[which(tempDataFrame[,2]==max(tempDataFrame[,2])),1][1]
  #print(tempDayString)
  day <- as.numeric(gsub("c","",tempDayString))
  #day <- as.numeric(gsub("d","",tempDayString))
  returnList <- list(gameName=gameName,clusterNumber=clusterNumber,day=day)
  
  return(returnList)
}

#unitTest <- getDay(forTestList)
#unitTest <- getDay(oGetClusterName('avadoniicorruption'))
#unitTest2 <- getDay(nGetClusterName(c('AudioProduction','Casual','DesignAndIllustration','EarlyAccess')))

