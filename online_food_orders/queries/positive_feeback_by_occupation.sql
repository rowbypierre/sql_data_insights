/*
3.  What occupations have the highest rate of positive order outcomes? 
*/

select      occupation                                          'Occupation'
            ,feedback                                           'Feedback Type'
            ,count(feedback)                                    '# Occurrences'
            ,dense_rank() over ( order by count(feedback) desc) 'Rank'
from        online_food_orders
where       feedback like 'p%'
group by    occupation
            ,feedback;