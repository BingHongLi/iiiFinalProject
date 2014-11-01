# This is a textmining example from RDM and I add some Illustration in the file.
# install package about text mining and twitter
# I will introduce text mining by using example about twitter
install.packages("http://cran.r-project.org/src/contrib/Archive/Snowball/Snowball_0.0-11.tar.gz", repos = NULL, type="source")
install.packages(c("tm","twitteR","SnowballC",'RWeka','RWekajars','ggplot2','fpc'))
library(tm)
library(twitteR)
library(Snowball)
# We will get a list after load rdmTweets.RData
load("D:/Dropbox/R/rdmTweets-201306.RData")

# show the data contents
tweets[1:3]

### 1.Transform

## convert tweets to a data frame
# 將type為list的rdmTweets的每一筆資料轉成data.frame形式
# 再採用列合併，一列即為一篇文章
df <- do.call('rbind',lapply(tweets,as.data.frame))

# 筆數、欄位
dim(df)

# 使用tm包中的Corpus與VectorSource
## build a corpus, and specify the source to be character vectors
# 將所有文章拆成詞，轉作詞庫，
# 可用fix(myCorpus)觀察
myCorpus <- Corpus(VectorSource(df$text))

## After that, the corpus needs a couple of transformations, 
## including changing letters to lower case, removing punctuations/numbers and removing stop words. 
## The general English stop-word list is tailored by adding "available" and "via" and removing "r"and "big" (for big data). 
## Hyperlinks.are also removed in the example below.
# 在作英文探勘的時候，需要先作文字處理，如將文字全轉為小寫，移除標點符號及結束用字，
# 如available,via,r and big,包括超連結也是要被移除的

## convert to lower case
# 轉為小寫
#myCorpus <- tm_map(myCorpus, tolower) tm0.6版不適用
myCorpus <- tm_map(myCorpus, content_transformer(tolower))


## remove punctuation
# 移除標點符號
myCorpus <- tm_map(myCorpus, removePunctuation)

## remove numbers
# 移除數字
myCorpus <- tm_map(myCorpus, removeNumbers)

## remove URLs
# 先自寫一個函數removeURL，用作移除url,gsub為替換字串，gsub('要被替換字串','替代用字串','資料來源')
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
# 替換
myCorpus <- tm_map(myCorpus, removeURL)

## add two extra stop words: "available" and "via"
# 在經常性詞的對照庫中加入兩個單字available,via
myStopwords <- c(stopwords('english'), "available", "via")

## remove "r" and "big" from stopwords
# 從經常性詞的詞庫中剔除掉r與big兩個單字
myStopwords <- setdiff(myStopwords, c("r", "big"))

## remove stopwords from corpus
# 把文本內所有的經常性字詞移除 tm_map(資料來源，功能函數，對照詞庫)
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)


## In the above code, tm_map() is an interface to apply transformations (mappings) to corpora. 
## A list of available transformations can be obtained with getTransformations(), 
## and the mostly used ones are as.PlainTextDocument(), removeNumbers(), removePunctuation(), removeWords(),
## stemDocument() and stripWhitespace(). A function removeURL() is defined above to remove hypelinks, 
## where pattern "http[[:alnum:]]*" matches strings starting with \http" 
## and then followed by any number of alphabetic characters and digits. 
## Strings matching this pattern are removed with gsub(). 
## The above pattern is specified as an regular expression, 
## and detail about that can be found by running ?regex in R.
# tm_map()函數用來對詞庫作一些轉換的動作，包含了多種函數

### 2.Stemming Words
#因tm包的更新，無法使用stemming這段
#library(SnowballC)
#library(RWeka)
#library(rJava)
#library(RWekajars)

## keep a copy of corpus to use later as a dictionary for stem completion
# 在stemming化之前，先作備份
#myCorpusCopy <- myCorpus

## stem words
#myCorpus <- tm_map(myCorpus, stemDocument)

## inspect documents (tweets) numbered 11 to 15
# 觀察目前所切出來的字
#inspect(myCorpus[11:15])

## The code below is used for to make text fit for paper width
# 設定文字與版面的關係
#for (i in 11:15) {
#  cat(paste("[[", i, "]] ", sep=""))
#  writeLines(strwrap(myCorpus[[i]], width=73))
#}

## After that, we use stemCompletion() to complete the stems 
## with the unstemmed corpus myCorpusCopy as a dictionary.
## With the default setting, it takes the most frequent match in dictionary as completion.
# 對照未stem的的語料庫，挑出次數最多的完整單字
#myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=myCorpusCopy,lazy=T)

# 有些關鍵字會在對照時 被割成另外一些字，下兩行是以mining和miners作證明
## count frequency of "mining"
#miningCases <- tm_map(myCorpusCopy, grep, pattern="\\<mining")
#sum(unlist(miningCases))
## count frequency of "miners"
#minerCases <- tm_map(myCorpusCopy, grep, pattern="\\<miners")
#sum(unlist(minerCases))

