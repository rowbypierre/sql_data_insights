/*
7.  Segment customers into age groups and analyze the average monthly income, 
    number of males, number of females,married, single, average family size within each group. 
*/

with x as (
    select      case
                    when age < 20 then 'Teen'
                    when age < 26 then 'Early 20s'
                    when age < 31 then 'Late 20s'
                else
                    'Early 30s'
                end age_tier
                , *
    from        online_food_orders    
)

select      age_tier                    'Age Group'
            ,monthly_income             'Montly Income'
                                        ,Gender                     
            ,marital_status             'Marital Status' 
            ,count(marital_status)      'Occurrrence'
            ,ceiling(avg(family_size))  'Average Family Size'                                  
from        x
group by    age_tier
            ,monthly_income
            ,gender
            ,marital_status
having      marital_status not like '%not%'
order by    1 desc, 3, 2, 4, 5;