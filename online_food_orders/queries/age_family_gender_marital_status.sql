/*
1.  What is the average age and family size for each gender and marital status combination? 
*/

select      gender                          'Gender'
            ,marital_status                 'Marital Status'
            ,round(avg(age), 0)             'Average Respondent Age'
            ,ceiling(avg(family_size))      'Average Family Size'      
from        online_food_orders
group by    gender,marital_status
order by    1, 2;