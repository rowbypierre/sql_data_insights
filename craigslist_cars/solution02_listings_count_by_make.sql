/*
2. How many vehicles are listed by each manufacturer, sorted by the number of listings in descending order?
*/

select 		manufacturer	"Manufacturer" 
			,count(*) 		"# of Listings"
from 		vehicles
where 		manufacturer is not null
group by	manufacturer
order by	count(*) desc;