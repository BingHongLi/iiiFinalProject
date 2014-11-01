USE [Steam]
GO

--ALTHOUGH THERE IS NO FLEXIBILITY, 
--THIS STORED PROCEDURE INCORPORATES SGAMETAGTF, SLANGUAGES, ALLCLUSTER_1639, SPROFILE.SCORE, 
--BECOME A BIG TABLE, AS THE USE FOR LOGISTIC REGRESSION,
--JUST JOIN TO KICK OUT NULL VALUE
CREATE PROC [DBO].[CLASSBIGTABLE]
AS
SELECT F.[GAMENAME]	

	--USE OTHER CLASS AREA SO ANNOTATIONS OFF NEXT LINE
	--,F.[CLARA],F.[STEAMID]
	
	,[KMEANS8]
    ,[KMEANS10]
    ,[KMEANS20]
    ,[KMEANS50]
    ,[CLARA10]
    ,[CLARA13]
    ,[CLARA20]
    ,[CLARA50]
    ,[pamk6]
    ,[pamk7]
    ,[pamk8]
    ,[pamk15]
    ,[pamk20]
    ,[pamk25]
    ,[hclust8]
    ,[hclust20]
    ,[diana6]
    ,[diana8]
    ,[diana10]
    ,[diana15]
    ,[diana20]
	
	--TO KICK NULL SCORE ,USE FUNCTION [score_score,id]
	,[dbo].[score_score,id](p.score,f.[GAMENAME]) score
	,[GenreAction]
    ,[Accounting]
    ,[Action]
    ,[Adventure]
    ,[AnimationAndModeling]
    ,[AudioProduction]
    ,[Casual]
    ,[DesignAndIllustration]
    ,[EarlyAccess]
    ,[Education]
    ,[FreeToPlay]
    ,[Indie]
    ,[MassivelyMultiplayer]
    ,[PhotoEditing]
    ,[Racing]
    ,[RPG]
    ,[Simulation]
    ,[Sports]
    ,[Strategy]
    ,[Utilities]
    ,[VideoProduction]
    ,[WebPublishing]
    ,[SoftwareTraining]
	
	,[portuguese]
	,[german] 
	,[japanese] 
	,[spanish] 
	,[polish] 
	,[arabic] 
	,[swedish] 
	,[turkish] 
	,[romanian] 
	,[czech] 
	,[dutch] 
	,[korean] 
	,[portuguese-brazil] 
	,[danish] 
	,[bulgarian] 
	,[hungarian] 
	,[ukrainian] 
	,[french] 
	,[norwegian] 
	,[slovakian] 
	,[russian] 
	,[thai] 
	,[finnish] 
	,[traditional chinese] 
	,[greek] 
	,[simplified chinese] 
	,[english] 
	,[italian]


From forLeader f 
	JOIN SGameTagTF t on f.STEAMID = t.ID
	JOIN SLanguages l on f.STEAMID = l.ID
	JOIN ALLCLUSTER_1639 j on f.GAMENAME=j.sgamename 
	JOIN SProfile p on f.STEAMID = p.ID