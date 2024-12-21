-- ===========================================
--  MOVIE RECOMMENDATION SYSTEM SCHEMA WITH DUMMY DATA
-- ===========================================

-- Create Database and Use It
CREATE DATABASE MovieRecommendationSystem;
USE MovieRecommendationSystem;

--  Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1), 
    username VARCHAR(50) UNIQUE NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    password VARCHAR(100) NOT NULL, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (username, email, password) VALUES 
('john_doe', 'john@example.com', 'password123'),
('jane_smith', 'jane@example.com', 'securepass456'),
('mike_ross', 'mike@example.com', 'suitup789'),
('rachel_green', 'rachel@example.com', 'friends123'),
('chandler_bing', 'chandler@example.com', 'sarcasm456');

-- Movies Table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY IDENTITY(1,1), 
    title VARCHAR(100) NOT NULL, 
    genre VARCHAR(50) NOT NULL, 
    release_year INT NOT NULL, 
    duration INT NOT NULL, 
    language VARCHAR(50), 
    rating DECIMAL(3, 2), 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Movies (title, genre, release_year, duration, language, rating) VALUES 
('Inception', 'Sci-Fi', 2010, 148, 'English', 4.8),
('The Dark Knight', 'Action', 2008, 152, 'English', 4.9),
('Interstellar', 'Sci-Fi', 2014, 169, 'English', 4.7),
('Titanic', 'Romance', 1997, 195, 'English', 4.6),
('The Matrix', 'Sci-Fi', 1999, 136, 'English', 4.8);

--  Ratings Table
CREATE TABLE  Ratings (
    rating_id INT PRIMARY KEY IDENTITY(1,1), 
    user_id INT, 
    movie_id INT, 
    rating DECIMAL(2, 1) CHECK (rating BETWEEN 0 AND 5), 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id), 
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

INSERT INTO Ratings (user_id, movie_id, rating) VALUES 
(1, 1, 4.5),
(2, 2, 4.8),
(3, 3, 4.7),
(4, 4, 4.6),
(5, 5, 4.9);

-- Reviews Table
CREATE TABLE  Reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1), 
    user_id INT, 
    movie_id INT, 
    review TEXT, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id), 
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

INSERT INTO Reviews (user_id, movie_id, review) VALUES 
(1, 1, 'Amazing visuals and concept!'),
(2, 2, 'Best superhero movie of all time.'),
(3, 3, 'Mind-bending story, loved it.'),
(4, 4, 'A tragic love story, beautifully told.'),
(5, 5, 'A revolutionary sci-fi film.');

-- Watchlist Table
CREATE TABLE  Watchlist (
    watchlist_id INT PRIMARY KEY IDENTITY(1,1), 
    user_id INT, 
    movie_id INT, 
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id), 
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

INSERT INTO Watchlist (user_id, movie_id) VALUES 
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 1);

-- Genres Table
CREATE TABLE  Genres (
    genre_id INT PRIMARY KEY IDENTITY(1,1), 
    genre_name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO Genres (genre_name) VALUES 
('Sci-Fi'),
('Action'),
('Romance'),
('Drama'),
('Horror');

-- Followers Table
CREATE TABLE Followers (
    follower_id INT PRIMARY KEY IDENTITY(1,1), 
    user_id INT, 
    followed_user_id INT, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id), 
    FOREIGN KEY (followed_user_id) REFERENCES Users(user_id)
);

INSERT INTO Followers (user_id, followed_user_id) VALUES 
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1);

-- ===========================================
-- QUESTIONS AND QUERIES
-- ===========================================
-- SIMPLE QUERIES (BEGINNER) --

-- 1. List all users
SELECT * FROM Users;

-- 2. Show all movies with their genres and ratings
SELECT title, genre, rating FROM Movies;

-- 3. Get all reviews for a specific movie (Inception)
SELECT review FROM Reviews WHERE movie_id = (SELECT movie_id FROM Movies WHERE title = 'Inception');

-- 4. List all movies released after 2010
SELECT * FROM Movies WHERE release_year > 2010;

-- 5. Find all users who have rated more than 4
SELECT user_id, rating FROM Ratings WHERE rating > 4;

-- 6. Show watchlist details for user 'john_doe'
SELECT m.title FROM Watchlist w
JOIN Movies m ON w.movie_id = m.movie_id
JOIN Users u ON w.user_id = u.user_id
WHERE u.username = 'john_doe';

-- 7. Count how many users have rated each movie
SELECT movie_id, COUNT(user_id) AS total_ratings FROM Ratings GROUP BY movie_id;

