/*
18. Determine the average `salary_in_usd` by `job_title` within each `job_category` and order them from highest to lowest.
*/

select          job_category                                                'Domain'
                ,job_title                                                  'Position'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'      
from            data_jobs_2024  
group by        job_title
                ,job_category
order by        job_category
                ,avg(salary_in_usd) desc
                ,job_title;
