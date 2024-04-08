/*
7. What is the average price of vehicles by paint color?
*/

select		concat('$',
				   round(AVG(price), 2))  		"Average Price"
			,paint_color						"Paint Color"
from 		vehicles 
where 		price is not null
and 		paint_color is not null
and 		price > 0
and 		price < 516999 -- cars priced beyond this amount are erroneous
group by	paint_color 
order by	round(AVG(price), 2) desc;