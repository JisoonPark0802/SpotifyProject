# Install necessary packages
if (!require("dplyr")) install.packages("dplyr")
if (!require("GGally")) install.packages("GGally")
if (!require("ggplot2")) install.packages("ggplot2")

library(dplyr)
library(GGally)
library(ggplot2)

# Connect to MySQL
con <- dbConnect(MySQL(), user = 'your_username', password = 'your_password', dbname = 'song_database', host = 'localhost')

songs_data <- dbGetQuery(con, "SELECT * FROM songs")
albums_data <- dbGetQuery(con, "SELECT * FROM albums")
artists_data <- dbGetQuery(con, "SELECT * FROM artists")

dbDisconnect(con)

# Merge Data
songs_albums_data <- songs_data %>%
  left_join(albums_data, by = "spotify_album_id")

songs_albums_data <- songs_albums_data %>%
  rename(album_artist_id = spotify_artist_id.y, spotify_artist_id = spotify_artist_id.x)

songs_full_data <- songs_albums_data %>%
  left_join(artists_data, by = c("album_artist_id" = "spotify_artist_id"))

pair_plot_data <- songs_full_data %>%
  select(song_popularity, song_rating, song_danceability, song_energy, song_acousticness, song_valence)

# Pair plot
pair_plot <- ggpairs(pair_plot_data, 
                     title = "Pair Plot of Song Features",
                     lower = list(continuous = "smooth"),
                     diag = list(continuous = "barDiag"),
                     upper = list(continuous = "cor"))

# Box plot
box_plot <- ggplot(songs_full_data, aes(x = reorder(album_title, song_rating, FUN = median), y = song_rating)) +
  geom_boxplot(fill = 'purple', color = 'black') +
  coord_flip() +
  labs(title = 'Distribution of Ratings for Each Album', x = 'Album', y = 'Song Rating') +
  theme_minimal()

# Song popularity vs. rating plot
popularity_rating_plot <- ggplot(songs_full_data, aes(x = song_popularity, y = song_rating, color = album_title)) +
  geom_point(alpha = 0.7, size = 3) +
  geom_smooth(method = 'lm', se = FALSE, color = 'black', aes(group = 1)) +
  labs(title = 'All Songs: Rating vs. Popularity', x = 'Song Popularity', y = 'Song Rating', color = 'Album') +
  theme_minimal() +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  guides(color = guide_legend(nrow = 2))

print(pair_plot)
print(box_plot)
print(popularity_rating_plot)
