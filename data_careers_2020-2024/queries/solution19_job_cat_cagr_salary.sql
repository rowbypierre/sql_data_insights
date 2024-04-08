/*
19. Calculate the compounded annual growth rate (CAGR) of the `salary_in_usd` for each `job_category` across the recorded years.
*/

with job_cat_metrics as (
    select distinct                                                                     job_category
            ,(select    min(work_year)
            from        data_jobs_2024 dj24_2
            where       dj24.job_category = dj24_2.job_category)                        min_work_year
            ,(select    avg(salary_in_usd)
            from        data_jobs_2024 
            where       work_year = (select  min(work_year)
                                    from    data_jobs_2024 dj24_2
                                    where   dj24.job_category = dj24_2.job_category)
            and         job_category = dj24.job_category)                               min_year_avg_pay
            ,(select    max(work_year)
            from        data_jobs_2024 dj24_2
            where       dj24.job_category = dj24_2.job_category)                        max_work_year
            ,(select    avg(salary_in_usd)
            from        data_jobs_2024 
            where       work_year = (select  max(work_year)
                                    from    data_jobs_2024 dj24_2
                                    where   dj24.job_category = dj24_2.job_category)
            and         job_category = dj24.job_category)                               max_year_avg_pay       
    from    data_jobs_2024 dj24     
),
    
cagr_elements as (
    select                                          job_category
                ,(max_work_year - min_work_year )   years                                        
                ,(cast(max_year_avg_pay as float) 
                / cast(min_year_avg_pay as float))  pay_change
                ,(1.0000 
                    / 
                    (cast(max_work_year as float)
                    - 
                    cast(min_work_year as float)))  compound
    from        job_cat_metrics
)

select      ce.job_category                                             'Career Focus'
            ,ce.years                                                   'Timeframe (Years)'
            ,jcs.min_work_year                                          'Start Year'
            ,jcs.min_year_avg_pay                                       'Average Salary - Start'
            ,jcs.max_work_year                                          'End Year'
            ,jcs.max_year_avg_pay                                       'Average Salary - End'
            ,'USD'                                                      Currency
            ,concat(
                round(
                    (cast(power(ce.pay_change , ce.compound)as float) 
                    - 1)
                    * 100, 2), '%')                                     CAGE
from      cagr_elements ce
join      job_cat_metrics jcs on jcs.job_category = ce.job_category
order by  CAGE desc;
