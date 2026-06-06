# Active members by month

select date_format(order_timestamp, "%Y-%m") as month,
count(distinct custmer_id) as active_members
from final_orders
group by month
order by month;

# Repeat Customers
select count(*) from (
select custmer_id from final_orders
group by custmer_id
having count(order_id) > 1) t;

select custmer_id, count(order_id) as total_orders
from final_orders
group by custmer_id
having count(order_id)>1
order by total_orders desc;

# Customer Retation Rate
with customer_month as
(
select custmer_id,
       date_format(order_timestamp, "%Y-%m") as order_month
from final_orders
group by custmer_id,
		date_format(order_timestamp, "%Y-%m")
)

select a.order_month,
		count(distinct a.custmer_id) as retained_customer
from customer_month as a
join customer_month as b
on a.custmer_id = b.custmer_id
and period_diff(
	replace(a.order_month,'-',''),
    replace(b.order_month,'-','')
) = 1
group by a.order_month
order by a.order_month;

# Customer not ordering after june
select custmer_id
from final_orders
group by custmer_id
having max(order_timestamp) < '2025-07-01';

# Total churned customer
select count(*) from (
	select custmer_id
	from final_orders
	group by custmer_id
	having max(order_timestamp) < '2025-07-01'
) t;

# Churn Rate
SELECT ROUND(
    COUNT(
        DISTINCT CASE
            WHEN last_order < '2025-07-01'
            THEN custmer_id
        END
    ) * 100.0
    /
    COUNT(DISTINCT custmer_id),
    2
) AS churn_rate
FROM (
    SELECT
        custmer_id,
        MAX(order_timestamp) AS last_order
    FROM final_orders
    GROUP BY custmer_id
) t;

# Order by Acquisistion Channel
select c.acquisition_channel, count(o.order_id) as total_orders
from final_orders as o
join dim_customer as c
on o.custmer_id = c.customer_id
group by c.acquisition_channel
order by total_orders desc;

# Revenue by Acqusistion channel
select c.acquisition_channel,
		round(sum(o.net_revenue),2) as revenue
from dim_customer as c 
join final_orders as o
on c.customer_id = o.custmer_id
group by c.acquisition_channel
order by revenue desc;

# Average Order value by acqusition channel

select c.acquisition_channel, round(avg(o.net_revenue),2) as AOV 
from dim_customer as c
join final_orders as o
on c.customer_id = o.custmer_id
group by c.acquisition_channel
order by AOV;



