/*
19. Can you determine the month with the lowest number of vehicle postings?
*/

select 		to_char(posting_date, 'YYYY')	"Year"
			,to_char(posting_date, 'Month')	"Month"
			,count(*)						"# of Listings"
from 		vehicles
where 		posting_date is not null
group by 	to_char(posting_date, 'Month')
			,to_char(posting_date, 'YYYY')
order by 	count(*) 
limit 1;