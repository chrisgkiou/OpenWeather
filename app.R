library(shiny)
library(httr)
library(jsonlite)

ui <- fluidPage(
  titlePanel("Current Weather"),
  sidebarLayout(
    sidebarPanel(
      textInput("city", "City", placeholder = "Enter city name"),
      textInput("country", "Country Code", placeholder = "Enter country code (e.g. US)"),
      submitButton("Get Weather")
    ),
    mainPanel(
      h4("Current Weather"),
      verbatimTextOutput("result")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$Get_Weather, {
    city <- input$city
    country <- input$country
    
    if (is.null(city) || city == "" || is.null(country) || country == "") {
      output$result <- "Shalo gamw to stoma sou"
      return()
    }
    
    # make API request
    url <- paste0("https://api.openweathermap.org/data/2.5/weather?q=", city, ",", country, "&units=metric&appid=YOUR_API_KEY")
    response <- GET(url)
    
    # parse JSON response
    weather <- content(response, "parsed")
    
    # display results
    if (weather$message == "city not found") {
      output$result <- paste("City not found. Please check your spelling and try again.")
    } else {
      temp <- weather$main$temp
      desc <- weather$weather[[1]]$description
      output$result <- paste("The current temperature in", city, "is", temp, "°C with", desc, ".")
    }
  })
}

shinyApp(ui = ui, server = server)

