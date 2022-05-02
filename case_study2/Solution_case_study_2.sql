/* 
How many pizzas were ordered?
*/

SELECT COUNT(DISTINCT(order_id)) AS pizza_ordered
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
SELECT pn.pizza_name,COUNT(ccs.pizza_id) 
FROM cleaned_customer_orders ccs 
JOIN runner_orders_cleaned roc 
ON ccs.order_id=roc.order_id 
JOIN pizza_names pn 
ON ccs.pizza_id=pn.pizza_id 
WHERE roc.distance!=0 
GROUP BY pn.pizza_name

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

with check_cte as(
SELECT cc.order_id,COUNT(cc.order_id) AS number_of_delivery 
FROM cleaned_customer_orders cc 
JOIN runner_orders_cleaned rc ON cc.order_id=rc.order_id 
WHERE rc.distance!=0 
GROUP BY cc.order_id
)

SELECT MAX(number_of_delivery) as max_delivery FROM check_cte


/* 
What was the total volume of pizzas ordered for each hour of the day?
*/

SELECT DATEPART(HOUR, order_time) AS hour_of_day,COUNT(order_id) FROM cleaned_customer_orders group by DATEPART(HOUR, order_time)

















