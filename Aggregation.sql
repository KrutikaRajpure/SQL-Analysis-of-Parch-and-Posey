--TABLES
select * from accounts;
select * from region;
select * from orders;
select * from sales_reps;
select * from web_events;

---------------------------------------------------------------------------------------------------------------------------------------
--SUM
------ 1. Find the total amount of poster_qty paper ordered in the orders table.
select sum(o.poster_qty)  total_poster_qty from orders o ;
------ 2. Find the total amount of standard_qty paper ordered in the orders table.
select Sum(o.standard_qty) from orders o ;
------ 3. Find the total dollar amount of sales using the total_amt_usd in the orders table.
select sum(o.total_amt_usd) from orders o ;
------ 4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
-- This should give a dollar amount for each order in the table
select id, o.gloss_amt_usd + o.standard_amt_usd as total_amount from orders o ;

------ 5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) total_amt_per_unit FROM orders;

---------------------------------------------------------------------------------------------------------------------------------------
--MIN, MAX, AVG
------ 1. When was the earliest order ever placed? 
select min(o.occurred_at) as Earliest_order_date from orders o ;
------ 2. Try performing the same query as in question 1 without using an aggregation function.
select o.occurred_at from orders o order by o.occurred_at asc limit 1;
------ 3. When did the most recent (latest) web_event occur?
select  max(o.occurred_at) from orders o;
------ 4. Try to perform the result of the previous query without using an aggregation function
select o.occurred_at from orders o order by o.occurred_at desc limit 1 ;
------ 5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
-- Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
select avg(o.standard_qty), avg(o.gloss_qty),avg(o.poster_qty),
avg(o.standard_amt_usd),avg(o.gloss_amt_usd),avg(o.poster_amt_usd)
from orders o ;

---------------------------------------------------------------------------------------------------------------------------------------
--- GROUP BY

------ 1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
select a.name, min(o.occurred_at) as Earliest_order
from orders o join accounts a 
on o.account_id =a.id group by a.name;

------ 2. Find the total sales in usd for each account. 
--You should include two columns - the total sales for each company's orders in usd and the company name.
select a.name, sum(o.total_amt_usd)
from orders o join accounts a 
on a.id =o.account_id group by a.name ;

------ 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
--Your query should return only three values - the date, channel, and account name.
select we.channel, max(we.occurred_at) , a.name 
from web_events we join accounts a on we.account_id =a.id group by we.channel,a.name ;

------ 4. Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.
select we.channel, count(we.channel) from web_events we group by we.channel  ;

------ 5. Who was the primary contact associated with the earliest web_event?
select a.primary_poc, min(we.occurred_at) from accounts a join web_events we 
on a.id =we.account_id group by a.primary_poc  ;


SELECT w.occurred_at, a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at ASC
LIMIT 1;

------ 6. What was the smallest order placed by each account in terms of total usd. 
--Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
select a.name, min(o.total_amt_usd) from accounts a join orders o on a.id =o.account_id group by a.name;

------ 7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. 
--Order from fewest reps to most reps.
select r.name, count(sr.name)  from region r join sales_reps sr  on r.id = sr.region_id group  by r.name;

------ 8. For each account, determine the average amount of each type of paper they purchased across their orders.
-- Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name account_name, ROUND(AVG(standard_qty)) Avg_standard_qty, ROUND(AVG(gloss_qty)) Avg_gloss_qty, ROUND(AVG(poster_qty)) Avg_poster_qty
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

------ 9. For each account, determine the average amount spent per order on each paper type. Your result should have four columns 
-- one for the account name and one for the average amount spent on each paper type.

SELECT a.name account_name, ROUND(AVG(standard_amt_usd)) Avg_standard_amt, ROUND(AVG(gloss_amt_usd)) Avg_gloss_amt, 
ROUND(AVG(poster_amt_usd)) Avg_poster_amt
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;


------ 10. Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences first
select sr.name,we.channel, count(*)
from web_events we join 
accounts a on we.account_id =a.id join 
sales_reps sr on a.sales_rep_id =sr.id
group by sr.name, we.channel 
order by count desc ;

------ 11. Determine the number of times a particular channel was used in the web_events table for each region. 
--Your final table should have three columns - the region name, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences first.                          
 select r.name,we.channel,count(*)
 from web_events we join accounts a on we.account_id =a.id 
 join sales_reps sr on sr.id =a.sales_rep_id 
 join region r on r.id =sr.region_id 
group by r.name,we.channel
order by count desc  ;

---------------------------------------------------------------------------------------------------------------------------------------
-- DISTINCT

------ 1. Use DISTINCT to test if there are any accounts associated with more than one region.

select distinct  a.id, r.name from accounts a 
join sales_reps sr on a.sales_rep_id =sr.id 
join region r on sr.region_id =r.id ;

------ 2. Have any sales reps worked on more than one account?


SELECT s.id, s.name, COUNT(a.sales_rep_id)
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY COUNT(a.sales_rep_id);

--------------------------------------------------------------------------------------------------------------------------------------
-- HAVING

------ 1.  How many of the sales reps have more than 5 accounts that they manage?
select sr.name,  count(a.sales_rep_id) from sales_reps sr 
join accounts a on a.sales_rep_id =sr.id 
group by sr.name
having count(a.sales_rep_id)>5;

