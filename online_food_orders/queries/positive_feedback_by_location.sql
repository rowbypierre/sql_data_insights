/*
6.  Can you generate a ranking of pin codes by the number of positive feedback received?
*/

select      pin_code                                            'Location Pin'
            ,count(*)                                           '# Orders'
            ,feedback                                           'Feedback Type'
            ,count(feedback)                                    '# Occurrences'
            ,dense_rank() over (order by count(feedback) desc)  'Rank'
from        online_food_orders
where       feedback like 'p%'
group by    pin_code
            ,feedback;