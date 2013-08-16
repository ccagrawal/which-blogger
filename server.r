source("predict.r", local = TRUE)

shinyServer(function(input, output, session) {
  
  # Increment view count
  views <- as.numeric(read.table("viewFile.txt", header = FALSE)[1, 1]) + 1
  write(views, file = "viewFile.txt")
  
  # Output view count
  output$count <- renderText({
    paste("Views:", views, sep = " ")
  })
  
  # Create data frame to hold probabilities for each writer
  writers <- data.frame(c("Chirag", "Nakul", "Aaras", "Shrinidhi", "Anuj", "Mihir", "Reena", "Ruchi", "Ankit", "Elina"))
  colnames(writers) <- c("name")
  
  # Create probability columns
  writers$probability <- .1
  writers$likelihood <- 0
  writers$normalized <- .1
  
  # Load up dicts
  char.dict <- read.csv("~/ShinyApps/which-blogger/char_dict.txt", sep = ",")
  char.dict$X <- NULL
  word.dict <- read.csv("~/ShinyApps/which-blogger/word_dict.txt", sep = ",")
  word.dict$X <- NULL
  
  # Do not update right at beginning
  initialUpdate <- FALSE
  
  observe({
    #invalidateLater(2000, session)
    writers <- predict.writer(input$inputText, writers, char.dict, word.dict)
    
    if (!initialUpdate && (nchar(input$inputText) > 1)) {
      initialUpdate <<- TRUE
    }
    
    if (initialUpdate) {
      session$sendCustomMessage(
        type = "updateChart", 
        message = list(
          chirag = writers[1, 4],
          nakul = writers[2, 4],
          aaras = writers[3, 4],
          shrinidhi = writers[4, 4],
          anuj = writers[5, 4],
          mihir = writers[6, 4],
          reena = writers[7, 4],
          ruchi = writers[8, 4],
          ankit = writers[9, 4],
          elina = writers[10, 4]
        )
      )
    }
  })
})