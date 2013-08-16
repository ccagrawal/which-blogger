process.data <- function(writer.name, file.location) {
  
  # Search for dicts
  char.dict.location <- "/Users/Chirag/Documents/Dropbox/Programming/2013-08/Which_Blogger/char_dict.txt"
  word.dict.location <- "/Users/Chirag/Documents/Dropbox/Programming/2013-08/Which_Blogger/word_dict.txt"
  
  # Create dict data frames if it does not exist
  # Read in dict data frames if it does exist
  if (file.exists(char.dict.location) == FALSE) {
    char.dict <- data.frame(as.character(0), stringsAsFactors = FALSE)
    char.dict$col <- 0
    colnames(char.dict) <- c("char", writer.name)
    
    word.dict <- data.frame(as.character(1), stringsAsFactors = FALSE)
    word.dict$col <- 0
    colnames(word.dict) <- c("len", writer.name)
  } else {
    char.dict <- read.csv(char.dict.location, sep = ",")
    char.dict$char <- as.character(char.dict$char)
    char.dict$X <- NULL
    
    word.dict <- read.csv(word.dict.location, sep = ",")
    word.dict$len <- as.numeric(word.dict$len)
    word.dict$X <- NULL
  }
  
  # Create author column if it does not exist
  # Get author column index if it does exist
  if (length(which(colnames(char.dict) == writer.name)) == 0) {
    char.dict$new <- 0
    colnames(char.dict)[ncol(char.dict)] <- writer.name
    column <- ncol(char.dict)
    
    word.dict$new <- 0
    colnames(word.dict)[ncol(word.dict)] <- writer.name
    column <- ncol(word.dict)
  } else {
    column <- which(colnames(char.dict) == writer.name)
  }
  
  # Read all text from input file
  original <- readChar(file.location, file.info(file.location)$size)
  text <- original
  
  # Modify text to consolidate similar characters
  text <- gsub("[a-z]", "a", text)              # Make all lowercase letters a's
  text <- gsub("[A-Z]", "A", text)              # Make all uppercase letters A's
  text <- gsub("\\d+", "0", text)               # Make all numbers 0's
  text <- gsub("\n", " ", text)                 # Change new lines to spaces
  text <- gsub("–", "-", text)                  # Change en dashes to hyphens
  text <- gsub("—", "-", text)                  # Change em dashes to hyphens
  text <- gsub("'", "‘", text)                  # Change ugly apostrophe to open apostrophe
  text <- gsub("’", "‘", text)                  # Change close apostrophe to open apostrophe
  text <- gsub("″", "“", text)                  # Change ugly quote to open quote
  text <- gsub("”", "“", text)                  # Change close quote to open quote
  text <- gsub(")", "(", text)                  # Change close parenthesis to open parenthesis
  text <- gsub("]", "[", text)                  # Change close bracket to open bracket
  text <- gsub("}", "{", text)                  # Change close curly brace to open curly brace
  text <- gsub(">", "<", text)                  # Change greater than to less than
  text <- gsub("\\", "*", text, fixed = TRUE)   # Change forward slash to backslash
  text <- gsub("&", "*", text)                  # Change ampersand to asterisk
  text <- gsub("#", "*", text)                  # Change pound to asterisk
  text <- gsub("%", "*", text)                  # Change percent to asterisk
  text <- gsub("`", "*", text)                  # Change weird thing to asterisk
  text <- gsub("^", "*", text, fixed = TRUE)    # Change caret to asterisk
  text <- gsub("+", "*", text, fixed = TRUE)    # Change plus to asterisk
  text <- gsub("|", "*", text, fixed = TRUE)    # Change horizontal line to asterisk
  text <- gsub("<", "*", text)                  # Change less than to asterisk
  text <- gsub("=", "*", text)                  # Change equals to asterisk
  text <- gsub("@", "*", text)                  # Change at to asterisk
  text <- gsub("$", "*", text, fixed = TRUE)    # Change dollar to asterisk
  text <- gsub("[", "*", text, fixed = TRUE)    # Change open bracket to asterisk
  text <- gsub("{", "*", text, fixed = TRUE)    # Change open curly brace to asterisk
  
  
  # Split text into characters
  text <- strsplit(text, split = "")[[1]]
  
  # Input text from data file into dictionary
  for (index in 1:length(text)) {
    char <- text[index]
    row <- which(char.dict$char == char)
    if (length(row) > 0) {	# If key exists, increment count
      char.dict[row, column] <- char.dict[row, column] + 1
    } else {		# If key does not exist, add new row with count = 1
      char.dict[nrow(char.dict) + 1, ] <- 0
      char.dict[nrow(char.dict), 1] <- char
      char.dict[nrow(char.dict), column] <- 1
    }
  }
  
  # Reload text
  text <- original
  
  # Modify text to consolidate similar characters
  text <- gsub("'", "", text)                  # Change ugly apostrophe to blank
  text <- gsub("’", "", text)                  # Change close apostrophe to blank
  text <- gsub("‘", "", text)                  # Change open apostrophe to blank
  text <- gsub("[^a-zA-Z]", " ", text)         # Remove everything but letters
  
  # Split text into words
  text <- strsplit(text, split = " ")[[1]]
  
  # Remove words that are 0 characters wrong
  text <- text[nchar(text) > 0]
  
  # Input text from data file into dictionary
  for (index in 1:length(text)) {
    word <- text[index]
    row <- which(word.dict$len == nchar(word))
    if (length(row) > 0) {  # If key exists, increment count
      word.dict[row, column] <- word.dict[row, column] + 1
    } else {		# If key does not exist, add new row with count = 1
      word.dict[nrow(word.dict) + 1, ] <- 0
      word.dict[nrow(word.dict), 1] <- nchar(word)
      word.dict[nrow(word.dict), column] <- 1
    }
  }
  
  # Alphabetize dicts
  word.dict <- word.dict[order(word.dict$len), ]
  char.dict <- char.dict[order(char.dict$char), ]
  
  # Write dicts
  write.csv(char.dict, char.dict.location)
  write.csv(word.dict, word.dict.location)
}

names <- c("Aaras", "Ankit", "Anuj", "Chirag", "Elina", "Mihir", "Nakul", "Reena", "Ruchi", "Shrinidhi")
for (i in 1:length(names)) {
  writer.name <- names[i]
  file.location <- paste("/Users/Chirag/Documents/Dropbox/Programming/2013-08/Which_Blogger/Wordpress/", 
                         tolower(writer.name), ".txt", sep = "")
  process.data(writer.name, file.location)
}