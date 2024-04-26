/*
5.  Are there specific geographical areas (pin codes) where more orders are placed? 
*/

select      pin_code                                    'Location Pin'
            ,count(*)                                   '# Orders'
            ,dense_rank() over (order by count(*) desc) 'Rank'
from        online_food_orders
group BY    pin_code;