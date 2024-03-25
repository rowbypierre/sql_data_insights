/*
5. Count the number of `full-time` positions versus `part-time` or `contract` positions.
*/

select      count(*)            '# of Positions'
            , employment_type   'Employment Type'
from        data_jobs_2024  
group by    employment_type
order by    count(*) desc 