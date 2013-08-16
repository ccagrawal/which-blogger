source("elements.r", local = TRUE)

shinyUI(basicPage(
  headerPanel.2(
    "Which Blogger Are You? v0.9", 
    tags$head(
      tags$script(src = 'js/highcharts.js'),
      tags$script(src = 'js/highcharts-more.js'),
      tags$style(type="text/css", "textarea {width: 100%; resize: none}")
    )
  ),

  tags$br(),
  
  mainPanel.2(
    tags$p("This web app uses stylometric techniques to predict authorship",
           "of input text. More specifically, you can either type or paste",
           "some text into the box below, and this app will predict which",
           "Roundtable member is the author (or which Roundtable member's",
           "blog the writing most resembles). A naive Bayes classifier is",
           "used to predict the author."),
    
    tags$br(),
    tags$textarea(id="inputText", rows=8, cols=100, ""),
    
    tags$br(),
    tags$br(),
    tags$div(id="resultsChart", align="center"),
    tags$script(src = "initchart.js"),
    
#     tags$p("I created this web-app after", 
#            tags$a(href = "http://statcheck.wordpress.com/2013/05/30/monte-carlo-tennis/", "blogging"),
#            "about the subject. View the",
#            tags$a(href = "https://github.com/ccagrawal/tennis-sim", "source code"),
#            "on GitHub."),

    tags$br(),
    tags$h5(textOutput("count"))
  )
))