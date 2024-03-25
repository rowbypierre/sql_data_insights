/*
1. What is the average `salary_in_usd` for each `job_title`?
*/

select      job_title                           'Job Title'
            ,concat('$', avg(salary_in_usd))    'Average Salary'
            ,'USD'                              Currency
from        data_jobs_2024
group by    job_title
order by    avg(salary_in_usd) desc;