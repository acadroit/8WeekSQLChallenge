/* cleaning customer_orders table */

create view cleaned_customer_orders as(
select order_id,customer_id,pizza_id, 
case 
	when exclusions='null' then ' '
	else exclusions
	end as exclusions,
case 
	when extras is null or extras='null' then ' '
	else extras
	end as extras,
	order_time
from customer_orders)
select * from cleaned_customer_orders
