/*
11. Calculate the average `salary_in_usd` for `data scientists` with `5 years` of experience or more.
*/

select          experience_level                                            'Experience Level'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
from            data_jobs_2024  
group by        experience_level
having          experience_level not like 'entry_level'
order by        avg(salary_in_usd) desc;
