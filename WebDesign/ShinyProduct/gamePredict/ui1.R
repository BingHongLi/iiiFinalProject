library(shiny)
library(rCharts)
tags = c('GenreAction','Accounting','Action','Adventure','AnimationAndModeling','AudioProduction','Casual','DesignAndIllustration','EarlyAccess','Education','FreeToPlay','Indie','MassivelyMultiplayer','PhotoEditing','Racing','RPG','Simulation','Sports','Strategy','Utilities','VideoProduction','WebPublishing','SoftwareTraining')

shinyUI(navbarPage(title = "Forecasting and Analysis",
                   tabPanel("Game Trend Forecasting",
                            sidebarLayout(
                                sidebarPanel(
                                    tabsetPanel("GameForecasting",
                                                title="PriceTrend",
                                                type="pills",
                                                tabPanel(
                                                    uiOutput("control1")
                                                )     
                                    )
                                ),
                                mainPanel(
                                    uiOutput('GameForecastingText'),
                                    hr(),
                                    textInput('userInputPrice', label = "", value = ""),
                                    verbatimTextOutput('returnUserInputPrice'),
                                    hr(),
                                    showOutput("plotTS", "Highcharts")
                                    #plotOutput("plotTS")
                                )
                            )
                   ),tabPanel("Price Cluster",
                              sidebarLayout(
                                  sidebarPanel(
                                      tabsetPanel("GameAnalysis",
                                          title="PriceCluster",
                                          type="pills",
                                          tabPanel(
                                              selectizeInput(
                                                      "selectTags",
                                                      'Select Tags', 
                                                       choices = tags, 
                                                       multiple = TRUE
                                              )
                                          )
                                      )
                                  ),
                                  mainPanel(
                                      uiOutput("newGameDiscount"),
                                      tryCatch({
                                          showOutput("plotNewGameTS", "Highcharts")
                                      },error = function(e) {
                                          " "
                                      })
                                      #plotOutput("plotNewGameTS")
                                  )
                              )
                   ),
                   inverse = T
                   #,includeCSS('./www/shiny.css'),
                   #includeScript('./www/shiny.js')
                   #theme = NULL
)
)