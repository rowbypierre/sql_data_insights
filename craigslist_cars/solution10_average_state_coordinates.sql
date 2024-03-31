/*
10. For each state, what is the average latitude and longitude of the vehicle listings?
*/

select 		upper(state)							"State"
			,round(avg(cast(lat as numeric)),5) 	"Average Latitude"
			,round(avg(cast(long as numeric)),5) 	"Average Longitude"
from 		vehicles
where		state is not null
and 		lat is not null
and 		long is not null
group by	state

/*
11. How many vehicles are listed with a 'salvage' title status?
*/

select 	count(*)	"# of Salvage Titles"
from	vehicles
where 	title_status like 'salvage';