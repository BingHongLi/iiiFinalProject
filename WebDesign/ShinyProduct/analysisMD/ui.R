library(shiny)
library(rCharts)
library(rpart)
library(rpart.plot)
library(party)
shinyUI(navbarPage("",
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
                                    #plotOutput("plotTS")
                                    showOutput("plotTS", "highcharts")
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
                                      #plotOutput("plotClusterTS")
                                      showOutput("plotClusterTS", "highcharts")
                                  )
                              )
                   ), tabPanel("ClusterAnalysis",
                            sidebarLayout(
                                    sidebarPanel(
                                            tabsetPanel("ClusterAnalysis",
                                                  title="ClusterAnalysis",
                                                         type="pills",
                                                         tabPanel(
                                                            uiOutput("control5")
                                                         ),
                                                         tabPanel(
                                                            uiOutput("control6")
                                                         )    
                                                     )
                                                   ),
                                            mainPanel(
                                                       plotOutput("plotCluster")
                                            )
                             )
                                                 
                   ), tabPanel("timeSeriesClassify",
                               sidebarLayout(
                                 sidebarPanel(
                                   tabsetPanel("timeSeriesClassify",
                                               title="timeSeriesClassify",
                                               type="pills",
                                               tabPanel(
                                                 uiOutput("control7")
                                               ),
                                               tabPanel(
                                                 uiOutput("control8")
                                               )    
                                   )
                                 ),
                                 mainPanel(
                                   plotOutput("plotClusterClassify")
                                 )
                               )
                               
                   ),
                   inverse = T, 
                   theme=NULL
                   #theme='test.css' 
)
)