/*
13. Can you find the correlation between vehicle price and odometer reading?
*/

with sample as (
	select		*
	from 		vehicles 
	where 		price is not null
				and odometer is not null
	and 		price > 0
	and 		price < 516999
	and			odometer > 0
	and 		odometer < 999999
	order by 	random()
	limit		1000
),

elements as (
	select 		price 					"x"
				,odometer 				"y"
				,price * odometer 		"xy"
				,power(price, 2) 		"x2"
				,power(odometer, 2) 	"y2"
	from 		sample
),

agg_elements as(
	select 		sum(x) 										sum_x
				,sum(y)										sum_y
				,cast(sum(xy) as numeric(25,5))				sum_xy
				,cast(sum(x2) as numeric(25,5))				sum_x2
				,cast(sum(y2) as numeric(25,5))				sum_y2
				,(select 	count(*)
				 from 		sample)		n
	from 		elements	
)


select 		round(
			((
				cast((n * sum_xy) as numeric(25,5)) 
			 	- 
			 	cast((sum_x * sum_y) as numeric(25,5))
			)
				/
			(
				sqrt(
				((cast((n * sum_x2)as numeric(25,5)) 
				 - 
				 cast(power(sum_x, 2) as numeric(25,5)))) 
				*
				((cast((n * sum_y2) as numeric(25,5)) 
				 - 
				 cast(power(sum_y, 2) as numeric(25,5)))))
			)), 3)											"Correlation Coefficent"
from 		agg_elements
