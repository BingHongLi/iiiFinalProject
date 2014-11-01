#install.packages('party')
#library(party)

getDiscount <- function(listName, clusterMethod="pamk_7", class = 5, RDPath="./data/ForCRASHNew.csv", orgPDPath="./data/originprice.csv", wd="E:/R/TimeSeries"){
  gameName = listName$gameName
  clusterNumber = listName$clusterNumber
  day = listName$day
  
  tsStart=2
  start=1  
  
  setwd(wd)
  srcData = read.csv(RDPath, header=T, sep=",")  
  orgPData = read.csv(orgPDPath, header=F, sep=",")   
  
  #srcData[row of record in the cluster, col with game's name and time series]
  rawData <- srcData[which(srcData[clusterMethod] == clusterNumber), c(1, 23:ncol(srcData))]  
  
  #Create the col "orgPrice" as for data processing.
  orgPrice <- rep(NA, nrow(rawData)) #Create a vector of orgPrice(original price) as the column in fullData.
  fullData <- cbind(orgPrice, rawData) 
  for(i in 1:nrow(orgPData)){ 
    rowInFD = which(fullData[,2] == as.character(orgPData[i,1])) #Catch the row number which has record in data of original price.
    fullData[rowInFD ,1] = orgPData[i ,2] #Put the original price value into fullData.
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
        x = floor(dis / class) * class #Classify to previous class.
      if(class > remainder && remainder >= floor(class/2)+1) #If the reminder > (class/2)+1  (approach next class)
        x = floor(dis / class) * class + class #Classify to next class.
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
  
  result <- c(gameName=gameName, discount=as.character(pDiscount), day=day)
  return(result)
}