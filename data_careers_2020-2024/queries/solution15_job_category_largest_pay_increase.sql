/*
15. Which `job_category` has seen the largest increase in average `salary_in_usd` from the earliest to the latest `work_year`?
*/

with domain_pay as (
   select distinct                                                                                      job_category
                    ,(select    avg(salary_in_usd) 
                    from        data_jobs_2024 dj24_2
                    where       dj24_2.work_year = (select  min(work_year)
                                                    from    data_jobs_2024
                                                    where   job_category = dj24_1.job_category)
                    and         dj24_2.job_category = dj24_1.job_category)                              min_year_avg_salary
                    ,(select    avg(salary_in_usd) 
                    from        data_jobs_2024 dj24_2
                    where       dj24_2.work_year = (select  max(work_year)
                                                    from    data_jobs_2024
                                                    where   job_category = dj24_1.job_category)
                    and         dj24_2.job_category = dj24_1.job_category )                             max_year_avg_salary       
    from            data_jobs_2024 dj24_1
)

select      job_category                                                                                'Job Category'
            ,concat('$', try_cast(average_total_growth as numeric(8,2)))                                'Total Increase'                               
from        (select     *
                        ,(max_year_avg_salary - min_year_avg_salary) average_total_growth
                        ,row_number() over (order by (max_year_avg_salary - min_year_avg_salary) desc)   rank
            from        domain_pay) x
where       x.rank < 2
; 