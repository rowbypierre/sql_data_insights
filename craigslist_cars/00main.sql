-- Create Database.
create database sql_training;

-- Create table structure to import data from csv.
create table vehicles (
	id int,
	url	varchar(100),
	region	varchar(100),
	region_url varchar(100),
	price int,	
	year int,	
	manufacturer varchar(100),	
	model varchar(100),	
	condition varchar(100),	
	cylinders varchar(100),	
	fuel varchar(100),	
	odometer int,	
	title_status varchar(100),	
	transmission varchar(100),	
	VIN varchar(100),	
	drive varchar(100),	
	size varchar(100),	
	type varchar(100),	
	paint_color varchar(100),	
	image_url varchar(100),	
	description text,	
	county varchar(100),	
	state varchar(100),	
	lat varchar(100),	
	long varchar(100),	
	posting_date date
)

-- Alter columns, adjusting for data coloumn widths.
alter table 	vehicles
alter column 	id
type 			NUMERIC(20);

alter table 	vehicles
alter column 	model 
type 			varchar(500);

alter table 	vehicles
alter column 	url 
type 			varchar(500);

alter table 	vehicles
alter column	price
type 			numeric;


-- Copy data into table from local downloads folder.
copy 		vehicles 
from 		'C:\Users\rolar\Downloads\archive (1)\vehicles.csv'
delimiter	','
csv header;

-- Check record counts match (table vs flat file).
select 		case 
				when (select count(*) from vehicles) = 426880 
					then 'MATCH'
				else 
					'MISMATCH'
			end as checker;

-- Questions/ Queries below.

/*
1. What is the average price of vehicles listed in the dataset?
*/

select		concat('$',
				   round(AVG(price), 2)) "Average Price"
from 		vehicles 
where 		price is not null
and 		price > 0
and 		price < 516999; -- cars priced beyond this amount are erroneous

/*
2. How many vehicles are listed by each manufacturer, sorted by the number of listings in descending order?
*/

select 		manufacturer	"Manufacturer" 
			,count(*) 		"# of Listings"
from 		vehicles
where 		manufacturer is not null
group by	manufacturer
order by	count(*) desc;

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

/*
5. What are the counts of vehicles listed by condition status?
*/

select 		condition			"Condition", 
			count(*) 			"Occurrences"
from 		vehicles
where 		condition is not null
group by	condition
order by	count(*) desc;

/*
6. Can you identify the distribution of vehicles by fuel type?
*/

select 		fuel								"Fuel Type" 
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
from 		vehicles v
where 		fuel is not null
group by	fuel
order by	count(*) desc;

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

/*
8. How many unique regions are represented in the dataset, and how many listings are there per region?
*/

select 		rs.region										"Region"
			,rs.listings									"# Listings"
			(select 	count(distinct region)
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

/*
10. For each state, what is the average latitude and longitude of the vehicle listings?
*/

select 		upper(state)							"State"
			,round(avg(cast(lat as numeric)),5) 	"Average Latitude"
			,round(avg(cast(long as numeric)),5) 	"Average Longitude"
from 		vehicles
where		state is not null
and 		lat is not null
and 		long is not null
group by	state

/*
11. How many vehicles are listed with a 'salvage' title status?
*/

select 	count(*)	"# of Salvage Titles"
from	vehicles
where 	title_status like 'salvage';

/*
12. What are the top 5 most expensive vehicles listed, including their model and price?
*/

with catalog as (
	select 		manufacturer								Make
				,model										Model
				,concat('$', price) 						Cost
				, row_number() over(order by price desc) 	Rank
	from 		vehicles
	where 		price is not null
	and 		price > 0
	and 		price < 516999
	and 		manufacturer is not null
)

select 		*
from 		catalog
where 		Rank < 6

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

/*
14. What is the percentage of listings for each transmission type?
*/

select 		transmission								"Transmission Type", 
			concat(
			round(
			cast(count(*) as numeric)
			/
			(select 	cast(count(*) as numeric)
			from 		vehicles
			where		transmission is not null)
			* 
			100	
				,2), '%') 								"Percentage of Listings"
from 		vehicles v
where 		transmission is not null
group by	transmission
order by	count(*) desc;

/*
15. On which month and year exist the highest number of vehicle listings?
*/

select 		to_char(posting_date, 'YYYY')	"Year"
			,to_char(posting_date, 'Month')	"Month"
			,count(*)						"# of Listings"
from 		vehicles
where 		posting_date is not null
group by 	to_char(posting_date, 'Month')
			,to_char(posting_date, 'YYYY')
order by 	count(*) desc
limit 1;

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
order by 	year desc

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

/*
18. What is the most common number of cylinders in the vehicles listed?
*/

select 		cylinders						"# of Cyclinders"
			,count(*)						"# of Listings"
from 		vehicles
where 		cylinders is not null
group by 	cylinders
order by 	count(*) desc
limit 1;

/*
19. Can you determine the month with the lowest number of vehicle postings?
*/

select 		to_char(posting_date, 'YYYY')	"Year"
			,to_char(posting_date, 'Month')	"Month"
			,count(*)						"# of Listings"
from 		vehicles
where 		posting_date is not null
group by 	to_char(posting_date, 'Month')
			,to_char(posting_date, 'YYYY')
order by 	count(*) 
limit 1;

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