use sakila;
-- Question 1.a
select first_name, last_name
from actor;
-- Question 1.b
select upper(concat((first_name),N' ',last_name)) as 'Actor Name'
from actor;

-- Question 2.a
select actor_id, first_name, last_name
from actor
where first_name='Joe';

-- Question 2.b
select actor_id, first_name, last_name
from actor
where (last_name) LIKE'%GEN%';

-- Question 2.c
select actor_id, first_name, last_name
from actor
where (last_name) LIKE'%LI%'
ORDER BY last_name, first_name;

-- Question 2.d 
select country_id, country
from country
where country in('Afghanistan', 'Bangladesh','China');

-- Question 3.a
Alter Table actor
add middle_name varchar(25) NULL  AFTER `first_name`;

-- Question 3.b
Alter table actor
modify column middle_name blob;

-- Question 3.c
Alter table actor
drop middle_name;

-- question 4.a 
select last_name, count(*) as name_count
from actor
group by last_name
order by name_count desc;

-- question 4.b
select last_name, count(*) as name_count
from actor
group by last_name
having count(*)>1
order by name_count desc;

-- Question 4.c
update sakila.actor
set first_name='HARPO'
WHERE first_name='GROUCHO' AND LAST_NAME='WILLIAMS';

-- Question 4.d

update sakila.actor
set first_name= Case when first_name='HARPO'  then 'Groucho' ELSE 'mucho groucho' end
where actor_id=172;

-- question 5.a
CREATE TABLE address2 (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  location GEOMETRY NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY `idx_location` (location),
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- question 6.a 
use sakila;
select s.first_name,s.last_name,a.address
from staff as s
join address as a
on s.address_id=a.address_id;

-- question 6.b 
use sakila;
select  s.first_name, s.last_name, Sum(p.amount) as Total
from staff as s
join payment as p
on s.staff_id=p.staff_id
where year(p.payment_date)=2005 and month(p.payment_date)=08
group by s.staff_id;

select payment_date
from payment;
-- question 6.c
use sakila;
select f.film_id, f.title, count(*) as Num_of_actors
from film as f
join film_actor as fa
on f.film_id=fa.film_id
group by f.film_id;

-- question 6.d 
use sakila;
select f.title,count(*) as Num_of_copies
from film as f
join inventory as i
on f.film_id=i.film_id
where f.title='Hunchback Impossible';

-- question 6.e
use sakila;
select c.first_name, c.last_name, Sum(p.amount) as Total_Payment
from customer as c
join payment as p
on c.customer_id=p.customer_id
group by c.customer_id
order by last_name;

-- question 7.a
use sakila;
select f.title
from film as f
where left(title,1)='Q' OR left(title,1)='K' and 
f.language_id in (Select l.language_id 
from language as l
where l.name='English');

-- question 7.b
use sakila;
select a.first_name, a.last_name
from actor as a
where a.actor_id in (select fa.actor_id
from film_actor as fa where fa.film_id in
(select f.film_id from  film  as f
where f.title='Alone Trip'));

-- question 7.c
use sakila;
select cu.first_name, cu.last_name,cu.email, cou.country
from customer as cu
join address as a
on cu.address_id=a.address_id
join city as c
on a.city_id=c.city_id
join country as cou
on c.country_id = cou.country_id
where country=N'Canada';

-- question 7.d 
-- using subqueries
select f.title 
from film as f
where f.film_id in (select fc.film_id
from film_category as fc
where fc.category_id in(select ca.category_id
from  category as ca
where ca.name ='Family'));
-- using join
select f.title, ca.name
from film as f
join film_category as fa
on f.film_id=fa.film_id
join category as ca
on fa.category_id = ca.category_id
where ca.name= N'Family';

-- question 7.e
use sakila;
select f.title,count(*) as Number_of_Times_Rented
from film as f
join inventory as i
on f.film_id=i.film_id
join rental as r
on i.inventory_id=r.inventory_id
group by f.title
order by Number_of_Times_Rented desc;

-- question 7.f 
 use sakila;
 SELECT 
        CONCAT(c.city,' / ', cou.country) AS Store,
        CONCAT(st.first_name,' ',st.last_name) AS Manager,
        Concat('$', CAST(Format(SUM(p.amount),2) as char(20))) AS Total_Sales
    FROM payment as p
        JOIN rental as r ON p.rental_id = r.rental_id
        JOIN inventory as i ON r.inventory_id = i.inventory_id
        JOIN store as s ON i.store_id = s.store_id
        JOIN address a ON s.address_id = a.address_id
        JOIN city as c ON a.city_id = c.city_id
        JOIN country as cou ON c.country_id = cou.country_id
        JOIN staff as st ON s.manager_staff_id = st.staff_id
    GROUP BY s.store_id
    ORDER BY cou.country , c.city;

-- question 7.g
use sakila;
SELECT 
        c.city, cou.country
	From address as a
		Join city as c on a.city_id=c.city_id
		JOIN country as cou on c.country_id=cou.country_id
        JOIN store as s on a.address_id=s.address_id; 

-- question 7.h
use sakila;
SELECT  c.name as Film_Category, Concat('$', CAST(Format(SUM(p.amount),2) as char(20))) AS Gross_Revenue
	From payment as p
		join rental as r on p.rental_id=r.rental_id
        join inventory as i on r.inventory_id=i.inventory_id
        join film_category as fc on i.film_id=fc.film_id
        join category as c on fc.category_id=c.category_id
	group by c.name
    order by Gross_Revenue desc
    limit 5;

-- question 8.a

use sakila;
create view Top5_film_Category_GrossRevnue as 
SELECT  c.name as Film_Category, Concat('$', CAST(Format(SUM(p.amount),2) as char(20))) AS Gross_Revenue
	From payment as p
		join rental as r on p.rental_id=r.rental_id
        join inventory as i on r.inventory_id=i.inventory_id
        join film_category as fc on i.film_id=fc.film_id
        join category as c on fc.category_id=c.category_id
	group by c.name
    order by Gross_Revenue desc
    limit 5;
-- question 8.b
use sakila;
SELECT * FROM Top5_film_Category_GrossRevnue;

-- question 8.c 
USE sakila;
DROP VIEW Top5_film_Category_GrossRevnue;