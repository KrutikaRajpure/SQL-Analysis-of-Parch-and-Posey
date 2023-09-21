-- There are 5 tables:
select *  from web_events;
select * from orders ;
select * from accounts;
select * from region ;
select * from sales_reps ;

-- 1. In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. 
--Pull these extensions and provide how many of each website type exist in the accounts table.

select right(website,3) as Web_address,
count(right(website,3))  
from accounts 
group by Web_address;

--OR

SELECT RIGHT(website,3) AS Extension,
COUNT(*) AS num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- 2. There is much debate about how much the name (or even the first letter of a company name) matters.
-- Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).

select upper(left (name,1)) as First_letter,
count(upper(left (name,1))) as Count_Letter
from accounts
group by First_letter
order by Count_Letter asc;

-- 3. Use the accounts table and a CASE statement to create two groups:
-- one group of company names that start with a number and a second group of those company names that start with a letter. 
-- What proportion of company names start with a letter?

select Company_Groups,count(Company_Groups)
from
(select name,
case when upper(left (name,1)) in ('0','1','2','3','4','5','6','7','8','9') then 'Company with Number'
else 'Company with Letter' end as Company_Groups 
from accounts) sub
group by Company_Groups;

-- 4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
select Company_Groups,count(Company_Groups)
from
(select name,
case when lower(left (name,1)) in ('a','e','i','o','u') then 'Company with Vowels'
else 'Company without Vowels' end as Company_Groups 
from accounts) sub
group by Company_Groups;



-- Quizzes POSITION & STRPOS

-- 1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
select a.primary_poc as full_name,
Left(a.primary_poc,strpos(primary_poc,' ')-1) as first_name,
right(a.primary_poc,length(a.primary_poc) - position (' 'in a.primary_poc)) as last_name
from accounts a ;

-- 2. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
select sr.name as full_name,
left(sr.name, strpos(sr."name",' ')-1) as first_name,
right(sr.name,length(sr."name") - position(' 'in sr."name")) as last_name
from sales_reps sr;

-- Quizzes CONCAT
-- 1. Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the 
-- first name of the primary_poc . last name primary_poc @ company name .com.
select concat(first_name,('.'),last_name,('@'),company_name) as Email_address
from 
(select Left(a.primary_poc,strpos(primary_poc,' ')-1) as first_name,
right(a.primary_poc,length(a.primary_poc) - position (' 'in a.primary_poc)) as last_name,
right(a.website,length(a.website)-length('www.')) as company_name
from accounts a) sub;


WITH sub1 AS(
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
	RIGHT(primary_poc, LENGTH(Primary_poc) - POSITION(' ' IN primary_poc)) AS last_name FROM accounts )
SELECT first_name, last_name, CONCAT(first_name,('.'), last_name, '@', name, '.com') AS email_address
FROM sub1;


-- 2. You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. 
--See if you can create an email address that will work by removing all of the spaces in the account name,
-- but otherwise your solution should be just as in question 1
WITH sub1 AS(
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name, RIGHT(primary_poc, LENGTH(Primary_poc) - POSITION(' ' IN primary_poc)) AS last_name FROM accounts )
SELECT first_name, last_name, CONCAT(first_name,('.'), last_name, '@',TRIM(name), '.com') AS email_address
FROM sub1;

-- 3. We would also like to create an initial password, which they will change after their first log in. 
--The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), 
--the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, 
--the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
select first_name,last_name,company,concat(left(first_name,1),right(first_name,1),left(last_name,1),right(last_name,1),length(first_name),length(last_name),company) as initial_password
from 
(select lower(Left(a.primary_poc,strpos(primary_poc,' ')-1)) as first_name,
lower(right(a.primary_poc,length(a.primary_poc) - position (' 'in a.primary_poc))) as last_name,
REPLACE(UPPER(name), ' ', '') as company
from accounts a) sub;


 WITH sub1 AS(                                                   
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
	FROM accounts)      
SELECT first_name, last_name,
CONCAT(LEFT(LOWER(first_name), 1), RIGHT(LOWER(first_name), 1), LEFT(LOWER(last_name), 1), RIGHT(LOWER(last_name), 1), LENGTH(first_name), LENGTH(last_name), REPLACE(UPPER(name), ' ', '')) AS password
FROM sub1;

ROLLBACK;
START TRANSACTION;