.open lab9-db

-- Check actors loaded
SELECT * FROM Actors LIMIT 3;
.print

-- Check directors loaded
SELECT * FROM Directors LIMIT 3
.print

.quit

-- Check movies loaded
SELECT * FROM Movies LIMIT 3
.print;

-- Create a list of Movies
.output ex02_movie_list.txt
SELECT title FROM movies;

// Check AppearsIn loaded
SELECT * FROM AppearsIn LIMIT 3;

-- Check the BelongsTo loaded
SELCET * FROM BelongsTo LIMIT 3;

.output

-- Check Directs loaded
SELECT * FROM Dircets LIMIT 3;
