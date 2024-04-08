/*
18. What is the most common number of cylinders in the vehicles listed?
*/

select 		cylinders						"# of Cyclinders"
			,count(*)						"# of Listings"
from 		vehicles
where 		cylinders is not null
group by 	cylinders
order by 	count(*) desc
limit 1;