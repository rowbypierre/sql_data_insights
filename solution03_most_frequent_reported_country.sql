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