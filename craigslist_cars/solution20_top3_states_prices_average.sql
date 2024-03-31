/*
20. What are the top 3 states with the highest average vehicle prices?
*/

with state_prices as (
	select		upper(state)						"State"
				,concat('$',
					   round(AVG(price), 2))  		"Average Price"
	from 		vehicles 
	where 		price is not null
	and			state is not null
	and 		price > 0
	and 		price < 516999 -- cars priced beyond this amount are erroneous
	group by	state 
)

select 		*
			,row_number() over(order by "Average Price" desc) "Rank"
from 		state_prices
limit 		3;