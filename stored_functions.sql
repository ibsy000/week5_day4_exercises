SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'S%';

SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'R%';


-- Create a stored function - give us the count of actors with a last name that begins with *letter*

CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor 
	WHERE last_name ILIKE CONCAT(letter, '%');
	RETURN actor_count;
END;
$$;

-- Execute the function - use SELECT

SELECT get_actor_count('a'); 


-- Create a function that will tell us which employee had most rentals

CREATE OR REPLACE FUNCTION employee_with_most_transactions()
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR;
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) INTO employee
	FROM staff 
	WHERE staff_id = (
		SELECT staff_id
		FROM rental
		GROUP BY staff_id
		ORDER BY COUNT(*) DESC 
		LIMIT 1
	);
	RETURN employee;
END;
$$;


SELECT employee_with_most_transactions();


SELECT *
FROM rental;


SELECT *
FROM payment;

SELECT rental_id, COUNT(*)
FROM payment 
GROUP BY rental_id
ORDER BY count DESC;



SELECT staff_id, COUNT(*)
FROM payment 
GROUP BY staff_id;



-- Functions can all return Tables
-- Create a function that will return a table with customers (first and last) and their 
-- full address( address, city, district, country) by searching a country name
CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR(50))
RETURNS TABLE(
	first_name VARCHAR,
	last_name VARCHAR,
	address VARCHAR,
	city VARCHAR,
	district VARCHAR,
	country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci 
	ON a.city_id = ci.city_id 
	JOIN country co 
	ON ci.country_id = co.country_id 
	WHERE co.country = country_name;
END;
$$;

SELECT district, COUNT(*)
FROM customers_in_country('United States')
GROUP BY district;


-- To remove a function, use DROP
DROP FUNCTION get_actor_count;














