CrawlerAndETL
	Steam
		Crawler
			all_steam_pages.py				���Steam��������W�Ҧ��C���������s��
			CrawlerLBHaboutXML2.py			�ǥѥ��e���s���ɮסA�������O���P�������e
			CrawlerLBHaboutXMLFromUSA.py	�������������Ҧ�����O���P�������e
			CrawlerLBHaboutXMLMoreThan18.py	���18�T���C������O���P�������e
			CrawlerSteamPagesLinksLYT.py	��X�Ҧ��C�������s��
		Extrat	
			ExtractAllContent.py 			�N�Ҧ���U�Ӫ��C�������i�������ʧ@(�ݭק��ɮ׸��|)
			ExtractSubContent.py			�N�Ҧ���U�Ӫ��C���ɥR�]�����i�������ʧ@(�ݭק��ɮ׸��|)
			ExtractAllContentForTest.py		�ĤG�B�J��������
			ExtractPriceHistory.py			�N������������^���x�s��csv
			ExtractSteamTag.py				��X�ӹC�����Ҧ��C������
		Transform
			OrganizeSteamPrice.py			�NSteam���C�Ѥ������ɻ�
	IsThereAnyDeal
		CrawlerAndExtract
			historyAjaxs(inputIsHttpLink).py������v����	
	MetaCritic
		MGameETL		MetaCritic.com �����e�����{��
	PythonETL 	
		DetermineTheStatus	�P�_���檬�A�{�� 0�L�ܤ� 1������ 2������
		OFFER3    		�ϯ��ഫ���{��
	SQLServer
		Query
			SQLQueryClass1023		����������A���P�_�{��
			SQLQuerydatediffcount	�p��C�Ӥ���϶����X���S���O��
		Scalar Function
			INIDOUTSNAME_ID	��JID��XSNAME
			INSGNAMEOUTID_SGNAME	��JSGNAME��XID
			INTINTEGER		�P�_�j��0����
			SCORE_SCORE,ID	���F�ɻ�SCORE�A�S�����N�ϥε��פ��ƪ�����
			VACATION_DATE	�P�_�O�_������
		Stored Procedure
			CLASSBIGTABLE	�޿覡�^�k�ϥΪ��j�� JOIN SGAMETAGTF, SLANGUAGES, ALLCLUSTER_1639, SPROFILE.SCORE
			CSATTR		�޿覡�^�k�ϥΪ��j�� JOIN ����϶��P�_, SGAMETAGTF, 
			GPHISTORY_ID,COM	��JID, company ��X���v������
			IPLOGICDATE		�޿覡�^�k�ϥΪ�������}�榡
			IPRICEVT		IPrice�s�������P�_
			MERGETABLE		MERGE TABLE WITH SGAMETAGTF,SLANGUAGES,PAMK_1639
			SPLOGICDATE		CREATION DATE TABLE WITH ID CONTROL
			AllScalarFunction	�]�t�Ҧ���function
