/*
1. What is the average price of vehicles listed in the dataset?
*/

select		concat('$',
				   round(AVG(price), 2)) "Average Price"
from 		vehicles 
where 		price is not null
and 		price > 0
and 		price < 516999;