/*
9. What is the average `salary_in_usd` for each `company_size` category?
*/

select          company_size                                                'Complany Size'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
                ,'USD'                                                      'Local Currency'
from            data_jobs_2024  
group by        company_size
order by        company_size desc;