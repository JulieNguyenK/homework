USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT upper(concat(first_name," " ,last_name)) as "Actor Name" 
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor
WHERE last_name like "%Li%"
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country = "Afghanistan"
OR country = "Bangladesh"
OR country = "China";

-- 3a. You want to keep a description of each actor.
-- You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;
 
-- 4a. List the last names of actors, as well as how many actors have that last name. 
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO"
AND last_name = "WILLIAMS";

-- 4d. In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name ="GROUCHO"
WHERE first_name = "HARPO";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT t1.first_name, t1.last_name, t2.address
FROM staff as t1 JOIN address AS t2 on t1.address_id = t2.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.first_name, staff.last_name, SUM(payment.amount) as Aug_rented_amount
FROM staff JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment_date like "2005-08%"
GROUP BY staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id) as num_actors
FROM film JOIN film_actor USING (film_id)
GROUP BY film.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id) FROM inventory
WHERE film_id IN (
	SELECT film_id FROM film
    WHERE title = "Hunchback Impossible"
    );
    
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) as "Total Amount Paid"
FROM customer JOIN payment on customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE language_id IN (	
    SELECT language_id FROM language WHERE name = "English"
    )
AND (title LIKE "K%" OR title LIKE "Q%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT first_name, last_name FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor 
    WHERE film_id IN (
		SELECT film_id FROM film
        WHERE title = "Alone Trip"
        )
	);
    
-- 7c. You will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM customer JOIN address USING (address_id)
WHERE city_id IN (
	SELECT city_id
	FROM city JOIN country ON city.country_id = country.country_id
	WHERE country = "Canada"
	);
    
-- 7d. Identify all movies categorized as family films.
SELECT title
FROM film JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON (film_category.category_id = category.category_id)
WHERE name = "Family";

-- 7e. Display the most frequently rented movies in descending order
SELECT title, times_rented FROM film
JOIN (
	SELECT film_id, COUNT(film_id) AS times_rented
	FROM rental JOIN inventory using (inventory_id)
    GROUP BY film_id
    ) as y on film.film_id = y.film_id
ORDER BY times_rented DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT SUM(amount) from payment
JOIN(
	SELECT inventory_id, store_id, rental_id
	FROM inventory RIGHT JOIN rental using (inventory_id)
    ) as y on payment.rental_id = y.rental_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM country JOIN(
	SELECT store_id, city, country_id
	FROM city JOIN (
		SELECT store_id, city_id
		FROM store JOIN address on store.address_id = address.address_id
		) as y using (city_id)
	) as z using (country_id);

-- 7h. List the top five genres in gross revenue in descending order.
-- Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name, sum(p.amount) as total_revenue
FROM category
JOIN film_category fc ON (category.category_id = fc.category_id)
JOIN inventory i on (i.film_id = fc.film_id)
JOIN rental r on (r.inventory_id =i.inventory_id)
JOIN payment p on (p.rental_id = r.rental_id)
GROUP BY category.name
ORDER BY total_revenue DESC
LIMIT 5;

-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
CREATE VIEW revenue_by_category AS
SELECT category.name, sum(p.amount) as total_revenue
FROM category
JOIN film_category fc ON (category.category_id = fc.category_id)
JOIN inventory i on (i.film_id = fc.film_id)
JOIN rental r on (r.inventory_id =i.inventory_id)
JOIN payment p on (p.rental_id = r.rental_id)
GROUP BY category.name
ORDER BY total_revenue DESC
LIMIT 5;

-- How would you display the view that you created in 8a?
SELECT * from revenue_by_category;

-- You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW revenue_by_category