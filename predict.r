predict.writer <- function(original, writers, char.dict, word.dict) {
  
  if (nchar(original) == 0) {
    writers$probability <- .1
    writers$likelihood <- 0
    writers$normalized <- .1
    return(writers)
  }
  
  # Turn probabilities into logs
  writers$probability <- log(writers$probability)
  
  # Make copy of original text
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
  
  # Rotate through characters and calculate probability
  for (char.index in 1:length(text)) {
    char <- text[char.index]
    row <- which(char.dict$char == char)
    
    # Skip character if doesn't exist for any writer
    if (length(row) > 0) {
      
      # Calculate likelihoods for each writer
      for (writer.index in 1:nrow(writers)) {
        column <- which(colnames(char.dict) == writers[writer.index, 1])
        writers[writer.index, 3] <- char.dict[row, column] / sum(char.dict[, column])
      }
      
      # If likelihood = 0, just make it a bit smaller than the smallest one
      writers[writers$likelihood == 0, 3] <- min(writers[writers$likelihood > 0, 3]) * .95
      
      # Calculate posterior
      writers$probability <- writers$probability + log(writers$likelihood)
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
  
  # Rotate through words and calculate probability
  for (word.index in 1:length(text)) {
    word <- text[word.index]
    row <- which(word.dict$len == nchar(word))
    
    # Skip word if length doesn't exist for any writer
    if (length(row) > 0) {
      
      # Calculate likelihoods for each writer
      for (writer.index in 1:nrow(writers)) {
        column <- which(colnames(word.dict) == writers[writer.index, 1])
        writers[writer.index, 3] <- word.dict[row, column] / sum(word.dict[, column])
      }
      
      # If likelihood = 0, just make it a bit smaller than the smallest one
      writers[writers$likelihood == 0, 3] <- min(writers[writers$likelihood > 0, 3]) * .95
      
      # Calculate posterior
      writers$probability <- writers$probability + log(writers$likelihood)
    }
  }
  
  # Normalize probabilities for each writer
  # Use ratios, initialize first one as 1 and calculate other values
  writers[1, 4] <- 1
  for (index in 2:nrow(writers)) {
    writers[index, 4] <- exp(writers[index, 2] - writers[1, 2])
  }

  # Make probability hold updated probabilities
  # Make log likelihood and normalized back to 0
  writers$normalized <- writers$normalized / sum(writers$normalized)
  writers$probability <- .1
  writers$likelihood <- 0
  
  return(writers)
}