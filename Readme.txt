iiiProject
	CrawlerAndETL	爬蟲與ETL
		Steam
			Crawler
				all_steam_pages.py				抓取Steam美國網站上所有遊戲網頁的連結
				CrawlerLBHaboutXML2.py			藉由先前的連結檔案，抓取價格記錄與網頁內容
				CrawlerLBHaboutXMLFromUSA.py	抓取美國網站的所有價格記錄與網頁內容
				CrawlerLBHaboutXMLMoreThan18.py	抓取18禁的遊戲價格記錄與網頁內容
				CrawlerSteamPagesLinksLYT.py	抽出所有遊戲頁面連結
			Extrat	
				ExtractAllContent.py 			將所有抓下來的遊戲網頁進行抽取的動作(需修改檔案路徑)
				ExtractSubContent.py			將所有抓下來的遊戲補充包網頁進行抽取的動作(需修改檔案路徑)
				ExtractAllContentForTest.py		第二步驟的測試檔
				ExtractPriceHistory.py			將價格紀錄網頁擷取儲存成csv
				ExtractSteamTag.py				抽出該遊戲的所有遊戲標籤
			Transform
				OrganizeSteamPrice.py			將Steam的每天日期價格補齊
		IsThereAnyDeal
			CrawlerAndExtract
				historyAjaxs(inputIsHttpLink).py抓取歷史價格	
		MetaCritic
			MGameETL							MetaCritic.com 的內容爬取程式
			MContentCrawler.py					
			MGameLinkCrawler.py
			MNavLinkCrawler.py		
		PythonETL 	
			DetermineTheStatus					判斷價格狀態程式 0無變化 1有降價 2有漲價
			OFFER3    							樞紐轉換的程式
		SQLServer
			Query
				SQLQueryClass1023				日期期間狀態的判斷程式
				SQLQuerydatediffcount			計算每個日期區間有幾筆特價記錄
			Scalar Function
				INIDOUTSNAME_ID					輸入ID輸出SNAME
				INSGNAMEOUTID_SGNAME			輸入SGNAME輸出ID
				INTINTEGER						判斷大於0的值
				SCORE_SCORE,ID					為了補齊SCORE，沒有的就使用評論分數的平均
				VACATION_DATE					判斷是否為假日
			Stored Procedure
				CLASSBIGTABLE					邏輯式回歸使用的大表 JOIN SGAMETAGTF, SLANGUAGES, ALLCLUSTER_1639, SPROFILE.SCORE
				CSATTR							邏輯式回歸使用的大表 JOIN 日期區間判斷, SGAMETAGTF, 
				GPHISTORY_ID,COM				輸入ID, company 輸出歷史價格資料
				IPLOGICDATE						邏輯式回歸使用的日期分開格式
				IPRICEVT						IPrice連接假期判斷
				MERGETABLE						MERGE TABLE WITH SGAMETAGTF,SLANGUAGES,PAMK_1639
				SPLOGICDATE						CREATION DATE TABLE WITH ID CONTROL
				AllScalarFunction				包含所有的function

	HowToUse									分析方法與連結資料庫使用的R檔
	analysisData								資料分析 內含專題的時間序列分群、邏輯式迴歸與時間序列分類整合檔
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
		generateResult.R						計算結果，並以list型態回傳遊戲名、折扣數與天數(內含時間序列分群、邏輯式迴歸、時間序列分類)
		getDiscount.R							計算折扣數
		ourTreasure.R							尚未整合的generate.R 
		unitTest.RDS							用來測試各function的檔案	
	WebDesign									網頁作品，內含專題的作品
		ShinyProduct							專題作品
			gamePredict							遊戲價格預測作品
			analysisMD							部分研究方法體驗
	test										測試檔案
	