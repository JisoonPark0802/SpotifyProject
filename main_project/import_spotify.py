import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import mysql.connector

# Set up Spotify API credentials
client_id = 'your_client_id'
client_secret = 'your_client_secret'

sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=client_id, client_secret=client_secret))

# Connect to MySQL 
db = mysql.connector.connect(
    host="localhost",
    user="your_username",
    password="your_password",
    database="song_database"
)
cursor = db.cursor()

# In case release_date is incomplete from Spotify
def complete_date(date_str):
    if len(date_str) == 4:
        return date_str + '-01-01'
    elif len(date_str) == 7:
        return date_str + '-01'
    else:
        return date_str

def get_artist(artist_id):
    try:
        artist = sp.artist(artist_id)
        cursor.execute("""
            INSERT INTO artists (spotify_artist_id, artist_name, artist_popularity)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE artist_name=%s, artist_popularity=%s
        """, (artist['id'], artist['name'], artist['popularity'], artist['name'], artist['popularity']))
    except Exception as e:
        print(f"Artist error: {e}")

def get_album(album_id):
    try:
        album = sp.album(album_id)
        album_release_date = complete_date(album['release_date'])
        cursor.execute("""
            INSERT INTO albums (spotify_album_id, album_title, spotify_artist_id, album_release_date, album_total_tracks, album_popularity)
            VALUES (%s, %s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE album_title=%s, spotify_artist_id=%s, album_release_date=%s, album_total_tracks=%s, album_popularity=%s
        """, (album['id'], album['name'], album['artists'][0]['id'], album_release_date, album['total_tracks'], album['popularity'], album['name'], album['artists'][0]['id'], album_release_date, album['total_tracks'], album['popularity']))
    except Exception as e:
        print(f"Album error: {e}")

def get_song(song_id):
    try:
        song = sp.track(song_id)
        audio_features = sp.audio_features(song_id)[0]
        song_release_date = complete_date(song['album']['release_date'])
        cursor.execute("""
            INSERT INTO songs (spotify_song_id, song_title, spotify_album_id, spotify_artist_id, song_popularity, song_duration, song_danceability, song_energy, song_key, song_loudness, song_mode, song_speechiness, song_acousticness, song_instrumentalness, song_liveness, song_valence, song_tempo, song_time_signature, song_release_date)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE song_title=%s, spotify_album_id=%s, spotify_artist_id=%s, song_popularity=%s, song_duration=%s, song_danceability=%s, song_energy=%s, song_key=%s, song_loudness=%s, song_mode=%s, song_speechiness=%s, song_acousticness=%s, song_instrumentalness=%s, song_liveness=%s, song_valence=%s, song_tempo=%s, song_time_signature=%s, song_release_date=%s
        """, (song['id'], song['name'], song['album']['id'], song['artists'][0]['id'], song['popularity'], song['duration_ms'], audio_features['danceability'], audio_features['energy'], audio_features['key'], audio_features['loudness'], audio_features['mode'], audio_features['speechiness'], audio_features['acousticness'], audio_features['instrumentalness'], audio_features['liveness'], audio_features['valence'], audio_features['tempo'], audio_features['time_signature'], song_release_date,
              song['name'], song['album']['id'], song['artists'][0]['id'], song['popularity'], song['duration_ms'], audio_features['danceability'], audio_features['energy'], audio_features['key'], audio_features['loudness'], audio_features['mode'], audio_features['speechiness'], audio_features['acousticness'], audio_features['instrumentalness'], audio_features['liveness'], audio_features['valence'], audio_features['tempo'], audio_features['time_signature'], song_release_date))
    except Exception as e:
        print(f"Song error: {e}")

def get_playlist(playlist_id):
    try:
        limit = 100
        offset = 0
        while True:
            playlist_tracks = sp.playlist_tracks(playlist_id, limit=limit, offset=offset)
            items = playlist_tracks['items']
            if not items:
                break
            for item in items:
                track = item['track']
                for artist in track['artists']:
                    get_artist(artist['id'])
                get_album(track['album']['id'])
                get_song(track['id'])
            offset += limit
            if len(items) < limit:
                break
        db.commit()
    except Exception as e:
        print(f"Playlist error: {e}")

# Input Playlist ID
playlist_id = 'your_playlist_id'

get_playlist(playlist_id)

db.close()