-- 8. List the top 3 highest-rated movies
SELECT TOP 3 title, rating FROM Movies ORDER BY rating DESC;

-- 9. Get all followers of 'jane_smith'
SELECT u.username AS Follower
FROM Followers f
JOIN Users u ON f.user_id = u.user_id
WHERE f.followed_user_id = (SELECT user_id FROM Users WHERE username = 'jane_smith');

-- 10. Show movies that belong to the 'Sci-Fi' genre
SELECT * FROM Movies WHERE genre = 'Sci-Fi';


-- INTERMEDIATE QUERIES --

-- 11. Find the average rating for each movie
SELECT movie_id, AVG(rating) AS average_rating FROM Ratings GROUP BY movie_id;

-- 12. List all users who registered in the last 30 days
SELECT * FROM Users WHERE created_at >= DATEADD(DAY, -30, GETDATE());

-- 13. Retrieve movies with no ratings yet
SELECT title FROM Movies WHERE movie_id NOT IN (SELECT DISTINCT movie_id FROM Ratings);

-- 14. Show the most recent reviews (last 5)
SELECT TOP 5 r.review, m.title, u.username 
FROM Reviews r
JOIN Movies m ON r.movie_id = m.movie_id
JOIN Users u ON r.user_id = u.user_id
ORDER BY r.created_at DESC;

-- 15. List movies with a rating lower than the average
SELECT title, rating 
FROM Movies
WHERE rating < (SELECT AVG(rating) FROM Movies);

-- 16. Find users who rated the same movie more than once
SELECT user_id, movie_id, COUNT(*) AS rating_count
FROM Ratings
GROUP BY user_id, movie_id
HAVING COUNT(*) > 1;

-- 17. Show all movies added to watchlists but never rated
SELECT DISTINCT m.title FROM Watchlist w
JOIN Movies m ON w.movie_id = m.movie_id
LEFT JOIN Ratings r ON w.movie_id = r.movie_id
WHERE r.rating_id IS NULL;

-- 18. List all users who haven't followed anyone yet
SELECT u.username FROM Users u
LEFT JOIN Followers f ON u.user_id = f.user_id
WHERE f.user_id IS NULL;

-- 19. Find the most common movie genre
SELECT TOP 1 genre, COUNT(*) AS genre_count
FROM Movies
GROUP BY genre
ORDER BY genre_count DESC;

-- 20. Retrieve users who have rated more than 3 movies
SELECT user_id, COUNT(*) AS rating_count
FROM Ratings
GROUP BY user_id
HAVING COUNT(*) > 3;


--ADVANCED QUERIES (COMPLEX) --

-- 21. Get the highest-rated movie by each user
SELECT user_id, title, MAX(r.rating) AS max_rating
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY user_id, title;

-- 22. Show users who reviewed movies but didn't rate them
SELECT DISTINCT u.username
FROM Reviews r
JOIN Users u ON r.user_id = u.user_id
WHERE r.user_id NOT IN (SELECT user_id FROM Ratings);

-- 23. Rank movies by their average ratings (dense rank)
SELECT title, AVG(r.rating) AS average_rating,
DENSE_RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rank
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY title;

-- 24. Get the latest movie reviews by users they follow
SELECT u.username AS Reviewer, m.title, r.review, f.user_id AS Follower
FROM Reviews r
JOIN Users u ON r.user_id = u.user_id
JOIN Movies m ON r.movie_id = m.movie_id
JOIN Followers f ON u.user_id = f.followed_user_id
ORDER BY r.created_at DESC;

-- 25. List movies that have the same rating as the highest-rated movie
SELECT title FROM Movies
WHERE rating = (SELECT MAX(rating) FROM Movies);

-- 26. Calculate the average rating of movies by genre
SELECT genre, AVG(rating) AS average_rating
FROM Movies
GROUP BY genre
ORDER BY average_rating DESC;

-- 27. Show how many movies each user has added to their watchlist
SELECT u.username, COUNT(w.movie_id) AS watchlist_count
FROM Watchlist w
JOIN Users u ON w.user_id = u.user_id
GROUP BY u.username;

-- 28. Find the top 3 users who rated the most movies
SELECT TOP 3 u.username, COUNT(r.rating_id) AS total_ratings
FROM Ratings r
JOIN Users u ON r.user_id = u.user_id
GROUP BY u.username
ORDER BY total_ratings DESC;

