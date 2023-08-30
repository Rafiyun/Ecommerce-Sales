select * from ecommerce_sales

-- To Calculate the sum of anything related to the year 2017, we need to split the year into separate columns first

SELECT Year(Order_Date)AS Years
from ecommerce_sales

ALTER TABLE ecommerce_sales
add Year_Order nvarchar(50)

UPDATE ecommerce_sales
set Year_Order = Year(Order_Date)


-- Calculate The 2017 Year Sales

select 
sum(sales) Sales_2017
from ecommerce_sales
where Year_order = '2017'

-- Calculate the 2017 Profit

select 
sum(Profit_Per_Order) AS Profit_2017
from ecommerce_sales
where Year_order = '2017'

-- Calculate the 2017 Order Quantity

select 
sum(Order_Quantity) AS Order_Quantity_2017
from ecommerce_sales
where Year_order = '2017'


-- Calculate the % of market share by sales (Year 2017)

SELECT Market, CAST(SUM(Sales) AS decimal (10,2)) as total_Sales,
CAST(SUM(Sales) * 100 / (SELECT SUM(Sales) from ecommerce_sales WHERE Year_Order = '2017') AS DECIMAL(10,2)) AS Percentage
from ecommerce_sales
WHERE Year_Order = '2017'
group by Market


-- Calculating the market wise acquisition per Month by all year

SELECT 
	DATEPART(MONTH, Order_Date) as Month_Number,
	Market,
	sum(cast(Order_Quantity as int)) as Total_Quantity
from ecommerce_sales
--where Year_Order = '2017'
group by Market, DATEPART(MONTH, Order_Date)
order by DATEPART(MONTH, Order_Date), Total_Quantity desc

-- Top 10 sales by category

SELECT
	distinct TOP 10 Category_Name,
	sum(Sales) as total
from ecommerce_sales
where Year_order = '2017'
group by Category_Name
order by total desc

-- Calculate the highest Region Sales and ranking them (year 2017)

SELECT 
	DISTINCT Market, 
	sum(cast(Sales as int)) as total,
	DENSE_RANK () OVER(
	ORDER BY sum(Sales) DESC
	) AS Rank
from ecommerce_sales
WHERE Year_Order = '2017'
group by Market
order by total desc

-- Or better by using below

SELECT 
	DENSE_RANK () OVER(
	ORDER BY sum(Sales) DESC
	) AS Rank,
	Market,
	sum(cast(Sales as int)) as Total_Sales
from ecommerce_sales
where Year_Order = '2017'
group by Market
order by Total_Sales desc
