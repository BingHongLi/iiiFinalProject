|--PythonETL 	
	|--DetermineTheStatus	判斷價格狀態程式 0無變化 1有降價 2有漲價
	|--MGameETL		MetaCritic.com 的內容爬取程式
	|--OFFER3    		樞紐轉換的程式

|--SQLServer
	|--Query
		|--SQLQueryClass1023		日期期間狀態的判斷程式
		|--SQLQuerydatediffcount	計算每個日期區間有幾筆特價記錄

	|--Scalar Function
		|--INIDOUTSNAME_ID	輸入ID輸出SNAME
		|--INSGNAMEOUTID_SGNAME	輸入SGNAME輸出ID
		|--INTINTEGER		判斷大於0的值
		|--SCORE_SCORE,ID	為了補齊SCORE，沒有的就使用評論分數的平均
		|--VACATION_DATE	判斷是否為假日

	|--Stored Procedure
		|--CLASSBIGTABLE	邏輯式回歸使用的大表 JOIN SGAMETAGTF, SLANGUAGES, ALLCLUSTER_1639, SPROFILE.SCORE
		|--CSATTR		邏輯式回歸使用的大表 JOIN 日期區間判斷, SGAMETAGTF, 
		|--GPHISTORY_ID,COM	輸入ID, company 輸出歷史價格資料
		|--IPLOGICDATE		邏輯式回歸使用的日期分開格式
		|--IPRICEVT		IPrice連接假期判斷
		|--MERGETABLE		MERGE TABLE WITH SGAMETAGTF,SLANGUAGES,PAMK_1639
		|--SPLOGICDATE		CREATION DATE TABLE WITH ID CONTROL
		|--AllScalarFunction	包含所有的function
