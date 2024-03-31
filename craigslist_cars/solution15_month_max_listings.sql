/*
15. On which month and year exist the highest number of vehicle listings?
*/

select 		to_char(posting_date, 'YYYY')	"Year"
			,to_char(posting_date, 'Month')	"Month"
			,count(*)						"# of Listings"
from 		vehicles
where 		posting_date is not null
group by 	to_char(posting_date, 'Month')
			,to_char(posting_date, 'YYYY')
order by 	count(*) desc
limit 1;