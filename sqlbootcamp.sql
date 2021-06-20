-- SQL Bootcamp
-- 06/19/2021
SELECT region, country, salesperson -- looking for state, country, salesperson info
FROM regions
;

-- We can add DISTINCT to the query statement to eliminate duplicates of rows of categories and subcategories
SELECT DISTINCT category, sub_category -- use SELECT DISTINCT to only get 1 of each category/subcategory
FROM products
;

SELECT * -- select all rows
FROM products -- in table, products
ORDER BY product_id DESC; -- order by the first column, ascending

SELECT * -- select all rows
FROM products -- in table, products
ORDER BY 1 DESC; -- order by the first column, ascending // can do column number OR column name

SELECT *
FROM products
where sub_category = 'Furnishings'
limit 100

/* which orders had a profit > $90 */
select *
from orders
where profit > 90

-- which returns include more than one quantity of item
SELECT *
FROM returns
WHERE return_quantity > 1;

SELECT *
FROM regions
WHERE (region = 'Americas'
OR region = 'APAC')
AND salesperson <> 'Anna Andreadi';

-- How many office supplies products do we offer?
SELECT product_name, category
FROM products
WHERE category = 'Office Supplies'
ORDER BY 1 ASC
;

-- how many chairs do we offer?
SELECT product_name, product_id, sub_category
FROM products
WHERE sub_category = 'Chairs'
;

-- what is the cheapest table we offer
SELECT sub_category, category, product_name, product_cost_to_consumer
FROM products
WHERE sub_category = 'Tables'
ORDER BY product_cost_to_consumer
;

-- How many office supplies products cost more than $500?
SELECT product_name, product_cost_to_consumer, category, sub_category
FROM products
WHERE product_cost_to_consumer > 500 AND category = 'Office Supplies'
;

-- How many office supplies products cost more than $500?
SELECT product_name, product_cost_to_consumer, category, sub_category
FROM products
WHERE product_cost_to_consumer > 500 AND category = 'Office Supplies'
;

--IN () allows you to specify multiple values in WHERE, while NOT IN () allows you to negate the list of values.
SELECT *
FROM products
WHERE category IN ('Furniture', 'Technology');


--BETWEEN () allows you to select values within a given range.
--1. Which products have a cost to consumers between $25 and $100?
SELECT *
FROM products
WHERE product_cost_to_consumer BETWEEN 25 AND 100;

--2. Which orders have sales between $50 and $100?
SELECT *
FROM orders
WHERE sales BETWEEN 50 AND 100;

--LIKE is used for pattern matching in SQL, while NOT LIKE negates the match.
--1. Which products have “Calculator” in the product name?
SELECT *
FROM products
WHERE product_name LIKE '%CALCULATOR%'
-- 2. Which products have “Printer” in the category name?
SELECT *
FROM products
WHERE product_name ILIKE '%PRINTER%';

-- WILDCARDS
--  Percent ( % ) for matching any sequence of characters.
-- Underscore ( _ ) for matching any single character.
-- 1. Which products have “Clock” in the product name?
SELECT *
FROM products
WHERE product_name ILIKE '%CLOCK%';
--2. Which customers have names that start with “A” and third letter of “r”?
SELECT *
FROM customers
WHERE customer_name LIKE 'A_r%';

-- who are the salespeople in the US?
SELECT DISTINCT salesperson
FROM regions
WHERE country ILIKE '%United States%'

-- who were the top 5 salespeople in the US?
SELECT DISTINCT order_id, sales
FROM orders
WHERE ship_mode ILIKE '%second%'
ORDER BY 2 DESC
LIMIT 5
;

-- how many countries are in the Americas region
SELECT DISTINCT country
FROM regions
WHERE region ILIKE '%America%'
;
SELECT DISTINCT country
FROM regions
WHERE region = 'Americas'
;

--Which tech products are sold to consumers in the $500–$1,000 range?
SELECT product_name, category, sub_category, product_cost_to_consumer
FROM products
WHERE category = 'Technology' AND product_cost_to_consumer BETWEEN 500 AND 1000
;

--How many product items were returned in 2019 for unknown reasons?
SELECT order_id, reason_returned, return_date
FROM returns
WHERE reason_returned ILIKE '%not given%' AND
-- order_id ILIKE '%2019%'
return_date ILIKE '%2019%'
;

-- How many Canon copiers do we offer? ************** only 43 not 61
SELECT product_name
FROM products
WHERE product_name ILIKE '%canon%'AND product_name ILIKE '%copier%'

--How many 3D printers do we offer?
SELECT product_name
FROM products
WHERE product_name ILIKE '%3D%' and product_name ILIKE '%printer%'

--What is the most expensive Cisco phone?
SELECT product_name, product_cost_to_consumer, sub_category
from products
WHERE product_name ILIKE '%cisco%' AND
sub_category = 'Phones'
ORDER BY 2 DESC

--How many products with “TEC” in the product_id cost between $400 and $600?
SELECT product_id, product_cost_to_consumer
FROM products
WHERE product_cost_to_consumer BETWEEN 400 and 600 AND
product_id ILIKE '%TEC%'

--How many products that cost between $500 and $1,000 are phones, machines, or copiers?
SELECT product_name, product_cost_to_consumer, sub_category
from products
where product_cost_to_consumer BETWEEN 500 AND 1000
AND (sub_category ILIKE '%Phones%' OR sub_category ILIKE '%Machines%' or sub_category ILIKE '%Copiers%') -- i get 61
-- where sub_category IN ('Copiers', 'Machines', 'Phones') AND product_cost_to_consumer BETWEEN 500 AND 1000 -- i get 61