-- 29. Retrieve users who follow someone who follows them back
SELECT u.username AS name, u2.username AS MutualFollower
FROM Followers f1
JOIN Followers f2 ON f1.user_id = f2.followed_user_id AND f1.followed_user_id = f2.user_id
JOIN Users u ON f1.user_id = u.user_id
JOIN Users u2 ON f1.followed_user_id = u2.user_id;

-- 30. Identify the most reviewed movie
SELECT TOP 1 m.title, COUNT(r.review_id) AS review_count
FROM Reviews r
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY m.title
ORDER BY review_count DESC;

--MORE ADVANCED QUERIES (COMPLEX) --

-- 31. List Top Rated Movies by Average Rating (Using JOIN and GROUP BY)
SELECT M.title, AVG(R.rating) AS avg_rating
FROM Movies M
JOIN Ratings R ON M.movie_id = R.movie_id
GROUP BY M.title
ORDER BY avg_rating DESC;

-- 32. Get Users Who Have Rated the Most Movies (Using GROUP BY and HAVING)
SELECT U.username, COUNT(R.rating_id) AS total_ratings
FROM Users U
JOIN Ratings R ON U.user_id = R.user_id
GROUP BY U.username
HAVING COUNT(R.rating_id) > 2;

-- 33. Show Users with Movies in Watchlist but No Ratings (LEFT JOIN and IS NULL)
SELECT U.username, M.title
FROM Users U
LEFT JOIN Watchlist W ON U.user_id = W.user_id
LEFT JOIN Ratings R ON W.movie_id = R.movie_id AND W.user_id = R.user_id
JOIN Movies M ON W.movie_id = M.movie_id
WHERE R.rating_id IS NULL;

-- 34. List Movies That Are Highly Rated But Have Few Reviews (JOIN, GROUP BY, and Subquery)
SELECT M.title, COUNT(RV.review_id) AS review_count, AVG(RT.rating) AS avg_rating
FROM Movies M
JOIN Ratings RT ON M.movie_id = RT.movie_id
LEFT JOIN Reviews RV ON M.movie_id = RV.movie_id
GROUP BY M.title
HAVING COUNT(RV.review_id) < 3 AND AVG(RT.rating) > 4.5;

-- 35. Most Popular Genre by Average Rating (JOIN with GROUP BY)
SELECT M.genre, AVG(R.rating) AS avg_genre_rating
FROM Movies M
JOIN Ratings R ON M.movie_id = R.movie_id
GROUP BY M.genre
ORDER BY avg_genre_rating DESC;

-- 36. Users Who Follow Someone Who Follows Them (Self JOIN)
SELECT U1.username AS follower, U2.username AS followed
FROM Followers F1
JOIN Followers F2 ON F1.user_id = F2.followed_user_id AND F1.followed_user_id = F2.user_id
JOIN Users U1 ON F1.user_id = U1.user_id
JOIN Users U2 ON F1.followed_user_id = U2.user_id;

-- 37. Find Users Who Rated Movies Outside Their Favorite Genre (Subquery with NOT IN)
SELECT U.username, M.title, M.genre, R.rating
FROM Users U
JOIN Ratings R ON U.user_id = R.user_id
JOIN Movies M ON R.movie_id = M.movie_id
WHERE M.genre NOT IN (
    SELECT TOP 1 M.genre
    FROM Movies M
    JOIN Ratings R ON M.movie_id = R.movie_id
    WHERE R.user_id = U.user_id
    GROUP BY M.genre
    ORDER BY COUNT(R.rating_id) DESC
);

-- 38. Show Users Who Wrote the Longest Review (JOIN and SUBQUERY)
SELECT U.username, RV.review, LEN(RV.review) AS review_length
FROM Users U
JOIN Reviews RV ON U.user_id = RV.user_id
WHERE LEN(RV.review) = (
    SELECT MAX(LEN(review)) FROM Reviews
);

-- 39.List Movies That Are On the Watchlist of Multiple Users (GROUP BY and HAVING)
SELECT M.title, COUNT(W.watchlist_id) AS watchlist_count
FROM Movies M
JOIN Watchlist W ON M.movie_id = W.movie_id
GROUP BY M.title
HAVING COUNT(W.watchlist_id) > 1;

-- 40. Show All Movies with Their Genre, Even if No Ratings Exist (FULL OUTER JOIN)
SELECT M.title, G.genre_name, R.rating
FROM Movies M
FULL OUTER JOIN Genres G ON M.genre = G.genre_name
LEFT JOIN Ratings R ON M.movie_id = R.movie_id
ORDER BY M.title;