## replace "miners" with "mining"
# 把miners 切換成mining
#myCorpus <- tm_map(myCorpus, gsub, pattern="miners", replacement="mining")


### 3.Building a Term-Document Matrix
# 建立詞庫出現次數矩陣

## function TermDocumentMatrix()
## A term-document matrix represents the relationship between terms and documents,
## where each row stands for a term and each column for a document, 
## and an entry is the number of occurrences of the term in the document.
## Alternatively, one can also build a document-term matrix by swapping row and column.
## With its default setting, terms with less than three characters are discarded. 
## To keep \r" in the matrix, we set the range of wordLengths in the example below
# 詞語─文檔矩陣TermDocumentMatrix() 列為字詞 行為文本編號 裡面的數字為字詞在文本內出現的次數
# 在英文領域上 字母數小於三的將不會被列入， 

#作矩陣的前置步驟
myCorpus <- tm_map(myCorpus, PlainTextDocument)
myTdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))

## As we can see from the above result, the term-document matrix is composed of 990 terms and
## 320 documents. It is very sparse, with 99% of the entries being zero. 
##We then have a look at the first six terms starting with \r" and tweets numbered 101 to 110.
#觀察 第101篇到110篇 myTdm 關鍵字為r開頭的前六項
idx <- which(dimnames(myTdm)$Terms == "r")
inspect(myTdm[idx+(0:5),101:110])

### 4.Frequent Terms and Associations
## We have a look at the popular words and the association between words. 
## Note that there are 154 tweets in total
## inspect frequent words
#從矩陣裡，找出最少出現10次的字
findFreqTerms(myTdm, lowfreq=10)

## To show the top frequent words visually, we next make a barplot for them. 
## From the termdocument matrix, we can derive the frequency of terms with rowSums(). 
## Then we select terms that appears in ten or more documents and shown them with a barplot using package ggplot2
## In the code below, geom="bar" species a barplot and coord_flip() swaps x- and y-axis.
## clearly shows that the three most frequent words are r, data and mining
# 將term在每一篇文本發生的次數總合起來
termFrequency <- rowSums(as.matrix(myTdm))
# 抽出發生十次以上的
termFrequency <- subset(termFrequency, termFrequency>=10)
# 植入繪圖套件
library(ggplot2)
# 轉放入data.frame 設兩個欄位 弟一個欄位是term的名字 第二個是次數
df <- data.frame(term=names(termFrequency), freq=termFrequency)
ggplot(df, aes(x=term, y=freq)) + geom_bar(stat="identity") + xlab("Terms") + ylab("Count") + coord_flip()
#將圖轉換方向
#barplot(termFrequency, las=2)

## We can also nd what are highly associated with a word with function findAssocs(). 
## Below we try to nd terms associated with r (or mining) with correlation no less than 0.25, 
## and the words are ordered by their correlation with r (or mining).
# 找出關鍵字間的關連
## which words are associated with "r"?
# 找出與r相關連的字詞
findAssocs(myTdm, 'r', 0.25)
## which words are associated with "mining"?
# 找出與mining有相關連的字詞
findAssocs(myTdm, 'mining', 0.25)

### Word Cloud

## After building a term-document matrix, we can show the importance of words with a word cloud
## (also known as a tag cloud), which can be easily produced with package wordcloud 
## In the code below, we first convert the term-document matrix to a normal matrix, 
## and then calculate word frequencies. After that, 
## we set gray levels based on word frequency and use wordcloud() to make a plot for it. 
## With wordcloud(), the first two parameters give a list of words and their frequencies. 
## Words with frequency below three are not plotted, as specified by min.freq=3. 
## By setting random.order=F, frequent words are plotted first, 
## which makes them appear in the center of cloud. 
## We also set the colors to gray levels based on frequency. 
## A colorful cloud can be generated by setting colors with rainbow().
# 畫字詞雲，須先轉成一般矩陣，並計算字的出現次數 而後使用wordcloude畫出字雲
library(wordcloud)
# 將myTdm 轉成一般矩陣
m <- as.matrix(myTdm)
## calculate the frequency of words and sort it descendingly by frequency
# 計算出現次數，並且依照大小排列
wordFreq <- sort(rowSums(m), decreasing=TRUE)
# word cloud
set.seed(375) # to make it reproducible
#設定灰階深度
grayLevels <- gray( (wordFreq+10) / (max(wordFreq)+10) )
#灰階
wordcloud(words=names(wordFreq), freq=wordFreq, min.freq=3, random.order=F,colors=grayLevels)
#彩色
wordcloud(words=names(wordFreq),freq=wordFreq, scale=c(5,.2),min.freq=3, max.words=Inf, random.order=F,rot.per=.15,random.color=TRUE,colors=rainbow(7))

