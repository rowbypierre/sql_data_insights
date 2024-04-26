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

/*
2.  Does educational qualification correlate with the feedback given? 
*/

select                                                                      Educational_Qualifications
                                                                            ,Feedback
            ,count(Feedback)                                                'Count'
            ,concat(round(( cast( count(Feedback) 
                            as float) 
                            / 
                            cast((  select count(*)
                                    from    online_food_orders ofox
                                    where   ofox.Educational_Qualifications
                                        = ofo.Educational_Qualifications)
                            as float)
                            *
                            100)
                    , 2), ' %')
                                                                            '% of Orders in Education Level'
from        online_food_orders ofo
group by    Educational_Qualifications, Feedback
order by    1 desc, 2 desc;

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

/*
4.  For customers with different income brackets, what is the frequency of orders placed? 
*/

select      monthly_income                              'Monthly Income'
            ,count(*)                                   '# Orders'
            ,dense_rank() over (order by count(*) desc) 'Rank'
from        online_food_orders
group by    monthly_income;

/*
5.  Are there specific geographical areas (pin codes) where more orders are placed? 
*/

select      pin_code                                    'Location Pin'
            ,count(*)                                   '# Orders'
            ,dense_rank() over (order by count(*) desc) 'Rank'
from        online_food_orders
group BY    pin_code;

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

/*
7.  Segment customers into age groups and analyze the average monthly income, 
    number of males, number of females,married, single, average family size within each group. 
*/

with x as (
    select      case
                    when age > 20 then 'Teen'
                    when age > 26 then 'Early 20s'
                    when age > 31 then 'Late 20s'
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


            