-- FUll Outer Join
-- 1. find each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
select a.id as "Account id", a.name as "Company", sr.id as "SR id", sr.name as "Sr Name" 
from accounts a full outer join sales_reps sr on 
a.sales_rep_id =sr.id;

-- 2. but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty
select * from accounts a 
full outer join sales_reps sr on
a.sales_rep_id=sr.id 
where a.id is null or sr.id is null;

-- Quiz: JOINs with Comparison Operators
-- write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and 
-- joins it using the < comparison operator on accounts.primary_poc and sales_reps.name

select * from accounts a 
left join sales_reps sr on  
a.sales_rep_id =sr.id and a.primary_poc < sr.name ;

-- Quiz: UNION
-- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table.
select * from accounts a1 union all select * from accounts a2;

-- Pretreating Tables before doing a UNION
-- Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney

select * from accounts a 
where a.name='Walmart' union all 
select * from accounts a2 where a2.name='Disney';

