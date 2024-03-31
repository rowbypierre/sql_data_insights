/*
14. What is the percentage of listings for each transmission type?
*/

select 		transmission								"Transmission Type", 
			concat(
			round(
			cast(count(*) as numeric)
			/
			(select 	cast(count(*) as numeric)
			from 		vehicles
			where		transmission is not null)
			* 
			100	
				,2), '%') 								"Percentage of Listings"
from 		vehicles v
where 		transmission is not null
group by	transmission
order by	count(*) desc;