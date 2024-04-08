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