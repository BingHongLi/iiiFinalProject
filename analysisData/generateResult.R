#### LYT's Function Require
allTags = readRDS('./data/allTags.RDS')
#install.packages('plyr')
library(plyr)

#### LBH's Function Require
#logisticRegressionModel <- readRDS('./data/getDay/logisticRegressionModel.RDS')
logisticRegressionModel<- readRDS('E:/ALLMETHODModel.RDS')

#install.packages('party')
library(party)

oGetClusterName = function(gameName, clusteringMethod = 'pamk_8'){
  v = list(gameName = gameName, clusterNumber = allTags[gameName, clusteringMethod], tag = allTags[gameName,c('GenreAction','Accounting','Action','Adventure','AnimationAndModeling','AudioProduction','Casual','DesignAndIllustration','EarlyAccess','Education','FreeToPlay','Indie','MassivelyMultiplayer','PhotoEditing','Racing','RPG','Simulation','Sports','Strategy','Utilities','VideoProduction','WebPublishing','SoftwareTraining')]) 
  return(v) 
}

nameToDay <- oGetClusterName('ageofempiresiiicompletecollection')

getDay <- function(listName,clusterMethod='pamk_8'){
  gameName=listName$gameName
  clusterNumber=listName$clusterNumber
  tag=listName$tag
  
  tempDataFrame <- data.frame()
  for(i in names(logisticRegressionModel[[clusterMethod]][[clusterNumber]])){
    probability <- predict(logisticRegressionModel[[clusterMethod]][[clusterNumber]][[i]],tag)
   
    tempDataFrame <- rbind(tempDataFrame,data.frame(modelName=i,probability=probability))
  } 
  
  tempDayString <- tempDataFrame[which(tempDataFrame[,2]==max(tempDataFrame[,2])),1][1]
  
  prob <- tempDataFrame[which(tempDataFrame[,2]==max(tempDataFrame[,2])),2][1]
  
  prob <- exp(prob)/(1+exp(prob))
  
  #print(tempDayProb)
  
  #print(tempDayString)
  day <- as.numeric(gsub("c","",tempDayString))
  #day <- as.numeric(gsub("d","",tempDayString))
  returnList <- list(gameName=gameName,clusterNumber=clusterNumber,day=day,prob=prob)
  
  return(returnList)
}

dayToDiscount <- getDay(nameToDay)

getDiscount <- function(listName, clusterMethod="pamk_7", class = 5, RDPath="./data/ForCRASHNew.csv", orgPDPath="./data/originprice.csv", wd="E:/R/TimeSeries"){
  gameName = listName$gameName
  clusterNumber = listName$clusterNumber
  day = listName$day
  prob = listName$prob
  
  tsStart=2
  start=1  
  
  setwd(wd)
  srcData = read.csv(RDPath, header=T, sep=",")  
  orgPData = read.csv(orgPDPath, header=T, sep=",")   
  
  #srcData[row of record in the cluster, col with game's name and time series]
  rawData <- srcData[which(srcData[clusterMethod] == clusterNumber), c(1, 115:ncol(srcData))]  
  
  #Create the col "orgPrice" as for data processing.
  orgPrice <- rep(NA, nrow(rawData)) #Create a vector of orgPrice(original price) as the column in fullData.
  fullData <- cbind(orgPrice, rawData) 
  for(i in 1:nrow(fullData)){ 
    rowInOrgPD = which(orgPData[,1] == as.character(fullData[i,2])) #Catch the row number which has record in data of original price.
    fullData[i ,1] = orgPData[rowInOrgPD ,2] #Put the original price value into fullData.
  }    
  
  cut <- na.omit(cbind(fullData["orgPrice"] ,fullData[,(tsStart+start):(tsStart+day)])) #Combine the orgPrice with time interval for analyzing, and remove the record with NA.  
  
  #cut[ncol(cut)] / cut["orgPrice"]: Calculate the discount of each time series from the final record.
  #Put the result into the discount vector as nominal label for analyzation.
  discount <- NULL  
  for (dis in (cut[ncol(cut)] / cut["orgPrice"])){
    if(!is.null(dis) && !is.na(dis)){  #If the input value is missing or null then return NA/NULL.
      dis = as.numeric(dis)
      dis = round(dis, 2) * 100 #Transfer the value to percentage.
      remainder = dis %% class #Caculate the remainder.
      if(floor(class/2)+1 > remainder && remainder > 0) #If the reminder < (class/2)+1  (approach 0)
        dis = floor(dis / class) * class #Classify to previous class.
      if(class > remainder && remainder >= floor(class/2)+1) #If the reminder > (class/2)+1  (approach next class)
        dis = floor(dis / class) * class + class #Classify to next class.
      dis = as.character(dis / 100) #Transfer the number to character.
    }
    discount <- c(discount, dis)
  }  
  forAnalyze <- data.frame(cbind(discount, cut[,-1])) #Remove the original price from table of cut, and combine with discount as Classfied ID.
  
  ct <- ctree(discount~., data=forAnalyze, controls=ctree_control(minsplit=30, minbucket=10, maxdepth=25))
  #plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))
  
  #Catch the game data and use the classification model to predict.
  gameData <- cbind(discount=NA, rawData[which(rawData[1] == gameName),-1])
  pDiscount <- predict(ct, newdata=gameData)
  
  result <- list(gameName=gameName, discount=as.character(pDiscount), day=day, prob=prob)
  return(result)
}

discountToResult <- getDiscount(dayToDiscount)

getAll<- function(gameName,clusterMethod='pamk_8'){
  oGCList<- oGetClusterName(gameName,clusteringMethod = clusterMethod)
  gDayList <- getDay(oGCList,clusterMethod=clusterMethod)
  gDisCountList <- getDiscount(gDayList,clusterMethod=clusterMethod)
  gDisCountList
}

unitTest <- getAll('ageofempiresiiicompletecollection')

createDetailDataFrame <- function(clusterMethod){
  resultList <- list()
  j <- 0
  tempDataFrame <- data.frame()
  for(i in rownames(allTags)){
    resultList[[i]] <- getAll(i,clusterMethod=clusterMethod)
    j <- j+1
    print(j) 
  }
  gameName <- c()
  discount <- c()
  day <- c()
  prob <- c()
  for( i in 1:length(resultList)){
    gameName <- c(gameName,resultList[[i]][[1]])
    discount <- c(discount,resultList[[i]][[2]])
    day <- c(day,resultList[[i]][[3]])
    prob <- c(prob,resultList[[i]][[4]])
    print(prob)
  }
  tempDataFrame <- data.frame()
  tempDataFrame <- cbind(gameName,discount,day,prob)
  tempDataFrame
  #combineDataFrame <- read.csv('./data//toShinyServer/gameDetail.csv')
  #finalDataFrame <- cbind(sgamename = tempDataFrame[,1],combineDataFrame['gamename'],tempDataFrame[,2:3],combineDataFrame['origin'], logisticRegressionProbability = tempDataFrame[,4])
  #write.csv(finalDataFrame,paste(clusterMethod, '_finalDataFrame.csv'))
  #finalDataFrame
}

# for (i in colnames(allTags)[51:90]){
#   createDetailDataFrame(i)
# }
