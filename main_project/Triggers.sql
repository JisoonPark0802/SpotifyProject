DELIMITER //

#UPDATE ALBUM RATING AFTER SONG RATING CHANGE

CREATE TRIGGER update_album_insert
AFTER INSERT ON songs
FOR EACH ROW
BEGIN
    DECLARE album_rating DECIMAL(3,2);
    
    SELECT AVG(song_rating) INTO album_rating
    FROM songs
    WHERE spotify_album_id = NEW.spotify_album_id;
    
    UPDATE albums
    SET album_rating = album_rating
    WHERE spotify_album_id = NEW.spotify_album_id;
END;
//

CREATE TRIGGER update_album_update
AFTER UPDATE ON songs
FOR EACH ROW
BEGIN
    DECLARE album_rating DECIMAL(3,2);
    
    SELECT AVG(song_rating) INTO album_rating
    FROM songs
    WHERE spotify_album_id = NEW.spotify_album_id;
    
    UPDATE albums
    SET album_rating = album_rating
    WHERE spotify_album_id = NEW.spotify_album_id;
END;
//

#UPDATE ARTIST RATING AFTER ALBUM RATING CHANGE

CREATE TRIGGER update_artist_insert
AFTER INSERT ON albums
FOR EACH ROW
BEGIN
    DECLARE artist_rating DECIMAL(3, 2);
    
    SELECT AVG(album_rating) INTO artist_rating
    FROM albums
    WHERE spotify_artist_id = NEW.spotify_artist_id;
    
    UPDATE artists
    SET artist_rating = artist_rating
    WHERE spotify_artist_id = NEW.spotify_artist_id;
END;
//

CREATE TRIGGER update_artist_update
AFTER UPDATE ON albums
FOR EACH ROW
BEGIN
    DECLARE artist_rating DECIMAL(3, 2);
    
    SELECT AVG(album_rating) INTO artist_rating
    FROM albums
    WHERE spotify_artist_id = NEW.spotify_artist_id;
    
    UPDATE artists
    SET artist_rating = artist_rating
    WHERE spotify_artist_id = NEW.spotify_artist_id;
END;
//

DELIMITER ;
