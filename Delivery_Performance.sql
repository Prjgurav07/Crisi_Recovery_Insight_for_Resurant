# Avrage Delivery Time
select round(avg(actual_del_time),2) as avg_delivry_time_mins
from delivery;

# SLA Compliance Rate
SELECT ROUND(
    (
        SUM(
            CASE
                WHEN actual_del_time <= expected_del_time THEN 1
                ELSE 0
            END
        ) * 100.0
        / COUNT(*)
    ),
    2
) AS sla_compliance_rate
FROM delivery;

# Delay by City
select dp.city,
		round(avg(d.actual_del_time - d.expected_del_time),2) as avg_delay
from delivery as d
join final_orders as o
on d.order_id = o.order_id
join dim_delivery_partner_ as dp
on o.delivery_partner_id	 = dp.delivery_partner_id
group by city
order by avg_delay desc;

# Vechile Performance
select dp.vehicle_type,
	   round(avg(d.actual_del_time),2) as avg_del_time_min,
       round(avg(d.actual_del_time - d.expected_del_time),2) as avg_delay
from delivery as d
join final_orders as o
on d.order_id = o.order_id
join dim_delivery_partner_ as dp
on o.delivery_partner_id = dp.delivery_partner_id
group by dp.vehicle_type;

# Delivery Analysis by Crisis Phase
select o.crisis_phase,
	   round(avg(d.actual_del_time),2) as avg_delivery_time_min,
       round(avg(d.actual_del_time - d.expected_del_time),2) as avg_delay
from delivery as d
join final_orders as o
on d.order_id = o.order_id
group by crisis_phase;

select dp.employment_type,
	   round(avg(d.actual_del_time),2) as avg_delivery_time_min
from delivery as d
join final_orders as o
on d.order_id = o.order_id
join dim_delivery_partner_ as dp
on o.delivery_partner_id = dp.delivery_partner_id
group by dp.employment_type;


