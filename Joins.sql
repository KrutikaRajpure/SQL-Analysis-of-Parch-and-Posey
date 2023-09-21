-- QUESTIONS
-- 1. Pull all the data from the accounts table, and all the data from the orders table

select * from accounts a join orders o on a.id =o.account_id;

-- 2. Pull standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.

select o.standard_qty, o.gloss_qty, o.poster_qty , a.website ,a.primary_poc 
from orders o join accounts a 
on a.id = o.id;

-- 3. Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
-- Be sure to include the primary_poc, time of the event, and the channel for each event. 
-- Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

select *  from web_events;
select *  from accounts a ;
select * from region ;
select * from orders ;
select * from sales_reps ;

select a.primary_poc, a.name , we.occurred_at , we.channel  from accounts a 
join web_events we on a.id =we.account_id where a.name ='Walmart';

-- 4. Provide a table that provides the region for each sales_rep along with their associated accounts.
-- Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

select sr.name , r.name,a.name from accounts a join 
sales_reps sr on a.sales_rep_id =sr.id join 
region r on r.id =sr.region_id ;

-- 5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
-- Your final table should have 3 columns: region name, account name, and unit price.
select r.name,a.name,(o.total_amt_usd /(o.total+0.01 )) as unit_price 
from region r
join sales_reps sr
on sr.region_id  =r.id  
join accounts a 
on a.sales_rep_id  =sr.id
join orders o 
on o.account_id =a.id ;

-- 6. Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.


SELECT r.name region, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND r.name = 'Midwest'
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name ASC;

-- 7. Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

select r.name,s.name,a.name
from region r 
join sales_reps s
on s.region_id = r.id 
and r.name='Midwest'
and s.name like 'S%'
join accounts a 
on a.sales_rep_id =s.id 
order by a.name asc;

-- 8. Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

select r.name,s.name,a.name
from region r 
join sales_reps s
on s.region_id = r.id 
and r.name='Midwest'
and s.name like '% K%'
join accounts a 
on a.sales_rep_id =s.id 
order by a.name asc;

select r.name,s.name,a.name
from region r 
join sales_reps s
on s.region_id = r.id 
and r.name='Midwest'
and right(s.name,length(s."name") - position(' 'in s."name")) like 'K%'
join accounts a 
on a.sales_rep_id =s.id 
order by a.name asc;

-- 9. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
-- However, you should only provide the results if the standard order quantity exceeds 100. 
--Your final table should have 3 columns: region name, account name, and unit price.

select  r.name, a.name, o.total_amt_usd /(o.total+0.01) as unit_price from region r 
join sales_reps sr on sr.region_id =r.id 
join accounts a on a.sales_rep_id=sr.id 
join orders o on o.account_id =a.id where o.standard_qty > 100 ;

-- 10. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
--Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first

select  r.name, a.name, o.total_amt_usd /(o.total+0.01) as unit_price from region r 
join sales_reps sr on sr.region_id =r.id 
join accounts a on a.sales_rep_id=sr.id 
join orders o on o.account_id =a.id where o.standard_qty > 100 and o.poster_qty >50 order by unit_price asc ;

-- 11. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
--Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first

select  r.name, a.name, o.total_amt_usd /(o.total+0.01) as unit_price from region r 
join sales_reps sr on sr.region_id =r.id 
join accounts a on a.sales_rep_id=sr.id 
join orders o on o.account_id =a.id where o.standard_qty > 100 and o.poster_qty >50 order by unit_price desc  ;

-- 12. What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. 
--You can try SELECT DISTINCT to narrow down the results to only the unique values.
select distinct  a.name,we.channel from web_events we
join accounts a on we.account_id =a.id where we.account_id = 1001;

-- 13. Find all the orders that occurred in 2015. 
--Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;