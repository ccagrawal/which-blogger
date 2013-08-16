source("elements.r", local = TRUE)

shinyUI(basicPage(
  headerPanel.2(
    "Which Blogger Are You? v1.0", 
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
    
    tags$br(),
    tags$p("I created this web-app after", 
           tags$a(href = "http://ccagrawal.wordpress.com/2013/08/11/which-blogger-are-you/", "blogging"),
           "about the subject. View the",
           tags$a(href = "https://github.com/ccagrawal/which-blogger", "source code"),
           "on GitHub."),

    tags$h5(textOutput("count"))
  )
))