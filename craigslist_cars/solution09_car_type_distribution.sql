/*
9. What is the distribution of vehicle types listed, and what is the average price for each type?
*/

select 		type								"Vehicle Type" 
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
			,concat('$',
				   round(AVG(price), 2)) 	 	"Average Price"
from 		vehicles v
where 		type is not null
and 		price is not null
and 		paint_color is not null
and 		price > 0
and 		price < 516999
group by	type
order by	count(*) desc;
