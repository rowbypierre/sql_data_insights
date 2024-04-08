/*
6. Can you identify the distribution of vehicles by fuel type?
*/

select 		fuel								"Fuel Type" 
			,concat(
			round(
			cast(count(*) as numeric)
			/
			(select 	cast(count(*) as numeric)
			from 		vehicles
			where		fuel is not null)
			* 
			100	
				,2), '%') 						"Distribution"								
from 		vehicles v
where 		fuel is not null
group by	fuel
order by	count(*) desc;