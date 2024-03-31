/*
6. What are the top 5 highest paying `job_titles` in `salary_in_usd`?
*/

with average_salaries as (
    select distinct                                                     job_title                                               
                    ,(
                        select  avg(salary_in_usd) 
                        from    data_jobs_2024 dj24_2
                        where   dj24_2.job_title = dj24_1.job_title
                    )                                                   average_salary
    from            data_jobs_2024 dj24_1
),
    
rank_salaries as (
    select          *
                    ,row_number() over(order by average_salary desc)    rank 
    from            average_salaries
)

select  a_s.job_title                                                   'Job Title'
        ,concat('$', try_cast(a_s.average_salary as numeric(8,2)))      'Average Salary'
from    average_salaries    a_s
join    rank_salaries       rs on a_s.job_title = rs.job_title
where   rs.rank < 6 ;
