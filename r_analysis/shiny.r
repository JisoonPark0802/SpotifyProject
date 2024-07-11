# Install necessary packages
if (!require("shiny")) install.packages("shiny")
if (!require("DBI")) install.packages("DBI")
if (!require("RMySQL")) install.packages("RMySQL")
if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("plotly")) install.packages("plotly")

library(shiny)
library(DBI)
library(RMySQL)
library(dplyr)
library(ggplot2)
library(plotly)

# Connect to MySQL
con <- dbConnect(MySQL(), user = 'your_username', password = 'your_password', dbname = 'song_database', host = 'localhost')

# Fetch data
songs_data <- dbGetQuery(con, "SELECT * FROM songs")
albums_data <- dbGetQuery(con, "SELECT * FROM albums")
artists_data <- dbGetQuery(con, "SELECT * FROM artists")

dbDisconnect(con)


ui <- fluidPage(
  titlePanel("Spotify Song and Album Ratings"),
  sidebarLayout(
    sidebarPanel(
      selectInput("artist", "Select Artist:", choices = unique(artists_data$artist_name)),
      selectInput("album", "Select Album:", choices = NULL) # This will be updated based on the artist
    ),
    mainPanel(
      plotlyOutput("ratingsPlot")
    )
  )
)

server <- function(input, output, session) {
  
  # Update album
  observeEvent(input$artist, {
    artist_id <- artists_data$spotify_artist_id[artists_data$artist_name == input$artist]
    album_choices <- albums_data$album_title[albums_data$spotify_artist_id == artist_id]
    updateSelectInput(session, "album", choices = album_choices)
  })

  filtered_songs <- reactive({
    artist_id <- artists_data$spotify_artist_id[artists_data$artist_name == input$artist]
    album_id <- albums_data$spotify_album_id[albums_data$album_title == input$album & albums_data$spotify_artist_id == artist_id]
    songs_data %>% filter(spotify_album_id == album_id)
  })
  
  # Create plot
  output$ratingsPlot <- renderPlotly({
    custom_colors <- c("red", "blue", "green", "yellow", "black", "grey")
    p <- ggplot(filtered_songs(), aes(x = song_popularity, y = song_rating, color = album_title)) +
      geom_point(alpha = 0.7, size = 3) +
      geom_smooth(method = 'lm', se = FALSE, color = 'red') +
      scale_color_manual(values = custom_colors) +
      labs(title = 'Song Rating vs. Popularity Colored by Album', x = 'Song Popularity', y = 'Song Rating', color = 'Album') +
      theme_minimal() +
      theme(legend.position = "bottom", legend.title = element_blank()) +
      guides(color = guide_legend(nrow = 2))
    ggplotly(p)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
