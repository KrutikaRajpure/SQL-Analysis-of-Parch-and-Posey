# SQL-Analysis-of-Parch-and-Posey
SQL Analysis on company dataset named Parch-and-Posey.
# Introduction
I queried the Parch and Posey paper company database using MySQL and PostgreSQL. Parch and Posey is an online paper company that sells different paper types (Standard, Poster, and Gloss). It is worth noting that this dataset does not represent a particular company. It was developed for learning purposes.

The database consists of over 15000 rows and 5 different tables namely:

Orders
Accounts
Web_events
Sales_reps
Region
Below is the Schema of the database


<img width="750" alt="Parch Posey_Schema" src="https://github.com/KrutikaRajpure/SQL-Analysis-of-Parch-and-Posey/assets/59536968/d2b5dfc8-af74-4e6c-aaca-94f0bf27729b">

# Creating Database
I created the database in MySQL workbench for the analysis. The query for creating the database can be copied from Parch&Posey_database and you can load it into any server of your choice.

Note: you might need to tweak the syntax to suit the database you are using.

# Skills and Concepts Demonstrated

## 1.Basic SQL
These includes using syntax such as SELECT, FROM, WHERE, ORDERBY, IN, BETWEEN, LIKE, AND, & LIMIT

I also demonstrated how to write SQL queries in a Python environment. This is useful when you want to display the output of each query in the next cell. To do this, I made use of a Jupyter Notebook to write my SQL queries. The steps needed to follow are shown below

install ipython-sql libaray using the syntax
pip install ipython-sql
Load External SQL Module
%load_ext sql
Now Connect to the Database
%sql mysql+pymysql://username:password@localhost/database_name for mysql
sqlite:///yourdatabase.sqlite for Sqlite
postgres://name:password@localhost:6259/database_name or
postgres://localhost:6259/database_name for postgre

After successfully connecting to the database, one can now start writing SQL queries in the Python environment but note that one needs to start each query with %sql or %%sql as demonstrated below

## 2.Aggregates funtions : 
These functions are used to perform operations on a set of values to return a single value. They can be used to summarise data. They include SUM, COUNT, MIN, MAX, AVG, GROUP BY, HAVING etc

## 3.JOINS:
There are cases whereby one needs to join two or more tables together to be able to generate more insights from the datasets, this is where the use of the Join comes in. There are several types of Joins such as Inner Join, Outer Join, Left join, and Right join. You can learn more about the use of these joins 

## 4. Subqueries and Temporary Tables: 
Both subqueries and table expressions are methods used to write a query that creates a table, and then write another query that interacts with this newly created table. To create a CTE, we use the WITH syntax

## 5. Windows Functions:
It allows one to do a comparison between rows without doing any join. It can be used to calculate the running total of a column. It uses syntax such as OVER, PARTITION and ORDER BY, RANK, ROW NUMBER, LEAD and LAG. Examples of how Window functions work are shown below
   
Thanks for going through my analysis, I hope you do find it useful.

