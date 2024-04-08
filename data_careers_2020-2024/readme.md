# Data Careers Outlook Analysis

## Introduction
This project utilizes a comprehensive dataset from Kaggle, focusing on jobs and salaries in the data field projected for 2024. Through analysis executed in SQL Server using Transact-SQL, the project aims to uncover key insights into career trends, salary dynamics, and the evolving landscape of data-related occupations. 

## Features
The project addresses several pertinent questions using SQL queries, providing a deeper understanding of the data field:

1. What is the average `salary_in_usd` for each `job_title`?
2. How many unique `job_titles` are recorded in the dataset?
3. Which `employee_residence` countries appear most frequently in the dataset?
4. What is the distribution of `experience_level` in the dataset?
5. Count the number of `full-time` positions versus `part-time` or `contract` positions.
6. What are the top 5 highest paying `job_titles` in `salary_in_usd`?
7. How does the average `salary_in_usd` compare between `work_setting` types?
8. List the average `salary` in the local currency for each `company_location`.
9. What is the average `salary_in_usd` for each `company_size` category?
10. For each `work_year`, how has the `salary_in_usd` trended?
11. Calculate the average `salary_in_usd` for `data scientists` with `5 years` of experience or more.
12. What is the average `salary_in_usd` for `remote` jobs versus `in-person` jobs within each `experience_level`?
13. How many jobs are listed in countries where the `salary_currency` is not `USD`?
14. Create a list of the `job_title` and `salary_in_usd` for all `executive` level positions.
15. Which `job_category` has seen the largest increase in average `salary_in_usd` from the earliest to the latest `work_year`?
16. Identify the top 3 most common job titles for each experience level and list them along with the count of occurrences.
17. Analyze the variance in `salary_in_usd` within each `job_category` and rank them by the largest variance.
18. Determine the average `salary_in_usd` by `job_title` within each `job_category` and order them from highest to lowest.
19. Calculate the compounded annual growth rate (CAGR) of the `salary_in_usd` for each `job_category` across the recorded years.
20. What is the average `salary` (in local currency) to `salary_in_usd` conversion rate for each `salary_currency` by `work_year`?

## System Requirements
- SQL Server (any recent version supporting Transact-SQL)

## Getting Started
1. Download the dataset from Kaggle: [Jobs and Salaries in Data Field 2024](https://www.kaggle.com/datasets/murilozangari/jobs-and-salaries-in-data-field-2024?resource=download).
2. Install SQL Server and ensure it's properly configured on your system.
3. Utilize the provided `data_careers_2020-2024.sql` file to create and populate your database with the Kaggle dataset.
4. Execute the T-SQL queries outlined in the project to explore the dataset and derive insights.
5. Analyze the results to understand the salary trends, job outlook, and other significant patterns within the data careers landscape from 2020 to 2024.
