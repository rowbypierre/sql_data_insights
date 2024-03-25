/*
17. Analyze the variance in `salary_in_usd` within each `job_category` and rank them by the largest variance.
*/

with sample_size_by_category as (
    select                          job_category
                ,count(job_title)   total 
    from        data_jobs_2024
    group by    job_category
),
mean_by_category as (
    select                                              job_category,  
                try_cast(avg(salary_in_usd) as float)   avg_cat_salary
    from        data_jobs_2024
    group by    job_category
),
sum_sqrd_dif_by_category as (
    select      sum(sqrd_dif)   sum_sqrd_dif
                                ,job_category                                                       
    from        
                (select     dj24.job_title
                            ,dj24.job_category    
                            ,power(
                                (try_cast(salary_in_usd as float)
                                -
                                mbc.avg_cat_salary)
                                ,2
                            ) sqrd_dif   
                from        data_jobs_2024 dj24
                join        mean_by_category mbc on mbc.job_category = dj24.job_category
                )x
    group by    job_category
) 

select distinct ssbc.job_category                   'Career Domain'
                ,ssbc.total                         'Sample Size'
                ,mbc.avg_cat_salary                 'Mean Salary'
                ,ssdbc.sum_sqrd_dif                 'Sum of Squared Differences'
                ,round(ssdbc.sum_sqrd_dif
                /
                (ssbc.total - 1),2)                 Variance
                ,round(
                    sqrt(ssdbc.sum_sqrd_dif
                    /
                    (ssbc.total - 1)),2)            'Standard Deviation'
                ,'USD'                              Currency
from            sample_size_by_category ssbc
join            mean_by_category mbc on mbc.job_category = ssbc.job_category
join            sum_sqrd_dif_by_category ssdbc on ssdbc.job_category = ssbc.job_category
order by        Variance desc;
