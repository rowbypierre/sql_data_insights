/*
7. How does the average `salary_in_usd` compare between `work_setting` types?
*/

select      work_setting                                                'Work Setting'
            ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
from        data_jobs_2024  
group by    work_setting
order by    avg(salary_in_usd) desc ;