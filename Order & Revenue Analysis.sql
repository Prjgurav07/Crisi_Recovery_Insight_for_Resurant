select * from final_orders;

# Total orders placed
select count(order_id) as Total_Orders
from final_orders;

# Total Revenue Generated
select round(sum(net_revenue),2) as Total_revenue 
from final_orders
where is_cancelled ="N";

# Average order values
select round(avg(net_revenue),2) as AOV
from final_orders
where is_cancelled = 'N';

# Monthly Revenue
select 
		date_format(order_timestamp, '%Y-%m') as month,
        round(sum(net_revenue),2) as monthly_revenue
from final_orders
where is_cancelled = "N"
group by month
order by month;    

# Canacellation percentage
select 
		round((sum(case 
        when is_cancelled = "Y"
        then 1
        else 0
        end)*100.0)/
        count(*),
        2) as cancell_per
from final_orders  ;

# Cancellation in each phase
select crisis_phase, count(*) as total_orders,
		sum(case
        when is_cancelled = "Y"
        then 1
        else 0
        end ) as cancel_order,
        
        round((sum(case 
        when is_cancelled = "Y"
        then 1
        else 0
        end)*100.0)/
        count(*),
        2) as cancel_per
from final_orders
group by crisis_phase;
