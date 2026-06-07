# Top performing Restrant
select r.restaurant_name,
		round(sum(o.net_revenue),2) as revenue
from dim_restaurant as r
join final_orders as o
on r.restaurant_id = o.restaurant_id
where o.is_cancelled = 'N'
group by r.restaurant_name
order by revenue desc
limit 10;

# Cuisine wise revenue
select r.cuisine_type,
		round(sum(o.net_revenue),2) as revenue
from dim_restaurant as r
join final_orders as o
on r.restaurant_id = o.restaurant_id
where o.is_cancelled = 'N'
group by r.cuisine_type
order by revenue desc;

# Restaurant with Highest Cancelation
select r.restaurant_name, 
		count(o.order_id) as total_orders,
        sum(
        case when o.is_cancelled = 'Y'
        Then 1
        else 0
        end
        ) as cancel_order,
        round(
        (sum(
        case when o.is_cancelled = 'Y'
        then 1 
        else 0
        end
        )*100.0
        /
        count(*)),
        2) as cancel_rate
from dim_restaurant as r
join final_orders as o
on r.restaurant_id = o.restaurant_id
group by r.restaurant_name
order by cancel_rate desc
limit 10;

# Restaurant with highest rating
select r.restaurant_name,
	   round(avg(rr.rating),2) as avg_rating,
       count(rr.order_id) as total_orders
from dim_restaurant as r
join fact_ratings as rr
on r.restaurant_id = rr.restaurant_id
group by r.restaurant_name
having count(rr.order_id) > 20
order by avg_rating desc
limit 10;

# inactive restaurant
select restaurant_id, restaurant_name,
city, cuisine_type, partner_type
from dim_restaurant
where is_active = "Y";

# inactive restaurant by city
select city, count(restaurant_id) as total_rest
from dim_restaurant
where is_active = "Y"
group by city;

# Count of active & inactive restaurant
select is_active, count(restaurant_id) as total_rest
from dim_restaurant
group by is_active;

# Count of active & inactive restaurant city wise
select is_active, city, count(restaurant_id) as total_rest
from dim_restaurant
group by is_active, city
order by city;

# inactive restaurant percentage
select 
	  round((sum(
		case when is_active = 'Y'
        then 1
        else 0
        end
      )*100.0
      /
      count(*)),2) as inactive_per
from dim_restaurant;
