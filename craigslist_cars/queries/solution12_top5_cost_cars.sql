/*
12. What are the top 5 most expensive vehicles listed, including their model and price?
*/

with catalog as (
	select 		manufacturer								Make
				,model										Model
				,concat('$', price) 						"Cost"
				,row_number() over(order by price desc) 	Rank
	from 		vehicles
	where 		price is not null
	and 		price > 0
	and 		price < 516999
	and 		manufacturer is not null
)

select 		*
from 		catalog
where 		Rank < 6