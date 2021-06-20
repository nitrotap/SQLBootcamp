-- SQL Study Guide
-- 06/19/2021
-- Kartik Jevaji

-- database info
/* https://analyticsga-global.generalassemb.ly/browser/
Username: analytics_student@generalassemb.ly
Password: analyticsga
*/
/* Entity Relationship Diagram (ERD)
An ERD shows the relationships of entity sets stored in a database
Returns: Primary Key(PK): order_id   Foreign Keys(FK): return_date, return_quantity, reason_returned
Customers: PK: customer_id
Products: PK: product_id
Regions: PK: region_id
Orders: PK: order_id FK: customer_id, product_id, region_id
*/

-- SQL Order of Construction
SELECT -- picks the columns
SELECT DISTINCT -- returns a unique combination of values for all columns selected, name the columsn you want, without duplicates
FROM -- points to the tables
JOIN -- (also called INNER JOIN) used to combine data across two different tables, name the primary table
     -- CREATES NULLS
LEFT JOIN -- loads all entries that appear in the first table with NULLs where there is no match, name the secondary table
RIGHT JOIN -- loads all entries that appear in the second table with NULLS with no match, name the secondary table
ON -- Specify the KEY to join the two tables, set keys equal to each other // orders.region_id = regions.region_id
UNION --  Combine rows from multiple tables with the SAME columns
-- follow UNION with SELECT col1 // FROM table2
WHERE -- puts filters on rows
GROUP BY -- aggregates across values of a variable
HAVING -- filters aggregated values after they have been grouped
ORDER BY -- sorts the results, // column1 (ASC/DESC)
LIMIT -- limits results to the first n rows
;

/* Practicing Good SQL Grammar
Common punctuation:
● Signal the end of your SQL query with a semicolon (;).
● Commas separate column names in an output list (,).
● Use single quotations around text/strings ('Nokia').
Query code spacing:
● SQL only requires a single white space to separate elements.
● Carriage returns are often used to enhance readability.
Notes within queries:
● Always provide comments (source, revision, author, etc.).
● Comments are made after typing double dashes or the pair /* */

-- SELECT DISTINCT examples
-- who are the salespeople in the US?
SELECT DISTINCT salesperson
FROM regions
WHERE country ILIKE '%United States%'
;

-- who were the top 5 salespeople in the US?
SELECT DISTINCT order_id, sales
FROM orders
WHERE ship_mode ILIKE '%second%'
ORDER BY 2 DESC
LIMIT 5
;

-- COUNT DISTINCT examples
select order_id, count(DISTINCT(ship_date))
from Orders
group by order_id
order by 1
;

/* WHERE  -- FILTERING the data
List of Operators
<>, != Not equal to.
>, >= Greater than; greater than or equal to.
<, <= Less than; less than or equal to.
AND: Returns if both conditions are true.
OR: Returns if either condition is true (FALSE if neither is true).
( ): Parentheses group conditions to set all equal to TRUE.
IN(): Found in a list of items
BETWEEN(): Within the range of, including boundaries
NOT: Negates a conditions
LIKE, ILIKE: Contains item; ILIKE disregards case
%: Wildcard; none to many characters
_: Wildcard; single characters
*/

/* How many product items were returned in 2019 for unknown reasons?*/
SELECT order_id, reason_returned
FROM Returns
WHERE order_id ILIKE '___2019%' AND reason_returned = 'Not Given'
;

/* Now, I want to pull in the product name*/
SELECT returns.reason_returned, orders.product_id, products.product_name
FROM Returns
	JOIN orders ON returns.order_id = orders.order_id
	JOIN products ON orders.product_id = products.product_id
WHERE returns.order_id ILIKE '___2019%' AND reason_returned = 'Not Given'
;

