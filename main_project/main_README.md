# Main Project: Spotify Playlist Import

## Overview
This part of the project is responsible for importing Spotify playlists into a MySQL database using the Spotify API.

## Setup and Usage
### Prerequisites
- Python 3.x
- MySQL

### Installation
1. **Install required Python packages:**
    ```bash
    pip install spotipy mysql-connector-python
    ```

2. **Set Up Spotify API:**
   - Retrieve your `Client ID` and `Client Secret` from the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications).
   - Replace the placeholder values in the `import_spotify.py` script with your actual `Client ID` and `Client Secret`.

### Database Setup
1. **Create MySQL Database and Tables:**
   - Ensure your server is running and you have privileges to create databases and tables.
   - Run the `create_tables.sql` script to create the required tables.

2. **Create Triggers:**
   - Run the `Triggers.sql` script to set up necessary triggers for automatic rating calculations.

### Running the Python Script
1. **Import Spotify Data:**
   - The `import_spotify.py` script retrieves data from Spotify and stores it in your MySQL database. 
   - Update the `playlist_id` variable in the script with the ID of the Spotify playlist you want to import. This can be done by copying the link to the playlist (e.g., from the link `https://open.spotify.com/playlist/37i9dQZEVXbMDoHDwVN2tF?si=ad0bf3c20b684ca5`, the playlist ID is: `37i9dQZEVXbMDoHDwVN2tF`).
   - Run the script:
     ```bash
     python import_spotify.py
     ```

### Inputting Song Ratings
1. **Manually Input Song Ratings:**
   - To manually input song ratings, use the following SQL command:
     ```sql
     UPDATE songs
     SET song_rating = <rating>
     WHERE spotify_song_id = '<spotify_song_id>';
     ```
   - Replace `<rating>` with your own ratings and `<spotify_song_id>` with the actual Spotify song ID.

### Here Are Some Example Outputs From My Top Favourite Albums!
- [Songs.csv](./examples/songs.csv): Example of song data exported to CSV.
- [Albums.csv](./examples/albums.csv): Example of album data exported to CSV.
- [Artists.csv](./examples/artists.csv): Example of artist data exported to CSV.

### Acknowledgements
- This project uses the [Spotipy library](https://spotipy.readthedocs.io/en/2.19.0/) for interacting with the Spotify API.
