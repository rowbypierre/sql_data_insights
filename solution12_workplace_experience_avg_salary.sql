/*
12. What is the average `salary_in_usd` for `remote` jobs versus `in-person` jobs within each `experience_level`?
*/

select          experience_level                                            'Experience Level'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
                ,work_setting                                               'Work Setting'
from            data_jobs_2024  
group by        experience_level
                ,work_setting
having          work_setting like 'in_person'
or              work_setting like 'remote'
order by        work_setting
                ,avg(salary_in_usd) desc
                ,experience_level;