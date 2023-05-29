library(mirai)
library(shiny)
library(promises)

# as.promise.mirai S3 method
as.promise.mirai <- function(x) {
  promise(function(resolve, reject) {
    check <- function() {
      if (!unresolved(x)) {
        value <- .subset2(x, "data")
        if (is_error_value(value)) reject(value) else resolve(value)
      } else {
        later::later(check, delay = 0.1)
      }
    }
    check()
  })
}

# set 4 workers
daemons(n = 4L)

ui <- fluidPage(
  fluidRow(
    plotOutput("one"),
    plotOutput("two"),
  ),
  fluidRow(
    plotOutput("three"),
    plotOutput("four"),
  )
)

make_plot <- function(time) {
  Sys.sleep(time)
  runif(10)
}

.expr <- quote(make_plot(time))
.args <- list(make_plot = make_plot, time = 2.5)

server <- function(input, output, session) {
  output$one <- renderPlot({mirai(.expr = .expr, .args = .args) %...>% plot()})
  output$two <- renderPlot({mirai(.expr = .expr, .args = .args) %...>% plot()})
  output$three <- renderPlot({mirai(.expr = .expr, .args = .args) %...>% plot()})
  output$four <- renderPlot({mirai(.expr = .expr, .args = .args) %...>% plot()})
  session$onSessionEnded(stopApp)
}

shinyApp(ui = ui, server = server)
