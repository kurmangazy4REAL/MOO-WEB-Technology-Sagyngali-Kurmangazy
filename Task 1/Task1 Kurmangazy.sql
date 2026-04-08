CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    age INT CHECK (age >= 0),
    created_at DATE NOT NULL DEFAULT CURRENT_DATE CHECK (created_at >= '2026-01-01')
);

CREATE TABLE artists (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL,
    debut_date DATE NOT NULL CHECK (debut_date >= '2026-01-01'),
    monthly_listeners INT DEFAULT 0 CHECK (monthly_listeners >= 0)
);

CREATE TABLE songs (
    song_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT NOT NULL CHECK (duration >= 0),
    release_date DATE NOT NULL CHECK (release_date >= '2026-01-01'),
    artist_id INT NOT NULL,
    plays INT DEFAULT 0 CHECK (plays >= 0),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

CREATE TABLE playlist_songs (
    playlist_song_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    song_id INT NOT NULL,
    added_at DATE DEFAULT CURRENT_DATE CHECK (added_at >= '2026-01-01'),
    position INT CHECK (position >= 0),
    is_favorite BOOLEAN DEFAULT false,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (song_id) REFERENCES songs(song_id)
);


INSERT INTO users (username, email, age)
VALUES
('john_doe', 'john@example.com', 25),
('alice123', 'alice@example.com', 30),
('bob_smith', 'bob@example.com', 22);


INSERT INTO artists (name, country, debut_date, monthly_listeners)
VALUES
('The Waves', 'USA', '2026-02-01', 100000),
('Neon Beats', 'UK', '2026-03-15', 50000),
('DJ Sky', 'Germany', '2026-04-01', 75000);


INSERT INTO songs (title, duration, release_date, artist_id, plays)
VALUES
('Ocean Drive', 210, '2026-02-10', 1, 1000),
('Night Lights', 180, '2026-03-20', 2, 2000),
('Sky High', 240, '2026-04-05', 3, 1500);




INSERT INTO playlist_songs (user_id, song_id, position, is_favorite)
VALUES
(1, 1, 1, true),
(1, 2, 2, false),
(2, 2, 1, true),
(3, 3, 1, false);