------ 2. How many accounts have more than 20 orders?
select a.id ,a.name, count(o.account_id) from accounts a join orders o on a.id =o.account_id 
group by a.id,a.name 
having count(o.account_id)>20
order by count desc ;

------ 3. Which account has the most orders?
select a.id ,a.name, max(o.account_id) from accounts a join orders o on a.id =o.account_id 
group by a.id,a.name 
order by max desc ;


------ 4. How many accounts spent more than 30,000 usd total across all orders?
select a.id ,a.name,count(*), sum(o.total_amt_usd) from accounts a join orders o on a.id =o.account_id 
group by a.id,a.name 
having sum(o.total_amt_usd)>30000
order by sum desc ;


------ 5. Which accounts spent less than 1,000 usd total across all orders?

SELECT a.id, a.name account_name, COUNT(*) num_of_orders, sum(total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) < 1000
ORDER BY total_spent DESC;

------ 6. Which account has spent the most with us?

SELECT a.id, a.name account_name, SUM(total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

------ 7. Which account has spent the least with us?
SELECT a.id, a.name account_name, SUM(total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

------ 8. Which accounts used facebook as a channel to contact customers more than 6 times?
select a.name,we.channel, count(*) from accounts a join web_events we 
on we.account_id=a.id 
where we.channel ='facebook' 
group by a.name,we.channel 
having count(*) > 6 
order by count desc; 


------ 9. Which account used facebook most as a channel?

------ 10. Which channel was most frequently used by most accounts?
SELECT a.id, a.name account_name, w.channel, COUNT(w.channel) num_of_use
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY COUNT(w.channel) DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------------------------------------
--DATE Functions

------ 1. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least.
select DATE_PART('year',occurred_at), sum(o.total_amt_usd) 
from orders o
group by 1 
order by 2 desc;

SELECT year(occurred_at), SUM(total_amt_usd) sales -- year is used in mysql while DATE_PART is used in Postgresql
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


------ 2. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
select date_part('month',o.occurred_at) , sum(o.total_amt_usd)
from orders o
group by 1
order by 2;

SELECT Month(occurred_at), SUM(total_amt_usd) sales -- syntax for MySQL
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

------ 3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year',occurred_at) , SUM(total) orders -- syntax for Postgresql
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


------ 4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
SELECT DATE_PART('month',occurred_at) , SUM(total) orders  -- syntax for Postgresql
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;


------ 5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month',o.occurred_at) order_date, SUM(o.gloss_amt_usd) gloss_amt_usd  -- syntax for Postgresql
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


SELECT EXTRACT(YEAR_MONTH FROM o.occurred_at) order_date, SUM(o.gloss_amt_usd) gloss_amt_usd  -- syntax for MySql
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

---------------------------------------------------------------------------------------------------------------------------------------
--CASE Functions

------ 1. Write a query to display for each order, the account ID, total amount of the order, 
--and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000
SELECT account_id, total_amt_usd,
   CASE WHEN total_amt_usd >= 3000 THEN 'Large'
   ELSE 'Small' END AS order_level
FROM orders;

------ 2. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
---The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
select 
case when total  >= 2000 then 'At Least 2000'
	     when total < 2000 and total > 1000 then 'Between 1000 and 2000'
	     ELSE 'Less than 1000' END AS num_of_orders,
	     count(*) as order_count
from orders o
group by 1;

------ 3. We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
--The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
--The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
--Provide a table that includes the level associated with each account. 
--You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
select a.name,sum(o.total_amt_usd),
case
	when sum(o.total_amt_usd) > 200000 then 'Top_Level'
	when sum(o.total_amt_usd)<2000000 and sum(o.total_amt_usd)>1000000 then 'Middle_Level'
	else 'Lowest_level' 
end as customer_levels
from accounts a 
join orders o on a.id =o.account_id 
group by a.name
ORDER BY 2 DESC;


------ 4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. 
--Keep the same levels as in the previous question. Order with the top spending customers listed first.

select a.name,sum(o.total_amt_usd),
case
	when sum(o.total_amt_usd) > 200000 then 'Top_Level'
	when sum(o.total_amt_usd)<2000000 and sum(o.total_amt_usd)>1000000 then 'Middle_Level'
	else 'Lowest_level' 
end as customer_levels
from accounts a 
join orders o on a.id =o.account_id 
WHERE occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
group by a.name
ORDER BY 2 DESC;

------5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders.
--Place the top sales people first in your final table.
SELECT s.name sales_rep, COUNT(total) total_orders,
   CASE  
   		WHEN COUNT(total) > 200 THEN 'Top'
		ELSE 'Not' END AS Sales_rep_Level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;


------6. The previous didn't account for the middle, nor the dollar amount associated with the sales. 
--Management decides they want to see these characteristics represented as well. 
--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales.
--The middle group has any rep with more than 150 orders or 500000 in sales. 
--Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria.
--Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

SELECT s.name sales_rep, COUNT(*) total_orders, SUM(o.total_amt_usd) total_spent,
   CASE  
   		WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'Top'
        WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'Middle'
		ELSE 'Low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;
