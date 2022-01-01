LINK: https://8weeksqlchallenge.com/case-study-1/

/*
What is the total amount each customer spent at the restaurant?
*/
select s.customer_id, sum(m.price) as TotalMoneySpent from sales s join menu m on s.product_id=m.product_id group by s.customer_id

/*
What was the first item from the menu purchased by each customer?
*/
select customer_id, count(order_date) as VisitCount from sales group by customer_id

/*
What was the first item from the menu purchased by each customer?
*/
with purchased_cte as
(select customer_id,product_name,order_date, dense_rank () over(partition by customer_id order by order_date) as rank
from sales s join menu m on s.product_id=m.product_id)

select customer_id, product_name from purchased_cte  where rank=1 group by customer_id, product_name

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










  
