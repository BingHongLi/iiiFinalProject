library(shiny)
### Loading slow
ALLPRICE <- read.csv('./data/SPrice.csv')
ALLPROFILE <- read.csv('./data/SProfile.csv')
cluster_1496 <- read.csv('./data/cluster_1496.csv')
### find Developer's game
FINDDEVELOPERPROFILE <- function(developerName,queryFile=ALLPROFILE){
  developerFile <- queryFile[queryFile[,5]==developerName,]
  developerFile
}

##fine game price history
FINDDEVELOPERGAMEPRICELIST <- function(gameName,queryFile,queryPrice=ALLPRICE){
  gameID <- as.character(queryFile[which(queryFile[,2]==gameName),1])
  priceHistory <- queryPrice[which(queryPrice[,1]==gameID),3]
  priceHistory
}


### Draw Curve
DRAWCURVE <- function(priceHisory){
  # TimeSerise Data
  priceTimeSeries <- ts(priceHisory)
  # Draw curve
  plot.ts(priceTimeSeries,col="red")
}

server <- function(input, output, session) {
  output$control1 <- renderUI({
    selectInput("developerName", "Select Developer Name", choices = levels(ALLPROFILE[['developer']]))
  })
  
  output$control2 <- renderUI({
    x <- input$developerName
    if (any(
      is.null(x)
    ))
      return("Select")
    choice2 <-as.character(ALLPROFILE[which(ALLPROFILE[['developer']] == x),2])
    selectInput("gameName", "Select Game Name", choices = choice2)
  })
  
  output$control3 <- renderUI({
      selectInput("clusterName", "Select cluster Name", choices = as.character(c(1:20)))
  })
  
  output$control4 <- renderUI({
      x <- input$clusterName
      if (any(
          is.null(x)
      ))
      selectInput("clusterGameName", "Select Game Name", choices = subset(cluster_1496['X'], cluster_1496['clara']==x))
  })
  output$plotTS <- renderPlot({
    # generate develper's profile
    developerFile<- FINDDEVELOPERPROFILE(input$developerName)
    
    # generate gamePrice's list
    priceHistory<- FINDDEVELOPERGAMEPRICELIST(input$gameName,developerFile)
    
    # draw
    drawCurve<- DRAWCURVE(priceHistory)
    drawCurve
  })
  
}

ui <- shinyUI(navbarPage("",
                         tabPanel("Price Trend",
                                  sidebarLayout(
                                      sidebarPanel(
                                          tabsetPanel("GameAnalysis",
                                                      title="PriceTrend",
                                                      type="pills",
                                                      tabPanel(
                                                          uiOutput("control1")
                                                      ),
                                                      tabPanel(
                                                          uiOutput("control2")
                                                      )                
                                          )
                                      ),
                                      mainPanel(
                                          plotOutput("plotTS")
                                      )
                                  )
                         ),tabPanel("Price Cluster",
                                    sidebarLayout(
                                        sidebarPanel(
                                            tabsetPanel("GameAnalysis",
                                                        title="PriceCluster",
                                                        type="pills",
                                                        tabPanel(
                                                            uiOutput("control3")
                                                        )
                                                        ,
                                                        tabPanel(
                                                            uiOutput("control4")
                                                        )
                                            )
                                        ),
                                        mainPanel(
                                            
                                        )
                                    )
                         ),
                         inverse = T, # 主題背景反轉
                         theme=NULL # 設置主題
))

shinyApp(ui = ui, server = server)