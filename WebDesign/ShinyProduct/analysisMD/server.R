library(shiny)
require(rCharts)
library(rpart)
library(rpart.plot)
library(party)
### Loading slow
ALLPRICE <- read.csv('./data/SPrice.csv')
ALLPROFILE <- read.csv('./data/SProfile.csv')
CLUSTERPRICE = readRDS('./data/allPrice.RDS')
#CLUSTER1496 = read.csv('./data/CLUSTER_1496.csv')
ALLINONE<-read.csv('./data/allInOne.csv')
ALLCLUSTER <- read.csv('./data/forClassify.csv')

### find Developer's game
FIND_DEVELOPER_PROFILE <- function(developerName,queryFile=ALLPROFILE){
  developerFile <- queryFile[queryFile[,5]==developerName,]
  developerFile
}

### fine game price history
FIND_DEVELOPER_GAME_PRICELIST <- function(gameName,queryFile,queryPrice=ALLPRICE){
  gameID <- as.character(queryFile[which(queryFile[,2]==gameName),1])
  priceHistory <- queryPrice[which(queryPrice[,1]==gameID),3]
  priceHistory
}

### Draw Curve
DRAWCURVE <- function(priceHistory){
  # TimeSerise Data
  #priceTimeSeries <- ts(priceHistory)
  # Draw curve
  #plot.ts(priceTimeSeries)
  h1 <- Highcharts$new()
  h1$chart(type = "spline")
  h1$series(data = priceHistory, dashStyle = "shortdot")
  h1$legend(symbolWidth = 80)
  return(h1)
}

### Cluster Compare return a rpart's list
CLUSTERCOMPARE <- function(cluster1,cluster2){
  set.seed(4562)
  C1<- ALLCLUSTER[which(ALLCLUSTER[,3]==cluster1),]
  C1IND <- sample(1:nrow(C1),size=30)
  C1 <- C1[C1IND,]
  C2<- ALLCLUSTER[which(ALLCLUSTER[,3]==cluster2),]
  C2IND <- sample(1:nrow(C2),size=30)
  C2 <- C2[C2IND,]
  ALLCLUSTERATTR <- rbind(C1,C2)
  myFomula <- PAMK~Accounting+Adventure+Casual+Education+Indie+Racing+RPG+Simulation+Sports+Strategy+Utilities
  #myFomula <- CLARA~Accounting+Adventure+Casual+Education+Indie+Racing+RPG
  test_rpart <- rpart(myFomula,method="class",data=ALLCLUSTERATTR,control=rpart.control(minsplit=10))
  #plot(test_rpart)
  #text(test_rpart,use.n = TRUE, all=T)
  #rpart.plot(test_rpart)
}


GETDISCOUNT <- function(clusterNumber,day, clusterMethod="pamk_8", class = 5, RDPath="./data/ForCRASHNew.csv", orgPDPath="./data/originprice.csv"){

  tsStart=2
  start=1  
  
  #setwd(wd)
  srcData = read.csv(RDPath, header=T, sep=",")  
  orgPData = read.csv(orgPDPath, header=F, sep=",")   
  
  #srcData[row of record in the cluster, col with game's name and time series]
  rawData <- srcData[which(srcData[clusterMethod] == clusterNumber), c(1, 115:ncol(srcData))]  
  
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
  plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))
  
  #Catch the game data and use the classification model to predict.
  #gameData <- cbind(discount=NA, rawData[which(rawData[1] == gameName),-1])
  #pDiscount <- predict(ct, newdata=gameData)
  
  #result <- list(gameName=gameName, discount=as.character(pDiscount), day=day,prob=prob)
  #return(result)
}





shinyServer(function(input, output, session) {
  
  #############For control  ##########
  
  output$control1 <- renderUI({
    selectInput("developerName", "Select Developer Name", choices = levels(ALLPROFILE[['developer']]))
  })
  
  output$control2 <- renderUI({
    x <- input$developerName
    if (any(
      is.null(x)
    ))
      return("Select")
    choice2 <-as.character(ALLPROFILE[which(ALLPROFILE[['developer']] == x),2])
    selectInput("gameName", "Select Game Name", choices = choice2)
  })
  
  ### find Developer's game and draw curve
  output$plotTS <- renderChart2({
    # generate develper's profile
    developerFile<- FIND_DEVELOPER_PROFILE(input$developerName)
    
    # generate gamePrice's list
    priceHistory<- FIND_DEVELOPER_GAME_PRICELIST(input$gameName,developerFile)
    
    # draw
    drawCurve<- DRAWCURVE(priceHistory)
    drawCurve
    
  })
  
  ####################choose  cluster and Draw  #####################  
  
  output$control3 <- renderUI({
    selectInput("clusterName", "Select cluster Name", choices = c('Casual'=1,'Various'=2,'Simulati'=3,'Strategy'=4,'Indie'=5,'Utilitie'=6,'Adventure'=7,'Other'=8),selected=1)
  })
  
  output$control4 <- renderUI({
    #xx <- input$clusterName
    #if (any(
    #  is.null(xx)
    #))
    #  return("Select")
    selectInput("clusterGameName", "Select Game Name", choices = as.character(ALLINONE['sgamename'][,1][which(ALLINONE['PAMK']==input$clusterName) ]))
  })

  ### depend on your choice cluster and draw curve
  output$plotClusterTS <- renderChart2({
    drawCurve <- DRAWCURVE(CLUSTERPRICE[[input$clusterGameName]])
    drawCurve
    
  })
  
  
  ###############cluster  classify################
  
  output$control5 <- renderUI({
    selectInput("clusterNumber1", "Select Cluster Number", choices =c('Casual'=1,'Simulati'=3,'Strategy'=4,'Indie'=5,'Utilitie'=6,'Adventure'=7,'Other'=8),selected=1 )
  })
  
  output$control6 <- renderUI({
    selectInput("clusterNumber2", "Select other Cluster Number ", choices = c('Casual'=1,'Simulati'=3,'Strategy'=4,'Indie'=5,'Utilitie'=6,'Adventure'=7,'Other'=8),selected='Simulati')
  })
  
  ### draw decision tree
  
  output$plotCluster <- renderPlot({
    rpart.plot(CLUSTERCOMPARE(input$clusterNumber1,input$clusterNumber2))
  })
  
  
  #################################################
  output$control7 <- renderUI({
    selectInput("timeSeriesClassifyClusterName", "Select Cluster ", choices =c('Casual'=1,'Simulati'=3,'Strategy'=4,'Indie'=5,'Utilitie'=6,'Adventure'=7,'Other'=8),selected=1 )
  })
  
  output$control8 <- renderUI({
    numericInput("day",'Entry number',label='Enter ',value=180,min=1,max=800)
  })
    
  
  output$plotClusterClassify <- renderPlot({
      if(is.na(input$day) | length(input$day) == 0 | input$day > 700)
          GETDISCOUNT(input$timeSeriesClassifyClusterName,30)
      else
        GETDISCOUNT(input$timeSeriesClassifyClusterName,input$day)
      
  })
  
  
})