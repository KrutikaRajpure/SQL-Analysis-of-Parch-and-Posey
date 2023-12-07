-- SUBQUERIES
-- 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
select sub1.region, max(sub1.Total_amt) from 
(select  s.name,r.name as region ,SUM(o.total_amt_usd) as Total_amt from 
sales_reps s join accounts a on s.id = a.sales_rep_id 
join orders o on a.id =o.account_id 
join region r on r.id = s.region_id 
group by s.name,r.name) sub1 
group by region;

select s.name as sale_name, r.name as region, sum(o.total_amt_usd) as Total_amt from 
sales_reps s join accounts a on a.sales_rep_id = s.id 
join orders o on a.id = o.account_id 
join region r on s.region_id = r.id
group by sale_name, region;

select sub2.region,sub3.sale_name,sub2.Max_Amt 
from 
(select sub1.region, max(sub1.Total_amt) as Max_Amt
from 
(select  s.name sale_rep,r.name as region ,SUM(o.total_amt_usd) as Total_amt from 
sales_reps s join accounts a on s.id = a.sales_rep_id 
join orders o on a.id =o.account_id 
join region r on r.id = s.region_id 
group by s.name,r.name) as sub1 
group by region) as sub2 join
(select s.name as sale_name, r.name as region, sum(o.total_amt_usd) as Total_amt from 
sales_reps s join accounts a on a.sales_rep_id = s.id 
join orders o on a.id = o.account_id 
join region r on s.region_id = r.id
group by sale_name, region) as sub3 
on sub2.region=sub3.region and sub3.Total_amt=sub2.Max_Amt;


-- 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

select r.name as region, SUM(o.total_amt_usd) as Total_amt from sales_reps sr join
region r on sr.region_id = r.id join 
accounts a on a.sales_rep_id = sr.id join 
orders o on a.id = o.account_id 
group by 1 order by 2 desc limit 1;

select r.name, count(o.id) 
from sales_reps sr 
join region r on sr.region_id = r.id 
join accounts a on a.sales_rep_id = sr.id 
join orders o on a.id = o.account_id
where r.name = (select region 
                from (select r.name as region, SUM(o.total_amt_usd) as Total_amt 
                from sales_reps sr 
                join region r on sr.region_id = r.id 
                join accounts a on a.sales_rep_id = sr.id 
                join orders o on a.id = o.account_id 
                group by 1 order by 2 desc limit 1)sub)
group by 1 order by 2 desc;

-- 3. How many accounts had more total purchases than the account name which has bought the most 
-- standard_qty paper throughout their lifetime as a customer?
select count(*) from 
(select a.name from orders o 
join accounts a on a.id = o.account_id 
group by 1
having sum(o.total)> 
(select total_purchases from 
(select a.name as name, sum(o.standard_qty) as standard_qty, sum(o.total) as total_purchases
from accounts a 
join orders o on a.id = o.account_id 
group by 1
order by 2 desc 
limit 1)sub)
)sub2;

-- 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
-- how many web_events did they have for each channel?
--MY CODE
select channels, Count(*) 
from 
(select we.channel as channels, we.account_id  from web_events we where
we.account_id = (select acc_id from (select a.id  as acc_id, a.name as name_acc, sum(o.total_amt_usd) as Total_Spend  from orders o 
join accounts a on a.id = o.account_id 
group by 1,2
order by 3 desc limit 1)sub))sub1
group by 1;

SELECT a.name, w.channel, COUNT(*)
FROM accounts AS a
JOIN web_events as w
ON w.account_id = a.id AND a.id = 
(SELECT id                                
FROM (SELECT a.id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 3 DESC
      LIMIT 1) sub )
GROUP BY 1,2;

-- 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(total_spent)
FROM(SELECT a.name AS account_name, SUM(total_amt_usd) AS total_spent
FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 10) sub;

-- 6. What is the lifetime average amount spent in terms of total_amt_usd, 
-- including only the companies that spent more per order, on average, than the average of all orders.
select avg(avg) from(
select o.account_id, avg(o.total_amt_usd)  from orders o 
group by 1
having avg(o.total_amt_usd)>
(select avg(o.total_amt_usd) from orders o))sub;
 
    
-- WITH Common Table Expressions (CTEs)
-- 1. Find the average number of events for each channel per day        
     
with base as (
				select extract (day from occurred_at) AS day,we.channel , count(we.id) as counts 
				from web_events we
				group by 1,2)
SELECT channel, AVG(counts) AS average_events
FROM base
GROUP BY channel
ORDER BY 2 DESC;
     
-- 2. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
with base1 as(
				select sr.name as sales_reps_name, r.name as region, Sum(o.total_amt_usd)  as Total_amt 
				from sales_reps sr 
				join region r on sr.region_id =r.id
				join accounts a on a.sales_rep_id = sr.id 
				join orders o on o.account_id =a.id 
				group by 1,2
				order by 3 desc),
base2 as(
				select region, Max(total_amt) as total_amt
				from base1
				group by 1 
				order by 2 desc)
select sales_reps_name, base1.region, base1.total_amt from base1 join base2 on base1.region = base2.region and base1.Total_amt=base2.total_amt;

-- 3. For the region with the largest sales total_amt_usd, how many total orders were placed?    
WITH sub1 AS (
		SELECT r.name AS region_name, SUM(o.total_amt_usd) AS total_amt
        FROM sales_reps AS s
        JOIN accounts AS a
        ON a.sales_rep_id = s.id
        JOIN orders AS o
        ON o.account_id = a.id
        JOIN region as r
        ON r.id = s.region_id
        GROUP BY 1 ),
sub2 AS (
		SELECT MAX(total_amt)
		FROM sub1 )
SELECT r.name AS region_name, COUNT(o.total) AS total_order
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
JOIN region as r
ON r.id = s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT * FROM sub2);

-- 4. How many accounts had more total purchases than the account name which has bought the most standard_qty paper 
--throughout their lifetime as a customer?
WITH sub1 AS (
      SELECT a.name AS account_name, SUM(o.standard_qty) AS max_standard_paper, SUM(o.total) AS total_purchases
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY a.name
      ORDER BY 2 DESC
      LIMIT 1 ),
sub2 AS (
SELECT a.name
      FROM orders AS o
      JOIN accounts AS a
      ON a.id = o.account_id
      GROUP BY a.name
      HAVING SUM(o.total) > (SELECT total_purchases FROM sub1))
SELECT COUNT(*)
FROM sub2;


-- 5. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
WITH sub1 AS (
      SELECT a.id, a.name AS account_name, SUM(o.total_amt_usd) total_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM sub1)
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 6. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH sub1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 10)
SELECT AVG(total_spent) Avg_spent
FROM sub1;
       