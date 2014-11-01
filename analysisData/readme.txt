analysisData
	data
		getDay
			forTestLogisticPredict.RDS
			logisticRegressionModel.RDS
			Model.RDS
		oGetClusterName
			allGameName_Tags_ClusterNumber.RDS
		toShinyServer
			gameDetail.csv
		alltags.RDS
		ForCRASHNew.csv
		originprice.csv
		unitTest.RDS
		
	generateResult.R	計算結果，並以list型態回傳遊戲名、折扣數與天數(內含時間序列分群、邏輯式迴歸、時間序列分類)
	getDiscount.R		計算折扣數
	ourTreasure.R		尚未整合的generate.R 
	unitTest.RDS		用來測試各function的檔案