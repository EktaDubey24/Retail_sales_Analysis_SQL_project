--Create Table 
CREATE TABLE retail_sales(
             transactions_id INT PRIMARY KEY,	
			 sale_date DATE,	
			 sale_time TIME,	
			 customer_id INT,	
			 gender	VARCHAR(15),
			 age INT,	
			 category VARCHAR(15), 	
			 quantiy INT,	
			 price_per_unit FLOAT,	
			 cogs FLOAT,	
			 total_sale INT);

Select * from retail_sales;

--count no.of rows & verify with excel
select count(*) from retail_sales;

ALTER TABLE retail_sales --change col name 
RENAME COLUMN quantiy TO quantity;

-----Data Cleaning
--check for Null values
SELECT * 
FROM retail_sales
WHERE 
      transactions_id IS NULL
	  or
	  sale_date IS NULL
	  or
	  sale_time IS NULL
	  or
	  gender IS NULL
	  or
	  category IS NULL
	  or 
	  quantity IS NULL
	  or 
	  cogs IS NULL
	  or 
	  total_sale IS NULL

--Deleting null rows
Delete from retail_sales
where 
     transactions_id IS NULL
	  or
	  sale_date IS NULL
	  or
	  sale_time IS NULL
	  or
	  gender IS NULL
	  or
	  category IS NULL
	  or 
	  quantity IS NULL
	  or 
	  cogs IS NULL
	  or 
	  total_sale IS NULL
	  
--Data Exploration

---How many sales we have?
Select count(*) as total_sales from retail_sales;

--How many distinct/unique customers we have?
Select count(Distinct customer_id) as customers from retail_sales;

----How many unique categories we have?
Select count(Distinct category) as customers from retail_sales;

select Distinct category from retail_sales;

--DATA ANALYSIS & BUSINESS KEY PROBLEMS

--Q1.write query to retrieve all columns for sales made on '2022-11-05'
Select * from retail_sales
 where sale_date = '2022-11-05'

--Q2. write query to retrieve all transactions where category is 'clothing'& quantity >=4 in month of Nov-2022.
Select *
from retail_sales
where category ='Clothing' 
      and quantity >=4
	  and sale_date BETWEEN '2022-11-01' and '2022-11-30'
   
--To calculate the total sales for each category
Select sum(total_sale), category, count(*) as total_order from retail_sales
group by category

--calculate the average age of customers who purchased item from beauty category 
select Round(avg(age),2) as avg_age, category from retail_sales
where category = 'Beauty'
group by category

--To find all transactions where the total_sales is >1000.
select * from retail_sales
where total_sale > 1000

--To find total number of transactions made buy each gender in each category
select count(transactions_id), gender, category from retail_sales 
group by category, gender
order by 1

--Calculate average sale for each month.Find out best selling month in each year 
Select * from 
	(Select Round(avg(total_sale),2) as avg_sales, 
	       EXTRACT(YEAR FROM sale_date) as year,
		   extract(month from sale_date) as month,
		   Rank() Over(Partition by EXTRACT(YEAR FROM sale_date) Order by Round(avg(total_sale),2)) as Rank
	From retail_sales
	group by 2,3) as T1
	--order by 2,1 desc
where Rank =1

--Top 5 Customers based on the Highest total sales  
Select sum(total_sale) as Total_sales, customer_id
from retail_sales
group by customer_id
Order by 1 Desc
Limit 5

--Calc. number of unique customers who purchased items from each category 
Select category,
       Count(Distinct customer_id) 
from retail_sales
Group by category 

--Create each shift & number of orders(Eg: Morning <=12, afternoon between 12&17, Evening >17) and
-- and find transactions in each shift 
With hourly_sales 
AS
(Select *,
       Case 
	        when Extract(Hour from sale_time) < 12 then 'Morning'
			when Extract(Hour from sale_time) between 12 and 17 then 'Afternoon'
			When Extract(Hour from sale_time) >17 then 'Evening'
		End as Shift_time	
from retail_sales 
) 
Select Count(transactions_id) as total_hr_transaction, shift_time from hourly_sales
group by shift_time 	   