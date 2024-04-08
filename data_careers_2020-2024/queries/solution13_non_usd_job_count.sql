/*
13. How many jobs are listed in countries where the `salary_currency` is not `USD`?
*/

select  count(*)    'Total'
from    data_jobs_2024  
where   salary_currency not like 'usd';