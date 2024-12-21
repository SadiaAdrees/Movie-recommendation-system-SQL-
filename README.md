# Movie Recommendation System - SQL Project

## Project Overview
This SQL project implements a movie recommendation system that allows users to search for movies, rate them, and receive personalized recommendations. The project utilizes a relational database schema to store data about users, movies, ratings, and genres.

## Database Schema

### Tables:
- **Users**: Contains user information.
- **Movies**: Stores movie details.
- **Genres**: Lists different genres.
- **MovieGenres**: Maps movies to genres.
- **Ratings**: Stores user ratings for movies.

### Relationships:
- A user can rate multiple movies.
- A movie can belong to multiple genres.
- Many users can rate the same movie.

---

## Features
- **User Registration**: Users can register and log in.
- **Movie Search**: Search for movies by title, genre, or rating.
- **Rate Movies**: Users can rate movies they've watched.
- **Recommendations**: Recommend movies based on user ratings and preferences.
- **Top Rated**: View top-rated movies by genre or overall.

---

## SQL Code (Database Setup)
```sql
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT
);

CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

CREATE TABLE MovieGenres (
    movie_id INT REFERENCES Movies(movie_id),
    genre_id INT REFERENCES Genres(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

CREATE TABLE Ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    movie_id INT REFERENCES Movies(movie_id),
    rating FLOAT CHECK (rating >= 0 AND rating <= 5)
);
```

---

## Sample Queries
### 1. Get Top Rated Movies
```sql
SELECT m.title, AVG(r.rating) AS average_rating
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY m.title
ORDER BY average_rating DESC
LIMIT 10;
```

### 2. Recommend Movies by Genre
```sql
SELECT m.title
FROM Movies m
JOIN MovieGenres mg ON m.movie_id = mg.movie_id
JOIN Genres g ON mg.genre_id = g.genre_id
WHERE g.genre_name = 'Action'
ORDER BY RANDOM()
LIMIT 5;
```

### 3. User-Specific Recommendations
```sql
SELECT m.title
FROM Movies m
WHERE m.movie_id NOT IN (
    SELECT movie_id FROM Ratings WHERE user_id = 1
)
ORDER BY RANDOM()
LIMIT 5;
```

---

## Setup and Installation
1. Clone the repository.
2. Install PostgreSQL or your preferred SQL database.
3. Run the provided SQL scripts to create the database schema.
4. Populate the tables with sample data.

---

## Future Enhancements
- Implement collaborative filtering for better recommendations.
- Add movie reviews and comments.
- Integrate with external movie APIs for data enrichment.

---

## License
This project is open-source.
