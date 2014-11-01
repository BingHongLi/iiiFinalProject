function(allPrice){
	library(dtw)
	dtwOmitNA <-function (x,y)
	{
		a<-na.omit(x)
		b<-na.omit(y)
		return(dtw(a,b,distance.only=TRUE)$normalizedDistance)
	}

	## create a new entry in the registry with two aliases
	pr_DB$set_entry(FUN = dtwOmitNA, names = c("dtwOmitNA"))
	
	rm(x)
	rm(distanceMatrix)
	rm(scscAll)
	x = c()
	#建立dynamic time warping距離的距離矩陣
	distanceMatrix = matrix(0, nrow=length(allPrice), ncol=length(allPrice), byrow=T)
	foreach(i = 1:length(allPrice), .combine='rbind') %do%  { 
		print(i)
		yi = min(c(scale(allPrice[[i]])))
		foreach(j = 1:length(allPrice), .combine='c') %do% {
			if(j <= i){
				distanceMatrix[i,j] = 0
			}
			else{
				yj = min(c(scale(allPrice[[j]])))
				if(yi == 'NaN'){
					if(yj == 'NaN'){
						x = 0
						distanceMatrix[i,j] = x
					}
					else{
						x = dtwOmitNA(1, c(scale(allPrice[[j]])) - min(c(scale(allPrice[[j]]))) +1)
						distanceMatrix[i,j] = x
					}
				}
				else if(yj == 'NaN'){
					x = dtwOmitNA(c(scale(allPrice[[i]])) - min(c(scale(allPrice[[i]]))) +1, 1)
					distanceMatrix[i,j] = x
				}
				else{
					x = dtwOmitNA(c(scale(allPrice[[i]])) - yi +1,c(scale(allPrice[[j]])) - yj +1)
					distanceMatrix[i,j] = x
				}
			}
		}
	}
	
	colnames(distanceMatrix) = names(allPrice)[1:length(allPrice)]
	rownames(distanceMatrix) = names(allPrice)[1:length(allPrice)]
	save(distanceMatrix file = 'distanceMatrix.Rdata')
}


