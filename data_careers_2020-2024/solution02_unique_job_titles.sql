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