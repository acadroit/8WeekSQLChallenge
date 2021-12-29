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


  
