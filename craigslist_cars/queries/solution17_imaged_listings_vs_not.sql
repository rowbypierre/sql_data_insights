/*
17. How many listings have images associated with them versus those that do not?
*/

select 		'# of Listings w/ Image' 	"Category"
			,count(*)					"Total"		
from 		vehicles 
where 		length(image_url) > 0
union
select 		'# of Listings w/o Image' 	"Category"
			,count(*)					"Total"		
from 		vehicles 
where 		length(image_url) < 1