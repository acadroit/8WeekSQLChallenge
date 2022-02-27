/* 
How many pizzas were ordered?
*/
SELECT COUNT(*) AS pizza_order_count
FROM cleaned_customer_orders

/*
How many unique customer orders were made?
*/
SELECT COUNT(DISTINCT order_id) AS unique_order_count
FROM cleaned_customer_orders

/*
How many successful orders were delivered by each runner?
*/
SELECT runner_id, COUNT(order_id) AS successful_orders
FROM runner_orders_cleaned
WHERE distance != 0
GROUP BY runner_id

/*
How many of each type of pizza was delivered?
*/
SELECT p.pizza_name, COUNT(c.pizza_id) AS delivered_pizza_count
FROM cleaned_customer_orders AS c
JOIN runner_orders_cleaned AS r
 ON c.order_id = r.order_id
JOIN pizza_names AS p
 ON c.pizza_id = p.pizza_id
WHERE r.distance != 0
GROUP BY p.pizza_name;

/*
How many Vegetarian and Meatlovers were ordered by each customer?
*/
SELECT c.customer_id, p.pizza_name, COUNT(p.pizza_name) AS order_count
FROM cleaned_customer_orders AS c
JOIN pizza_names AS p
 ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;

/*
What was the maximum number of pizzas delivered in a single order?
*/

with max_pizza_cte  as
(
SELECT c.order_id,count(c.pizza_id) as pizza_count 
from cleaned_customer_orders c right join runner_orders_cleaned r 
on c.order_id=r.order_id  
WHERE r.distance != 0 
group by c.order_id
)
select max(pizza_count) from max_pizza_cte


/* 
What was the total volume of pizzas ordered for each hour of the day?
*/

SELECT DATEPART(HOUR, order_time) AS hour_of_day,COUNT(order_id) FROM cleaned_customer_orders group by DATEPART(HOUR, order_time)

















