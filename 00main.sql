
create database sql_training;

use sql_training

create table dbo.data_jobs_2024(
	work_year			int		        null,
	experience_level	nvarchar(50)	null,
	employment_type		nvarchar(50)	null,
	job_title			nvarchar(50)	null,
	salary				int		        null,
	salary_currency		nvarchar(50)	null,
	salary_in_usd		int		        null,
	employee_residence	nvarchar(50)	null,
	work_setting		nvarchar(50)	null,
	company_location	nvarchar(50)	null,
	company_size		nvarchar(50)	null,
	job_category		nvarchar(50)	null
); 


/*
1. What is the average `salary_in_usd` for each `job_title`?
*/

select      job_title                        'Job Title'
            ,concat('$', avg(salary_in_usd)) 'Average Salary'
            ,'USD'                           Currency
from        data_jobs_2024
group by    job_title
order by    avg(salary_in_usd) desc;

/*
2. How many unique `job_titles` are recorded in the dataset?
*/

select distinct job_title                                           'Job Title'
                ,(
                    select  count(*) 
                    from    data_jobs_2024 dj24_2
                    where   dj24_2.job_title = dj24_1.job_title
                )                                                   Occurence
                ,(
                    select  count(distinct job_title)
                    from    data_jobs_2024
                )                                                   'Unique Titles Total'
from            data_jobs_2024 dj24_1
order by        Occurence desc;

/*
3. Which `employee_residence` countries appear most frequently in the dataset?
*/
with residence_counts as (
    select     count(*) count, employee_residence 
    from       data_jobs_2024 
    group by   employee_residence
),
max_count as (
    select     max(count) max_count
    from       residence_counts
)

select      rc.employee_residence   'Location'
            ,mc.max_count           '# of Occurrences'
from        residence_counts rc
inner join  max_count mc on rc.count = mc.max_count
 ;

/*
4. What is the distribution of `experience_level` in the dataset?
*/

with counts as (
    select     count(*) occurences, experience_level
    from       data_jobs_2024 dj24_1 
    group by   experience_level 
)

select distinct dj24.experience_level                                   'Experience Level'
                ,concat(round((cast((counts.occurences) as float) 
                            / (select count(*) from data_jobs_2024))
                            * 100, 2), '%')                             'Distribution'
from            data_jobs_2024 dj24
inner join      counts on counts.experience_level = dj24.experience_level
order by        dj24.experience_level ;

/*
5. Count the number of `full-time` positions versus `part-time` or `contract` positions.
*/

select      count(*)            '# of Positions'
            , employment_type   'Employment Type'
from        data_jobs_2024  
group by    employment_type
order by    count(*) desc 

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

/*
7. How does the average `salary_in_usd` compare between `work_setting` types?
*/

select      work_setting                                                'Work Setting'
            ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
from        data_jobs_2024  
group by    work_setting
order by    avg(salary_in_usd) desc ;

/*
8. List the average `salary` in the local currency for each `company_location`.
*/

select          company_location    Location
                ,avg(salary)        'Average Salary'
                ,salary_currency    'Local Currency'
from            data_jobs_2024  
group by        company_location
                ,salary_currency
order by        Location desc ;

/*
9. What is the average `salary_in_usd` for each `company_size` category?
*/

select          company_size                                                'Complany Size'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
                ,'USD'                                                      'Local Currency'
from            data_jobs_2024  
group by        company_size
order by        company_size desc;

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

/*
11. Calculate the average `salary_in_usd` for `data scientists` with `5 years` of experience or more.
*/

select          experience_level                                            'Experience Level'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'
from            data_jobs_2024  
group by        experience_level
having          experience_level not like 'entry_level'
order by        avg(salary_in_usd) desc;

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

/*
13. How many jobs are listed in countries where the `salary_currency` is not `USD`?
*/

select  count(*)    'Total'
from    data_jobs_2024  
where   salary_currency not like 'usd';

/*
14. Create a list of the `job_title` and `salary_in_usd` for all `executive` level positions.
*/

select      job_title           'Position'
            ,experience_level   'Experience'
            ,salary_in_usd      'Salary'
            ,'USD'              'Currency'
from        data_jobs_2024  
where       experience_level like 'executive'
order by    job_title
            ,salary_in_usd desc;

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

/*
16. Identify the top 3 most common job titles for each experience level and list them along with the count of occurrences.
*/

with jobs_by_experience as (
    
    select                                                          * 
                ,row_number() over (partition by experience_level 
                                    order by Occurrence desc)       rank      
    from        (select      experience_level
                            ,job_title
                            ,count(job_title) Occurrence
                from        data_jobs_2024
                group by    experience_level
                            ,job_title)x
)

select      experience_level    'Experience Level'
            ,job_title          'Position'
                                ,Occurrence         
from        jobs_by_experience
where       rank < 4;

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

/*
18. Determine the average `salary_in_usd` by `job_title` within each `job_category` and order them from highest to lowest.
*/

select          job_category                                                'Domain'
                ,job_title                                                  'Position'
                ,concat('$', try_cast(avg(salary_in_usd) as numeric(8,2)))  'Average Salary'      
from            data_jobs_2024  
group by        job_title
                ,job_category
order by        job_category
                ,avg(salary_in_usd) desc
                ,job_title;

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





