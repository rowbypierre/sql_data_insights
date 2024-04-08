/*
20. What is the average `salary` (in local currency) to `salary_in_usd` conversion rate for each `salary_currency` by `work_year`?
*/

with salaries as (
   select distinct                                                                  salary_currency
                                                                                    ,work_year
                    ,(select    avg(salary) 
                    from        data_jobs_2024 dj24_2
                    group by    work_year, salary_currency
                    having      dj24_2.work_year = dj24_1.work_year
                    and         dj24_2.salary_currency = dj24_1.salary_currency)    average_salary
                    ,(select     avg(salary_in_usd) 
                    from        data_jobs_2024 dj24_2
                    group by    work_year, salary_currency
                    having      dj24_2.work_year = (dj24_1.work_year)
                    and         dj24_2.salary_currency = dj24_1.salary_currency)    avg_salary_in_usd
    from            data_jobs_2024 dj24_1
)

select      salary_currency                                            'Local Currency'
            ,work_year                                                 'Calendar Year'
            ,average_salary                                            'Local AVG Salary'
            ,avg_salary_in_usd                                         'AVG Salary USD'
            ,round(
                try_cast(average_salary as float) 
                / 
                try_cast(avg_salary_in_usd as float), 2)               'Conversion Rate to USD'
from        salaries
where       salary_currency not like 'usd'
order by    salary_currency
            ,work_year asc; 