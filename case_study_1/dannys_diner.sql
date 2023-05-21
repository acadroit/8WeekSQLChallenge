LINK: https://8weeksqlchallenge.com/case-study-1/

/*
What is the total amount each customer spent at the restaurant?
*/
SELECT s.customer_id, SUM(m.price) AS TotalMoneySpent 
FROM sales s JOIN menu m ON s.product_id=m.product_id 
GROUP BY s.customer_id

/*
What was the first item from the menu purchased by each customer?
*/

with firstItem_cte AS(
SELECT customer_id,order_date,ROW_NUMBER() OVER(partition BY customer_id ORDER BY order_date) AS dateRanking,s.product_id,m.product_name
FROM sales s 
JOIN menu m ON s.product_id=m.product_id)

SELECT customer_id,product_name FROM firstItem_cte WHERE dateranking=1

/*
How many days has each customer visited the restaurant?
*/

SELECT customer_id, COUNT(order_date) AS VisitCount 
FROM sales 
GROUP BY customer_id

/*
What is the most purchased item on the menu and how many times was it purchased by all customers?
*/
SELECT 
  TOP 1 (COUNT(s.product_id)) AS mostpurchased, 
  product_name
FROM sales s
JOIN menu m
  ON s.product_id = m.product_id
GROUP BY s.product_id, product_name
ORDER BY mostpurchased DESC;

/*
Which item was the most popular for each customer?
*/
with rank_product_cte as
(select s.customer_id,s.product_id,m.product_name,row_number() over(partition by product_name order by s.product_id) as ranking  
 from sales s  
 join menu m 
 on s.product_id=m.product_id)

select customer_id,product_name, count(ranking) as productordered 
from rank_product_cte 
group by product_name,customer_id

WITH fav_item_cte AS
(
	SELECT 
    s.customer_id, 
    m.product_name, 
    COUNT(m.product_id) AS order_count,
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.customer_id) DESC) AS rank
FROM dbo.menu AS m
JOIN dbo.sales AS s
	ON m.product_id = s.product_id
GROUP BY s.customer_id, m.product_name
)

SELECT 
  customer_id, 
  product_name, 
  order_count
FROM fav_item_cte 
WHERE rank = 1;

/*
Which item was purchased first by the customer after they became a member?
*/

WITH member_sales_cte AS 
(
  SELECT 
    s.customer_id, 
    m.join_date, 
    s.order_date, 
    s.product_id,
    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
  FROM sales AS s
	JOIN members AS m
		ON s.customer_id = m.customer_id
	WHERE s.order_date >= m.join_date
)


SELECT 
  s.customer_id, 
  s.order_date, 
  m2.product_name 
FROM member_sales_cte AS s
JOIN menu AS m2
	ON s.product_id = m2.product_id
WHERE rank = 1;


/*
Which item was purchased just before the customer became a member?
*/

with previous_purchased_cte as
(
Select s.customer_id,s.order_date,m.join_date,s.product_id,dense_rank() over(partition by s.customer_id order by s.order_date desc) as rank
from sales s join members m on s.customer_id=m.customer_id where s.order_date<m.join_date
)

select s.customer_id,s.order_date,s.join_date,s.rank, m2.product_name from previous_purchased_cte s join menu m2 on s.product_id=m2.product_id where s.rank=1

/*
What is the total items and amount spent for each member before they became a member?
*/

select s.customer_id,count(s.product_id) as total_items,sum(price) as sales_value 
from sales s 
join members m 
on s.customer_id = m.customer_id 
join menu mm 
on s.product_id=mm.product_id 
where s.order_date<m.join_date 
group by s.customer_id

/*
If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
*/


Partial correct answer

SELECT *,
		CASE WHEN DerivedTable.product_name = 'sushi' THEN DerivedTable.summation * 20
		ELSE DerivedTable.summation * 10 END AS points
	FROM
(select  s.customer_id,m.product_name,sum(price) as summation 
from sales s 
join menu m 
on s.product_id=m.product_id  
group by s.customer_id,m.product_name) as DerivedTable 
order by customer_id
  
CORRECT ANSWER

WITH price_points_cte AS
(
	SELECT *, 
		CASE WHEN product_name = 'sushi' THEN price * 20
		ELSE price * 10 END AS points
	FROM menu
)

SELECT 
  s.customer_id, 
  SUM(p.points) AS total_points
FROM price_points_cte AS p
JOIN sales AS s
	ON p.product_id = s.product_id
GROUP BY s.customer_id

	