/* JOINing multiple tables, table a, b, and c with fields field1, field2, field3, field4*/
SELECT table1.field3, table1.field4, table2.field2, table3.field4
FROM table1
    JOIN table2 ON table1.field1 = table2.field1 -- field1 is PK
    JOIN table3 ON table1.field2 = table3.field1 -- table1.field2 is PK table3.field1
WHERE table1.field1 ILIKE '___2019' AND table1.field1 = 'Not Given'
ORDER BY table3.field4


/* AGGREGATE functions
The most commonly used aggregate functions are MIN, MAX, SUM, AVG, and COUNT.
*/
SELECT SUM(profit), COUNT(*), AVG(discount), MAX(sales), MIN(sales)
FROM orders;

-- can name aggregate columns
SELECT SUM(profit) as totalprofit, COUNT(*) as totalorders, MAX(sales) as highestsale, MIN(sales) as smallestSale
FROM orders;

/*
GROUP BY
-- Used when you want to group results by ROWS
-- when you need to say how to group the results; combine rows into groups

HAVING -- Used to filter measures you've aggregated (ex. to filter a sum of more than a certain value)

*/
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
;

-- I want profit by sub_category
SELECT products.sub_category, SUM(orders.profit)
FROM orders
	JOIN products ON orders.product_id = products.product_ID
GROUP BY products.sub_category


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

-- breakdown of discount, number and sales
SELECT discount,
	ROUND(AVG(quantity), 2) AS "qty", -- aggregate of rounding of average quanitity
	AVG(sales)::money as "sales" -- aggregate of sales as money
FROM orders
WHERE 1 > 0.15 -- filtering out discounts > 15%
GROUP BY discount -- need this line
HAVING AVG(sales) > 500 -- more than 500 dollars
ORDER BY 3 DESC -- order by sales - money

-- I want product name with discounts over 11% with average quantity and average sales
SELECT products.product_name, discount,
    ROUND(AVG(quantity), 2) AS "avgQuantity", -- average of quantity rounded to 2 decimal points
    AVG(sales) AS "avgSales"
FROM orders
	JOIN products ON orders.product_id = products.product_id
GROUP BY products.product_name, discount
HAVING discount > .11
ORDER BY products.product_name

-- identify returns by reason
SELECT DISTINCT
orders.order_id
, orders.order_date
, returns.reason_returned
FROM orders
JOIN
returns ON orders.order_id =
returns.order_id

-- identify returns by reason with number of returns
SELECT DISTINCT
	returns.reason_returned,
	products.product_name,
	count(products.product_name) AS numberofreturns
FROM orders
JOIN returns ON orders.order_id = returns.order_id
JOIN products ON orders.product_id = products.product_id
GROUP BY returns.reason_returned, products.product_name
;


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
;

-- adding a third table, key order_id
SELECT
a.order_id, b.customer_name, c.reason_returned -- add c to output
FROM orders a
JOIN customers b
ON a.customer_id = b.customer_id
join returns c -- add another join statement, including table c
on a.order_id = c.order_id -- indicate the key for a to c
;

-- using LEFT Join // using any JOIN can create NULLS -
-- inner can create nulls if null exists in the tables already
-- KEEP ALL ENTRIES in table1 / orders
SELECT
orders.order_id,
returns.return_date,
returns.reason_returned,
products.product_name
FROM orders
LEFT JOIN returns ON orders.order_id = returns.order_id
LEFT JOIN products ON orders.product_id = products.product_id
ORDER BY returns.return_date
;

SELECT
rg.salesperson,
r.reason_returned,
COUNT(o.order_id) AS CountOfReturns
FROM orders o
JOIN regions rg ON o.region_id = rg.region_id
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY 1, 2
ORDER BY 3 DESC
;


-- union example from bluebikes2016 / bluebikes20174
-- SAME COLUMNS
-- adding 2017-2019 data to 2016
SELECT *
FROM bluebikes_2016
UNION
SELECT *
FROM bluebikes_2017
UNION
SELECT *
FROM bluebikes_2018
UNION
SELECT *
FROM bluebikes_2019
