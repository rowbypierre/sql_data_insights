/*
4. How does the average odometer reading vary by vehicle year?
*/

select 		Year					"Year"
			,ceiling(avg(odometer)) "Average Odometer Reading"	
from		vehicles
where 		odometer > 0
and 		odometer < 999999
group by 	year
having 		year is not null
order by 	year desc;
