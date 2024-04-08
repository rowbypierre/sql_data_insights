/*
5. What are the counts of vehicles listed by condition status?
*/

select 		condition			"Condition", 
			count(*) 			"Occurrences"
from 		vehicles
where 		condition is not null
group by	condition
order by	count(*) desc;