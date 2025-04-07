library(shiny)
library(mirai)

flip_coin <- function(...) {
  Sys.sleep(0.1)
  as.logical(rbinom(n = 1, size = 1, prob = 0.501))
}

ui <- fluidPage(
  div("Is the coin fair?"),
  actionButton("task", "Flip 1000 coins"),
  textOutput("status"),
  textOutput("outcomes")
)

server <- function(input, output, session) {

  # Keep running totals of heads, tails, and task errors
  flips <- reactiveValues(heads = 0, tails = 0, flips = 0)

  # Button to submit a batch of coin flips
  observeEvent(input$task, {
    flips$flips <- flips$flips + 1000
    mirai_map(
      1:1000,
      flip_coin,
      .promise = \(x) {
        if (isTRUE(x)) flips$heads <- flips$heads + 1 else flips$tails <- flips$tails + 1
      }
    )
    "done"
  })

  # Print time and task status
  output$status <- renderText({
    invalidateLater(millis = 1000)
    time <- format(Sys.time(), "%H:%M:%S")
    sprintf("%s | %s flips submitted", time, flips$flips)
  })

  # Print number of heads and tails
  output$outcomes <- renderText(
    sprintf("%s heads %s tails", flips$heads, flips$tails)
  )

}

app <- shinyApp(ui = ui, server = server)

library(profvis)

profvis({
  with(daemons(8, dispatcher = FALSE), {
    # pre-load flip_coin function on all daemons for efficiency
    everywhere({}, flip_coin = flip_coin)
    runApp(app)
  })
})
