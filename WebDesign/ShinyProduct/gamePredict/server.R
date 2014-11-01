library(shiny)
library(rCharts)
gameDetail =  readRDS('./data/gameDetail.RDS')
allPrice =  readRDS('./data/allPrice.RDS')
allTags =  readRDS('./data/allTags.RDS')

library(plyr)
nGetClusterName = function(tags,clusteringMethod = 'pamk_7'){
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

shinyServer(function(input, output, session) {
  output$control1 <- renderUI({
    selectInput("gameName", "Select Game Name", choices = as.character(gameDetail[['gamename']]))
  })
  
  output$returnUserInputPrice <- renderText({
      paste("Input:",input$userInputPrice)
  })
  
  output$GameForecastingText <- renderUI({
      gameName = gameDetail[gameDetail['gamename'] == input$gameName][1]
      gameDiscount = gameDetail[gameDetail['gamename'] == input$gameName][3]
      gameForecastDay = gameDetail[gameDetail['gamename'] == input$gameName][4]
      gameOriginPrice = gameDetail[gameDetail['gamename'] == input$gameName][5]
      gameProbability = gameDetail[gameDetail['gamename'] == input$gameName][6]
      if(gameDiscount > 1) gameDiscount = 1
      paste('discount : ', gameDiscount, 'Days : ', gameForecastDay)
      gameForecastingDiscountPrice = as.double(gameOriginPrice) * as.double(gameDiscount)
      if(gameProbability < 0.6)
          return(HTML(paste('<div style="color:#F5F5F5;font:bold 25px Tahoma>', sprintf('%s will stay fixed', 'Prices') ,"</div>"))) 
      else if(allPrice[[gameName]][length(allPrice[[gameName]])] > gameForecastingDiscountPrice)
          return(HTML(paste('<div style="color:#008B00;font:bold 25px Tahoma">', sprintf('There will be a price reduction in %s days &darr;', gameForecastDay) ,"</div>"))) 
      else if(allPrice[[gameName]][length(allPrice[[gameName]])] < gameForecastingDiscountPrice)
          return(HTML(paste('<div style="color:#FF4500;font:bold 25px Tahoma">', sprintf('There will be a price raise in %s days &uarr;', gameForecastDay) ,"</div>"))) 
      else
          return(HTML(paste('<div style="color:#F5F5F5;font:bold 25px Tahoma>', sprintf('%s will stay fixed', 'Prices') ,'</div>'))) 
  })
  
  output$plotTS <- renderChart2({
     gameName = gameDetail[gameDetail['gamename'] == input$gameName][1]
     priceHistory<- allPrice[[gameName]]
     #if(length(priceHistory) >= 300)
     #    priceHistory = priceHistory[1:300]
     #drawCurve<- plot(ts(priceHistory))
     h1 <- Highcharts$new()
     h1$chart(type = "spline")
     h1$series(data = priceHistory, dashStyle = "shortdot")
     h1$legend(symbolWidth = 80)
     h1$xAxis(title=list(text='days'),style=list(fontsize='20px'))
     h1$yAxis(title=list(text='price'),style=list(fontsize='20px'))
     return(h1)
  })
  
  output$newGameDiscount <- renderUI({
      tryCatch({
          selectTags <- nGetClusterName(input$selectTags)
          
          gameName_Tag = selectTags$gameName[length(selectTags$gameName)]
          newGameDiscount = gameDetail[gameDetail['sgamename'] == gameName_Tag][3]
          newGameForecastDay = gameDetail[gameDetail['sgamename'] == gameName_Tag][4]
          newGameOriginPrice = gameDetail[gameDetail['sgamename'] == gameName_Tag][5]
          newGameProbability = gameDetail[gameDetail['sgamename'] == gameName_Tag][6]

          paste('discount : ', newGameDiscount, 'Days : ', newGameForecastDay)
          if(newGameDiscount > 1) newGameDiscount = 1
          
          gameForecastingDiscountPrice = as.double(newGameOriginPrice) * as.double(newGameDiscount)
          if(newGameProbability < 0.6)
              return(HTML(paste('<div style="color:#F5F5F5;font:bold 25px Tahoma>', paste('Prices will stay fixed'),"</div>")))
          else if(allPrice[[gameName_Tag]][length(allPrice[[gameName_Tag]])] > gameForecastingDiscountPrice)
              return(HTML(paste('<div style="color:#008B00;font:bold 25px Tahoma">', sprintf('There will be a price reduction in %s days &darr;', newGameForecastDay) ,"</div>")))
          else if(allPrice[[gameName_Tag]][length(allPrice[[gameName_Tag]])] < gameForecastingDiscountPrice)
              return(HTML(paste('<div style="color:#FF4500;font:bold 25px Tahoma">', sprintf('There will be a price raise in %s days &uarr;', newGameForecastDay) ,"</div>")))
          else
              return(HTML(paste('<div style="color:#F5F5F5;font:bold 25px Tahoma>', paste('Prices will stay fixed'),"</div>")))
      },error = function(e) {
          return(HTML(paste('<div style="color:#F5F5F5;font:bold 25px Tahoma>', paste('Prices will stay fixed'),"</div>")))
      })
  })
  
  output$plotNewGameTS <- renderChart2({
      tryCatch({
          selectTags <- nGetClusterName(input$selectTags)
          gamePlot = selectTags$gameName[length(selectTags$gameName)]
          priceHistory = allPrice[[gamePlot]]
          #if(length(priceHistory) >= 150)
          #    priceHistory = priceHistory[1:150]
          #plot(ts(priceHistory))
          h1 <- Highcharts$new()
          h1$chart(type = "spline")
          h1$series(data = priceHistory, dashStyle = "shortdot")
          h1$legend(symbolWidth = 80)
          return(h1)
      },error = function(e) {
          " "
      })
  })
  
})