-- Question 1

-- Create a Stored Procedure that will insert a new film into the film table with the
-- following arguments: title, description, release_year, language_id, rental_duration,
-- rental_rate, length, replacement_cost, rating

SELECT *
FROM film;



CREATE OR REPLACE PROCEDURE add_film(
	title VARCHAR(255), 
	description VARCHAR(300), 
	release_year INTEGER, 
	language_id INTEGER, 
	rental_duration INTEGER, 
	rental_rate NUMERIC(4,2), 
	length INTEGER, 
	replacement_cost NUMERIC(4,2), 
	rating MPAA_RATING)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO film(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
	VALUES (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating);
END;
$$;

CALL add_film(
'Mr. Stanton in Zombie Apocolypse', 
'In a world where zombies are stand-up comedians, one teacher has no choice but to assasinate an honorable man using just his mind. The teacher realises he''s actually a ghost.', 
2022, 1, 7, 9.99, 120, 99.99, 'R');

SELECT *
FROM film
ORDER BY film_id DESC;

-- SUCCESS!








-- Question 2

-- Create a Stored Function that will take in a category_id 
-- and return the number of films in that category

SELECT category_id, COUNT(*)
FROM film_category 
WHERE category_id = 1
GROUP BY category_id;


CREATE OR REPLACE FUNCTION num_of_films_in_category(category_num INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE films_in_category INTEGER;
BEGIN 
	SELECT COUNT(*) INTO films_in_category
	FROM film_category
	WHERE category_id = category_num;
	RETURN films_in_category;
END;
$$;


SELECT num_of_films_in_category(1);

-- SUCCESS 
-- for category_id 1(Action), there are 64 films in that category






































