
-- 1a. a list of all the actors who have Display the first and last names of all actors from the table actor.
select first_name, last_name 
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters.
-- Name the column Actor Name.
select upper(concat(first_name,' ', last_name)) as `Actor Name` 
from actor;

-- 2a. find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select actor_id, first_name, last_name 
from actor 
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
select * 
from actor 
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order
select * 
from actor 
where last_name like '%LI%' order by last_name, first_name;

-- 2d. display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
select country_id, country 
from country 
where country in ('Afghanistan', 'Bangladesh', 'China');

--  3a. Add a middle_name column to the table actor. Position it between first_name and last_name
alter table actor add middle_name varchar(50) after first_name;

-- 3b. Change the data type of the middle_name column to blobs
ALTER TABLE actor MODIFY middle_name blobs;

-- 3c. delete the middle_name column
alter table actor drop column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name
select last_name, count(*) 
from actor 
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name,
-- but only for names that are shared by at least two actors
select last_name, count(*) 
from actor 
group by last_name having count(*)>1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS
-- Write a query to fix the record
update actor 
set first_name = 'HARPO' 
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. if the first name of the actor is currently HARPO, change it to GROUCHO. 
-- Otherwise, change the first name to MUCHO GROUCHO
update actor
set first_name = case
when first_name = 'HARPO' then 'GROUCHO'
when first_name = 'GROUCHO' then 'MUCHO GROUCHO'
else first_name end
where last_update <> '2006-02-15 04:34:33';

-- 5a. locate the schema of the address table
describe address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
select s.first_name, s.last_name, a.address
from staff as s
join address as a
on s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member
-- in August of 2005. Use tables staff and payment.
select s.first_name, s.last_name, sum(p.amount)
from payment as p
join staff as s
on p.staff_id = s.staff_id
where payment_date like '2005-08-%'
group by p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film.
-- Use tables film_actor and film. Use inner join.
select f.title, count(a.actor_id)
from film as f
inner join film_actor as a
on f.film_id = a.film_id
group by f.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*)
from inventory
where film_id in (
select film_id
from film
where title = 'Hunchback Impossible'
);

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name
select c.first_name, c.last_name, sum(p.amount) as total_payment
from customer as c
join payment as p
on c.customer_id = p.customer_id
group by p.customer_id
order by c.last_name;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q 
-- whose language is English
select title
from film
where title like 'K%' or title like 'Q%'
and language_id in (
select language_id
from language
where name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
select first_name, last_name
from actor
where actor_id in (
select actor_id
from film_actor
where film_id in (
select film_id
from film
where title = 'Alone Trip'
)
);

-- 7c. Use joins to retrieve the names and email addresses of all Canadian customers
select cu.first_name, cu.last_name, cu.email
from customer as cu
join address as a on cu.address_id = a.address_id
join city as c on a.city_id = c.city_id
join country as co on c.country_id = co.country_id
where co.country = 'canada';

-- 7d. Identify all movies categorized as famiy films
select title
from film
where film_id in (
select film_id
from film_category
where category_id in (
select category_id
from category
where name = 'family'
)
);

-- 7e. Display the most frequently rented movies in descending order
select f.title, count(r.rental_id) as total_rent
from film as f
join inventory as inv on f.film_id = inv.film_id
join rental as r on inv.inventory_id = r.inventory_id
group by f.title
order by count(r.rental_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select sale.store, (rent.total_rent + sale.total_sales) as total_business
from (select sum(amount) as total_rent, staff_id from payment group by staff_id) as rent
join staff_list as s on rent.staff_id = s.ID
join sales_by_store as sale on s.name = sale.manager;

-- 7g. Write a query to display for each store its store ID, city, and country
select s.store_id, city.city, c.country
from store as s
join address as a on s.address_id = a.address_id
join city on a.city_id = city.city_id
join country as c on city.country_id = c.country_id;

-- 7h. List the top five genres in gross revenue in descending order.
select sale.category, (sale.total_sales + rent.total_rent) as gross_revenue
from (select sum(payment.amount) as total_rent, category.name as name
from payment
join rental on payment.rental_id = rental.rental_id
join inventory on rental.inventory_id = inventory.inventory_id
join film_category on inventory.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
group by category.name) as rent
join sales_by_film_category as sale on rent.name = sale.category
order by gross_revenue desc limit 5;

-- 8a. Use the solution from the problem above to create a view
create view top_five_genres as 
select sale.category, (sale.total_sales + rent.total_rent) as gross_revenue
from (select sum(payment.amount) as total_rent, category.name as name
from payment
join rental on payment.rental_id = rental.rental_id
join inventory on rental.inventory_id = inventory.inventory_id
join film_category on inventory.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
group by category.name) as rent
join sales_by_film_category as sale on rent.name = sale.category
order by gross_revenue desc limit 5;

-- 8b. How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c. delete the view
drop view top_five_genres;

