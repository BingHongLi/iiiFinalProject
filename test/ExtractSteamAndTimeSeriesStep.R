library(forecast)
library(TTR)

# find Develpoer is EA
findEA <- function(x){
  allEA <- data.frame()
  for (i in 1:nrow(x)){
    if(x[i,5]=="Electronic Arts"){
      allEA <- rbind(allEA,x[i,])
    }
  }  
  allEA
}


#找出EA每一個遊戲的價格資料，並且rbind成一個data.frame
findEAPrice <- function(x){
  allEAPrice <- data.frame()
  for (i in 1:nrow(x)){
    if (x[i,1] %in% allEA[,1] ){
      allEAPrice <- rbind(allEAPrice,x[i,])
    }
  }
  allEAPrice
}

app_102820 <- allEAPrice[which(allEAPrice[,1]=="app_102820"),]

#此函數並不作使用，僅為註解
function(x,enterFrequency=1,forecastTime=10,entryLagMax=20){
  #x為數值向量，使用ts()時間序列化，再使用plot.ts繪製曲線圖
  xTimeSeries <- ts(x)
  plot.ts(xTimeSeries)
  
  #若此時間序列frequency是有季節性，則可使用decompose去剖析出trend、seasonal、error三個部份
  decompose(xTimeSeries)
  
  #未含對未來預測的簡單指數平滑
  xTimeSeriesHoltWinters <- HoltWinters(xTimeSeries,beta=F,gamma=F)
  plot.ts(xTimeSeriesHoltWinters)
  
  #含未來預測的簡單指數平滑
  xTimeSeriesHoltWintersForecast <- forecast.HoltWinters(xTimeSeriesHoltWinters,h=forecastTime)
  plot.forecast(xTimeSeriesHoltWintersForecast)
  
  #檢驗預測模型，須透過檢驗殘差去得知。
  acf(xTimeSeriesHoltWintersForecast$residuals,lag.max=entryLagMax)
  Box.test(xTimeSeriesHoltWintersForecast$residuals,lag=entryLaxMax,type="Ljung-Box")
  plot.ts(xTimeSeriesHoltWintersForecast$residuals)
}
