-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select f.title, count(*)
from film as f
left join inventory as i
on f.film_id=i.film_id
where f.title="Hunchback Impossible";

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
select title, length
from film
where length>=(select max(length) from film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
select fi.title,a.first_name,a.last_name
from film_actor as f
left join actor as a on f.actor_id=a.actor_id
left join film as fi on f.film_id=fi.film_id
where fi.title=(select title from film where title="Alone Trip");

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
select fi.title,c.name
from film_category as f
left join category as c on c.category_id=f.category_id
left join film as fi on f.film_id=fi.film_id
where c.name=(select name from category where name="family");

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
select c.first_name,c.last_name,c.email,co.country
from customer as c
left join address as a on c.address_id=a.address_id
left join city as ci on a.city_id=ci.city_id
left join country as co on ci.country_id=co.country_id
where co.country=(select country from country where country="Canada");

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
select fi.title,a.first_name
from film_actor as f
left join actor as a on f.actor_id=a.actor_id
left join film as fi on f.film_id=fi.film_id
where a.first_name=(select a.first_name 
from actor as a
left join film_actor as f on a.actor_id=f.actor_id
group by a.actor_id
order by count(*) DESC
limit 1);

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
select f.title, c.customer_id
from film as f
left join inventory as i on f.film_id=i.film_id
left join rental as r on i.inventory_id=r.inventory_id
left join customer as c on r.customer_id=c.customer_id
where c.customer_id=(select customer_id
from payment
group by customer_id
order by sum(amount) desc
LIMIT 1);

-- 8. Retrieve the client_id and the total_amount_spent
-- of those clients who spent more than the average 
-- of the total_amount spent by each client. You can 
-- use subqueries to accomplish this.
select customer_id, sum(amount) 
from payment 
group by customer_id
having avg(amount)>(
SELECT AVG(amount) AS avg_amount
FROM payment
WHERE customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
))
order by sum(amount) DESC;