/*
10. For each `work_year`, how has the `salary_in_usd` trended?
*/

with yearly_summary as (
   select distinct                                                                                      work_year                                                                           
                    ,(select    avg(salary_in_usd) 
                    from        data_jobs_2024 dj24_2
                    where       dj24_2.work_year = dj24_1.work_year)                                    average_salary
                    ,case 
                        when dj24_1.work_year = (select min(work_year) from data_jobs_2024)
                            then (  select  avg(salary_in_usd) 
                                    from    data_jobs_2024
                                    where   work_year = (select min(work_year) from data_jobs_2024))
                        else 
                            (select  avg(salary_in_usd) 
                            from    data_jobs_2024 dj24_2
                            where   dj24_2.work_year = (dj24_1.work_year - 1))
                    end                                                                                 prev_year_avg_salary
    from            data_jobs_2024 dj24_1
)

select      work_year                                                     'Calendar Year'
            ,concat('$', try_cast(average_salary as numeric(8,2)))        'Average Salary'  
            ,concat('$', try_cast(prev_year_avg_salary as numeric(8,2)))  'Prev. Year AVG Salary'
            ,concat(round((try_cast(
                        (average_salary 
                        - 
                        prev_year_avg_salary) as float) 
                        / 
                        prev_year_avg_salary 
                        *
                        100), 2), ' %')                                    'Annual Growth'
from        yearly_summary
order by    work_year asc; 
