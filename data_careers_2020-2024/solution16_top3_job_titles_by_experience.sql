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
