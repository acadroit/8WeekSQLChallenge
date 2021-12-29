/*
What is the total amount each customer spent at the restaurant?
*/
select s.customer_id, sum(m.price) from sales s join menu m on s.product_id=m.product_id group by s.customer_id

