/*
8. List the average `salary` in the local currency for each `company_location`.
*/

select          company_location    Location
                ,avg(salary)        'Average Salary'
                ,salary_currency    'Local Currency'
from            data_jobs_2024  
group by        company_location
                ,salary_currency
order by        Location desc ;