/*
8. How many unique regions are represented in the dataset, and how many listings are there per region?
*/

select 		rs.region										"Region"
			,rs.listings									"# Listings"
			,(select 	count(distinct region)
			from		vehicles
			where 		region is not null) 				"Total # Regions"
from 		(select distinct 	region 
			from				vehicles) r
inner join 	(select 			count(*)	listings
			 								,region
			from 				vehicles
			where 				region is not null
			group by 			region) rs on r.region = rs.region
order by 	rs.listings desc;