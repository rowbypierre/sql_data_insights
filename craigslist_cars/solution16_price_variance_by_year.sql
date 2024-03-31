/*
16. What is the average price variation of vehicles from the oldest to the newest year in the dataset?
*/

with sample as (
	select		year
				,price
	from 		vehicles 
	where 		price is not null
				and year is not null
	and 		price > 0
	and 		price < 516999
	order by 	random()
	limit		1000
)

select 		round((
			sum(power((s.price - mean.x_bar),2))
			/
			(
				(select 	count(*)
				from 		sample)
				-
				1
			)
			), 2)					"Variance"
			,year					"Year"
from 		sample s
			,(select	avg(price) 	"x_bar"
			from		sample) 	mean
group by 	year
order by 	year desc;