-- The most commonly used aggregate functions are MIN, MAX, SUM, AVG, and COUNT.
SELECT SUM(profit)
FROM orders;
SELECT COUNT(*)
FROM orders;

-- Find the average height of people by sex.
SELECT sex, AVG(height) AS avg_height
FROM people
GROUP BY sex;

-- Find the average height of people taller than three feet by sex.
SELECT sex, AVG(height) AS avg_height
FROM people
WHERE height > 3
GROUP BY sex;

-- Determine which of those people have an average height greater than 5.5 feet tall, sorted by sex.
SELECT sex, AVG(height) AS avg_height
FROM people
WHERE height > 3
GROUP BY sex
HAVING AVG(height)>5.5;

-- can use the count(*) and store that in column num_sales
SELECT segment,
	count(*) as num_sales
FROM customers
GROUP BY segment -- need this when using
HAVING COUNT(*) > 300 -- this will filter out num_sales to be greater than 300

-- when to use group by?
-- when you need to say how to group the results.
select count(*) as num_sales -- count all rows from customers table
from customers
-- gives count of all sales in the customers Tables
-- to split the count(*) by something, use the GROUP BY
select count(*) as num_sales -- count all rows from customers table
from customers
group by segment
select count(*) as num_sales, segment, customer_name -- count all rows from customers table
from customers
group by segment, customer_name

/*
Superstore wants an order discount analysis to identify average order quantity
and amount by discount level. To write our query, we’ll use:
1. WHERE to filter discount levels greater than 15%.
2. GROUP BY in our query to aggregate quantity and sales.
3. HAVING to filter discount levels above an average sales threshold.
*/

-- CASTING
select sales -- sales is numeric
from orders
select sales::money -- CAST numeric TO MONEY
from orders

-- control decimals, use ROUND
SELECT discount,
      ROUND(AVG(quantity), 2) -- display rounded avg quantity as
      AS "qty",
      AVG(sales)::money as "sales"
from orders
group by discount

SELECT discount,
	ROUND(AVG(quantity), 2) AS "qty", -- aggregate of rounding of average quanitity
	AVG(sales)::money as "sales" -- aggregate of sales as money
FROM orders
WHERE 1 > 0.15 -- filtering out discounts > 15%
GROUP BY discount -- need this line
HAVING AVG(sales) > 500 -- more than 500 dollars
ORDER BY 3 DESC -- order by sales - money

-- find number of products per category
SELECT category, count(*) as category_total
FROM products
WHERE product_name ILIKE '%computer%' OR product_name ILIKE '%color%'

GROUP BY category
HAVING count(*) > 100
ORDER BY category_total DESC
LIMIT 100

-- find number of products per category
/*
Once you’ve filled in the parts of the starter code, try the following:
● Include only products with “computer” or “color” (case-insensitive) in the name.
● Further refine to those that have an aggregate 100 or more products.
● Alias your aggregate column to “count_of_products.”
● Sort the results by the “count_of_products” column.
● Limit the output to the first 10 rows.
*/
SELECT category, count(*) as count_of_products -- Alias your aggregate column to “count_of_products.”
FROM products
WHERE product_name ILIKE '%computer%' OR product_name ILIKE '%color%' -- Include only products with “computer” or “color” (case-insensitive) in the name

GROUP BY category
HAVING count(*) > 100 --Further refine to those that have an aggregate 100 or more products.

ORDER BY count_of_products DESC -- Sort the results by the “count_of_products” column.
LIMIT 10 -- Limit the output to the first 10 rows.

-- 1) How many sales in 2019?
SELECT COUNT(*) FROM orders WHERE DATE_PART('year', order_date) = 2019;
--2) What is our all-time most profitable month?
SELECT DATE_PART('month',order_date), SUM(profit) FROM orders GROUP BY 1 ORDER
BY 2 DESC
-- 3) Which month/year was our most profitable?
SELECT DATE_TRUNC('month', order_date), SUM(profit) FROM orders GROUP BY 1
ORDER BY 2 DESC

-- identify returns by reason
SELECT DISTINCT
orders.order_id
, orders.order_date
, returns.reason_returned
FROM orders
JOIN
returns ON orders.order_id =
returns.order_id


-- using aliases
SELECT
orders.order_id,
orders.order_date,
returns.return_date
FROM
orders
INNER JOIN returns
ON orders.order_id =
returns.order_id;
-- CAN BE SHORTENED TO
SELECT
a.order_id,
a.order_date,
b.return_date
FROM
orders a
INNER JOIN returns b
ON a.order_id = b.order_id;


-- find all orders joined on customer_ids
SELECT *
FROM orders a
JOIN customers b
ON a.customer_id = b.customer_id
LIMIT 100

-- adding a third table, key order_id
SELECT
a.order_id, b.customer_name, c.reason_returned -- add c to output
FROM orders a
JOIN customers b
ON a.customer_id = b.customer_id
join returns c -- add another join statement, including table c
on a.order_id = c.order_id -- indicate the key for a to c
LIMIT 100

-- using LEFT Join // using any JOIN can create NULLS -
-- inner can create nulls if null exists in the tables already
SELECT
o.order_id,
r.return_date
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
LIMIT 100;

--
SELECT
rg.salesperson
,r.reason_returned
,COUNT(o.order_id) AS count_of_returns
FROM orders o
JOIN regions rg ON o.region_id = rg.region_id
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 100;

-- union example from bluebikes2016 / bluebikes2017
select *
from bluebikes_2016
union
select *
from bluebikes_2017
