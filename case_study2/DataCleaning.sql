/* cleaning customer_orders table */

CREATE VIEW cleaned_customer_orders AS(
SELECT order_id,customer_id,pizza_id, 
CASE 
	WHEN exclusions='null' then ' '
	ELSE exclusions
	END AS exclusions,
CASE 
	WHEN extras is null or extras='null' then ' '
	else extras
	END AS extras,
	order_time
FROM customer_orders)
SELECT * FROM cleaned_customer_orders

/* cleaning runner_orders table */


CREATE VIEW runner_orders_cleaned AS(
SELECT order_id, runner_id,
  CASE 
    WHEN pickup_time LIKE 'null' THEN ' '
    ELSE pickup_time 
    END AS pickup_time,
  CASE 
    WHEN distance LIKE 'null' THEN ' '
    WHEN distance LIKE '%km' THEN TRIM('km' from distance) 
    ELSE distance END AS distance,
  CASE 
    WHEN duration LIKE 'null' THEN ' ' 
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)       
    ELSE duration END AS duration,
  CASE 
    WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
    ELSE cancellation END AS cancellation
FROM runner_orders)
