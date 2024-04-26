/*
4.  For customers with different income brackets, what is the frequency of orders placed? 
*/

select      monthly_income                              'Monthly Income'
            ,count(*)                                   '# Orders'
            ,dense_rank() over (order by count(*) desc) 'Rank'
from        online_food_orders
group by    monthly_income;