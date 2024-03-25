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
