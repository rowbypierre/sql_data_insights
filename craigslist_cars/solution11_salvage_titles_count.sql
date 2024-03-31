/*
11. How many vehicles are listed with a 'salvage' title status?
*/

select 	count(*)	"# of Salvage Titles"
from	vehicles
where 	title_status like 'salvage';