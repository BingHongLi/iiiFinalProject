ORIGINDATA <- read.csv('E:/noTrainNoTest.csv')

allPrice <- list()

#for (i in 1:length(levels(ORIGINDATA[,1])) ){
#  willComine <- levels(ORIGINDATA[,1])[i]
#  willComine <- c(willComine,ORIGINDATA[which(ORIGINDATA[,1]==levels(ORIGINDATA[,1])[i]),3])
#  
#  allPrice[[levels(ORIGINDATA[,1])[i]]] <- willComine
#}

for (i in 1:length(levels(ORIGINDATA[,1])) ){
  willComine <- c(ORIGINDATA[which(ORIGINDATA[,1]==levels(ORIGINDATA[,1])[i]),2])
  allPrice[[levels(ORIGINDATA[,1])[i]]] <- willComine
}

#############################
#for (i in 1:length(levels(ORIGINDATA[,1]))){  
#  if(length(allPrice[[i]])<1000){
#    allPrice[[i]] <- c(allPrice[[i]],rep(NA,1000-length(allPrice[[i]])))
#  }
#  
#}

bigDataFrame <- data.frame()

for (i in 1:length(levels(ORIGINDATA[,1]))){
  
  bigDataFrame <- rbind(bigDataFrame,allPrice[[i]])
  
}