### word cluster
## We then try to find clusters of words with hierarchical clustering. Sparse terms are removed, 
## so that the plot of clustering will not be crowded with words. 
# 嘗試去為單字作階層式分群，並且將次數稀疏的字移除，如此一來圖便不會顯得擁擠
## Then the distances between terms are calculated with dist() after scaling. 
## After that, the terms are clustered with hclust() and the dendrogram is cut into 10 clusters. 
# 在量化之後，去使用dist()函式計算單字間距離，再使用hclust函數，此法預設切出十個clusters
## The agglomeration method is set to ward, which denotes the increase in variance when two clusters are merged. 
## Some other options are single linkage, complete linkage, average linkage, median and centroid.
## remove sparse terms
myTdm2 <- removeSparseTerms(myTdm, sparse=0.95)
m2 <- as.matrix(myTdm2)
## cluster terms
distMatrix <- dist(scale(m2))
fit <- hclust(distMatrix, method="ward")
plot(fit)
## cut tree into 10 clusters
rect.hclust(fit, k=10)
(groups <- cutree(fit, k=10))

## We can also see cluster on time series, R packages, parallel computing, R codes and
## examples, and tutorial and slides.
# 在時間序列裡一樣可看到分群方法，在R的套件parallel可看到例子與教學。

## Clustering Tweets with the k-means Algorithm
# 使用k-means演算法去對文章作分群
## We first try k-means clustering, which takes the values in the matrix as numeric. 
# 嘗試使用k-mean必須先將矩陣內的值以numerice型態儲存
## We transpose the term-document matrix to a document-term one. 
# 先做一個TF-IDF矩陣
## The tweets are then clustered with kmeans() with the number of clusters set to eight. 
# 在範例中，會使用kmean並且將群數設為8群
## After that, we check the popular words in every cluster and also the cluster centers. 
# 找出每一群中出現最多次的字，並且設為中心點
## Note that a fixed random seed is set with set.seed() before running kmeans(), 
## so that the clustering result can be reproduced. It is for the convenience of book writing,
## and it is unnecessary for readers to set a random seed in their code.
# 設定隨機種子 可設可不設

## transpose the matrix to cluster documents (tweets)
# 矩陣轉置
m3 <- t(m2)
## set a fixed random seed
set.seed(122)
## k-means clustering of tweets
k <- 8
kmeansResult <- kmeans(m3, k)
## cluster centers
# 顯示centers的數值到小數點後三位
round(kmeansResult$centers, digits=3)

## To make it easy to find what the clusters are about, 
## we then check the top three words in every cluster.
# 為使尋找方便，可檢查每一個群中出現最多次的前三個字詞
for (i in 1:k) {
   cat(paste("cluster ", i, ": ", sep=""))
   s <- sort(kmeansResult$centers[i,], decreasing=T)
   cat(names(s)[1:3], "\n")
   # print the tweets of every cluster
   # print(rdmTweets[which(kmeansResult$cluster==i)])
}
## From the above top words and centers of clusters, 
## we can see that the clusters are of different topics. 
# 從每一個群中的最高次數單字中，我們可以發現每一群都代表著不同主題
## For instance, cluster 1 focuses on R codes and examples, 
## cluster 2 on data mining with R, cluster 4 on parallel computing in R, 
## cluster 6 on R packages and cluster 7 on slides of time
## series analysis with R. We can also see that, all clusters, 
## except for cluster 3, 5 & 8, focus on R.
## Cluster 3, 5 & 8 are about general information on data mining and are not limited to R. 
## Cluster 3 is on social network analysis, 
## cluster 5 on data mining tutorials, and cluster 8 on positions for data mining research.
# 講述著每一個群代表的字


### Clustering Tweets with the k-medoids Algorithm
# 使用k-medoids Algorithm 作分群

## We then try k-medoids clustering with the Partitioning Around Medoids (PAM) algorithm,
# 嘗試分隔環繞物件法(PAM) 作資料群集
## which uses medoids (representative objects) instead of means to represent clusters. 
# 嘗試群集去找出代表群的均值
## It is more robust to noise and outliers than k-means clustering, 
# 此方法在相較k-means clustering 
## and provides a display of the silhouette plot to show the quality of clustering. 
## In the example below, we use function pamk() from package fpc [Hennig,2010], 
## which calls the function pam() with the number of clusters estimated by optimum averagesilhouette.

library(fpc)
## partitioning around medoids with estimation of number of clusters
pamResult <- pamk(m3, metric="manhattan")
## number of clusters identified
(k <- pamResult$nc)
pamResult <- pamResult$pamobject
# print cluster medoids
for (i in 1:k) {
  cat(paste("cluster", i, ": "))
  cat(colnames(pamResult$medoids)[which(pamResult$medoids[i,]==1)], "\n")
  ## print tweets in cluster i
  ## print(rdmTweets[pamResult$clustering==i])
}
# plot clustering result
layout(matrix(c(1,2),2,1)) # set to two graphs per page
plot(pamResult, color=F, labels=4, lines=0, cex=.8, col.clus=1,col.p=pamResult$clustering)
layout(matrix(1)) # change back to one graph per page
