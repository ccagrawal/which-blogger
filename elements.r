headerPanel.2 <- function(title, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
    div(class="container", style="max-width: 800px", align="center",
        h1(title)
    )
  )
}

mainPanel.2 <- function(...) {
  div(class="container", style="max-width: 800px",
      ...
  )
}