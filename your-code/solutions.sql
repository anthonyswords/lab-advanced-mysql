use publications;
-- CHALLENGE 1 + 2(basicly, the number two is create a temporay table, I wil do it in the same time) -------------------------------------------------------------------------------------------------------------------------------------------------
-- I create a temporary table to observe the advance and royal sales for each author for each title
 DROP TABLE IF EXISTS royal_adv;
create temporary table royal_adv
SELECT
    titleauthor.title_id AS Title_ID,
    titleauthor.au_id AS Author_ID,
    round(titles.advance * titleauthor.royaltyper / 100) as advance,
    round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty

FROM
    titleauthor
INNER JOIN
    authors
ON
    titleauthor.au_id = authors.au_id
    
INNER JOIN
    titles
ON
    titles.title_id = titleauthor.title_id

INNER JOIN
    sales
ON
    sales.title_id = titleauthor.title_id
    
ORDER BY
    sales_royalty DESC;
 
 -- I group by Title and Author due to avoid duplicates rows in according authorID an Title ID in more than 1 rows
 DROP TABLE IF EXISTS total_royal;
create temporary table total_royal
select Title_ID, Author_ID, advance, sum(sales_royalty) as total_royalty from royal_adv
group by 1,2;
select* from total_royal;

-- Extract the profit: sum the advance total and sales royal total. 
DROP TABLE IF EXISTS profiting_authors;
create temporary table profiting_authors
select Author_ID, sum(advance+total_royalty) as profit from total_royal
group by Author_ID
order by profit DESC
limit 3;

-- CHALLENGE 3 -------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS most_profiting_authors;
CREATE TABLE most_profiting_authors as
select Author_ID, (adv_total+total_royalty) as profit from profiting_authors
group by Author_ID
order by profit DESC
limit 3;

select * from most_profiting_authors