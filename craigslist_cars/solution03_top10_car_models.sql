/*
3. What are the top 10 most common vehicle models listed in the dataset?
*/

with model_count as (
	select 		model			"Model" 
				,count(*) 		"Occurrences"
	from 		vehicles
	where 		model is not null
	group by	model
	order by	count(*) desc
),

mc_rank as (
	select 	* 
			,row_number() over(order by model_count.Occurrences desc) Rank
	from  	model_count
) 

select 		*
from		mc_rank
where		Rank < 11;