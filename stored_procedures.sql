SELECT *
FROM customer 
WHERE loyalty_member = TRUE;

-- RESET ALL MEMBER TO LOYALTY = FALSE
UPDATE customer 
SET loyalty_member = FALSE;


-- Create a Procedure that will set customers who have spent at least $100 to loyalty_member=TRUE 

-- Subquery
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM payment 
	GROUP BY customer_id
	HAVING SUM(amount) >= 100
);

-- PUT INTO PROCEDURE
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment 
		GROUP BY customer_id
		HAVING SUM(amount) >= 100
	);
END;
$$;


-- Execute a procedure - we use CALL 
CALL update_loyalty_status(); 

SELECT *
FROM customer 
WHERE loyalty_member = FALSE;


-- Find customers who are close...
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id 
HAVING SUM(amount) BETWEEN 95 AND 100;

-- Push one of the customers over the threshold
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES(554, 1, 1, 5.99, '2022-08-11 14:23:00'); -- Date format (YYYY-MM-DD HH:mm:ss)

SELECT *
FROM customer 
WHERE customer_id = 554;

-- Call the PROCEDURE 
CALL update_loyalty_status(); 




-- Create a procedure that takes in arguments

CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR(45), last_name VARCHAR(45))
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES (first_name, last_name, NOW());
END;
$$;

-- Add an actor to our table
CALL add_actor('Tom', 'Cruise');

SELECT *
FROM actor 
WHERE last_name = 'Cruise';


CALL add_actor('Tom', 'Hanks');

SELECT *
FROM actor 
WHERE first_name = 'Tom';


-- To delete a procedure, use DROP
DROP PROCEDURE add_actor;


















