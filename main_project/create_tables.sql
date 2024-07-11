CREATE DATABASE song_database;
USE song_database;

CREATE TABLE artists (
  spotify_artist_id VARCHAR(100) NOT NULL COMMENT 'Spotify ID for the artist',
  artist_name VARCHAR(100) NOT NULL COMMENT 'Name of the artist',
  artist_rating DECIMAL(3,1) DEFAULT NULL COMMENT 'Average rating of the artist over all albums',
  artist_popularity INT DEFAULT NULL COMMENT 'Popularity of the artist (0-100)',
  PRIMARY KEY (spotify_artist_id)
) COMMENT='Table for artists';

CREATE TABLE albums (
  spotify_album_id VARCHAR(100) NOT NULL COMMENT 'Spotify ID for the album',
  album_title VARCHAR(100) NOT NULL COMMENT 'Title of album',
  spotify_artist_id VARCHAR(100) COMMENT 'Foreign key for artist',
  album_release_date DATE NOT NULL COMMENT 'Date of release for album',
  album_total_tracks INT DEFAULT NULL COMMENT 'Total number of tracks in the album',
  album_popularity INT DEFAULT NULL COMMENT 'Popularity of the album (0-100)',
  album_rating DECIMAL(3,1) DEFAULT NULL COMMENT 'Average rating of all songs within album',
  PRIMARY KEY (spotify_album_id),
  KEY (spotify_artist_id),
  CONSTRAINT albums_ibfk_1 FOREIGN KEY (spotify_artist_id) REFERENCES artists (spotify_artist_id)
) COMMENT='Table for albums';

CREATE TABLE songs (
  spotify_song_id VARCHAR(100) NOT NULL COMMENT 'Spotify ID for the song',
  song_title VARCHAR(255) NOT NULL COMMENT 'Title of the song',
  spotify_album_id VARCHAR(100) COMMENT 'Foreign key for album',
  spotify_artist_id VARCHAR(100) COMMENT 'Foreign key for artist',
  song_popularity INT DEFAULT NULL COMMENT 'Popularity of the song (0-100)',
  song_release_date DATE DEFAULT NULL COMMENT 'Release date of the song',
  song_duration INT NOT NULL COMMENT 'Duration of the song in milliseconds',
  song_rating DECIMAL(3,1) COMMENT 'Rating for the song (0-10)',
  song_danceability DECIMAL(4,3) DEFAULT NULL COMMENT 'Danceability score',
  song_energy DECIMAL(4,3) DEFAULT NULL COMMENT 'Energy score',
  song_key INT DEFAULT NULL COMMENT 'Key of the song',
  song_loudness DECIMAL(5,2) DEFAULT NULL COMMENT 'Loudness in dB',
  song_mode INT DEFAULT NULL COMMENT 'Mode of the song (major=1/minor=0)',
  song_speechiness DECIMAL(4,3) DEFAULT NULL COMMENT 'Speechiness score',
  song_acousticness DECIMAL(4,3) DEFAULT NULL COMMENT 'Acousticness score',
  song_instrumentalness DECIMAL(4,3) DEFAULT NULL COMMENT 'Instrumentalness score',
  song_liveness DECIMAL(4,3) DEFAULT NULL COMMENT 'Liveness score',
  song_valence DECIMAL(4,3) DEFAULT NULL COMMENT 'Valence score',
  song_tempo DECIMAL(6,2) DEFAULT NULL COMMENT 'Tempo in BPM',
  song_time_signature INT DEFAULT NULL COMMENT 'Time signature',
  PRIMARY KEY (spotify_song_id),
  KEY (spotify_album_id),
  KEY (spotify_artist_id),
  CONSTRAINT songs_ibfk_1 FOREIGN KEY (spotify_album_id) REFERENCES albums (spotify_album_id),
  CONSTRAINT songs_ibfk_2 FOREIGN KEY (spotify_artist_id) REFERENCES artists (spotify_artist_id),
  CONSTRAINT songs_chk_1 CHECK (song_rating >= 0 AND song_rating <= 10)
) COMMENT='Table for songs';

