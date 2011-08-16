-- moviedb schema

CREATE TABLE movie (
    movie_id INTEGER NOT NULL PRIMARY KEY,
    title VARCHAR(255),
    year SMALLINT,
    format VARCHAR(8)
);
CREATE INDEX movie_title_idx ON movie (title);
CREATE INDEX movie_year_idx ON movie (year);
CREATE UNIQUE INDEX movie_title_year_idx ON movie (title,year);

CREATE TABLE movie_star (
    movie_id INTEGER NOT NULL,
    star_id INTEGER NOT NULL
);
CREATE INDEX movie_star_movie_id_idx ON movie_star (movie_id);
CREATE INDEX movie_star_star_id_idx ON movie_star (star_id);

CREATE TABLE star (
    star_id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(255)
);
CREATE UNIQUE INDEX star_name_idx ON star (name);

