#--------BEGINS LAB- ADVANCED - MYSQL---------------#

#Challenge 1 -----Step 1  Calculate the royalties of each sales for each author

CREATE TEMPORARY TABLE publications.sales_temp 
SELECT au.au_id AS "au_id",
ti.title_id as 'title_id',  ti.price * sa.qty * ti.royalty/100* ta.royaltyper /100 as "sales_royalty"
FROM authors AS au
INNER JOIN titleauthor AS ta ON au.au_id = ta.au_id
LEFT JOIN titles AS ti ON ta.title_id = ti.title_id
LEFT JOIN sales as sa ON ti.title_id = sa.title_id
ORDER BY ti.price * sa.qty * ti.royalty/100* ta.royaltyper /100 desc;

SELECT  sales_temp.au_id, sales_temp.title_id, sales_temp.sales_royalty
FROM publications.sales_temp;


#Challenge 1 -----Step 2 Aggregate the total royalties for each title for each author

SELECT sales_temp.au_id, sales_temp.title_id, sum(sales_temp.sales_royalty)
FROM publications.sales_temp
GROUP BY sales_temp.au_id, sales_temp.title_id
ORDER BY sales_temp.au_id desc;


#Challenge 1----STEP 3  Calculate the total profits of each author

CREATE TABLE publications.total_profits
SELECT temp.au_id as 'Author_ID', temp.title_id as 'Title_ID', sum(temp.sales_royalty) as 'Total_Royalties', 
ti.advance as 'Advance', sum(temp.sales_royalty) + ti.advance as 'Total_profits'
FROM publications.sales_temp as temp
LEFT JOIN titles AS ti ON temp.title_id = ti.title_id
GROUP BY temp.au_id, temp.title_id
ORDER BY sum(temp.sales_royalty) + ti.advance desc;
#LIMIT 3;


#--------CHALLENGE 2 ---------DOING THE SAME WITH SUBQUERIES

#Challenge 2 -----Step 1  Calculate the royalties of each sales for each author

SELECT au.au_id AS "au_id",
ti.title_id as 'title_id',  ti.price * sa.qty * ti.royalty/100* ta.royaltyper /100 as "sales_royalty"
FROM authors AS au
INNER JOIN titleauthor AS ta ON au.au_id = ta.au_id
LEFT JOIN titles AS ti ON ta.title_id = ti.title_id
LEFT JOIN sales as sa ON ti.title_id = sa.title_id
ORDER BY ti.price * sa.qty * ti.royalty/100* ta.royaltyper /100 desc;


#Challenge 2 -----Step 2 Aggregate the total royalties for each title for each author

SELECT au_id, title_id, sum(sales_royalty)
FROM (
SELECT au.au_id AS "au_id",
ti.title_id as 'title_id',  ti.price * sa.qty * ti.royalty/100* ta.royaltyper /100 as "sales_royalty"
FROM authors AS au
INNER JOIN titleauthor AS ta ON au.au_id = ta.au_id
LEFT JOIN titles AS ti ON ta.title_id = ti.title_id
LEFT JOIN sales as sa ON ti.title_id = sa.title_id
 ) as subquery
GROUP BY au_id, title_id
ORDER BY au_id desc;

#Challenge 2----STEP 3  Calculate the total profits of each author


SELECT au_id as 'Author_ID', title_id as 'Title_ID', sum(sales_royalty) as 'Total_Royalties', 
advance as 'Advance', sum(sales_royalty) + advance as 'Total_profits'
FROM (
SELECT au.au_id AS "au_id",
ti.title_id as 'title_id',  ti.price * sa.qty * ti.royalty/100* ta.royaltyper /100 as "sales_royalty",
ti.advance as "advance"
FROM authors AS au
INNER JOIN titleauthor AS ta ON au.au_id = ta.au_id
LEFT JOIN titles AS ti ON ta.title_id = ti.title_id
LEFT JOIN sales as sa ON ti.title_id = sa.title_id
 ) as subquery
GROUP BY au_id, title_id
ORDER BY Total_Royalties DESC
LIMIT 3;

#----CHALLENGE #3 -------MOST PROFITING AUTHORS

CREATE TABLE publications.most_profiting
SELECT Author_ID, total_profits
FROM publications.total_profits
LIMIT 3;


