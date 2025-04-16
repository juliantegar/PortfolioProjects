select top 100 * from PortfolioProjectt..ecommerce_transactions
-----------------------------------------------------------
-- 1. Produk terlaris per kategori
select
	Product_Category,
	count(*) as total_transactions,
	sum(purchase_amount) as total_revenue
from PortfolioProjectt..ecommerce_transactions
group by Product_Category
order by 3
--------------------------------------------------------------
-- 2. Top 5 cust dengan spending terbanyak
select top 5
	User_Name,
	Country,
	sum(purchase_amount) as total_spend
from PortfolioProjectt..ecommerce_transactions
group by User_Name, country
order by 3 desc
-------------------------------------------------------------
-- 3. Trend monthly purchase
with monthly_data as(
select
	FORMAT(Transaction_Date, 'yyyy-MM') AS month,
	sum(purchase_amount) as monthly_revenue
from PortfolioProjectt..ecommerce_transactions
group by FORMAT(Transaction_Date, 'yyyy-MM') 
)
select 
	MONTH,
	monthly_revenue,
	lag(monthly_revenue, 1) over (order by month) as previous_revenue,
	(monthly_revenue-lag(monthly_revenue, 1) over (order by month)) /
	nullif(lag(monthly_revenue, 1) over (order by month), 0)*100 as growth
from monthly_data
order by month
-------------------------------------------------------------------
-- 4. Cust segmentation based on purchasing frequency
select
	User_Name,
	Country,
	count(*) as purchase_frequency,
	sum(purchase_amount) as total_spending,
	case
		when count(*) >60 then 'Loyal user'
		when count(*) between 40 and 59 then 'Average user'
		else 'New user'
	end as segmentation
from PortfolioProjectt..ecommerce_transactions
group by User_Name, country
order by 4 desc
-----------------------------------------------------------------
-- 5. Payment method comparison
select
	country,
	Payment_Method,
	count(*) as total_transaction,
	sum(purchase_amount) as total_revenue
from PortfolioProjectt..ecommerce_transactions
group by Country, Payment_Method
order by 1, 4 desc

select
	country,
	sum(purchase_amount) as total_revenue
from PortfolioProjectt..ecommerce_transactions
group by Country
order by 2 desc

select
	country,
	count(*) as total_transaction
from PortfolioProjectt..ecommerce_transactions
group by Country
order by 2 desc
----------------------------------------------------------------
-- 6. Customers age distribution
select
	Country,
	case
		when age < 20 then '< 20 tahun'
		when age between 20 and 35 then '20-35 tahun'
		when age between 36 and 50 then '36-50 tahun'
		else '> 50 tahun'
	end as age_group,
	count(*) as total_customers
from PortfolioProjectt..ecommerce_transactions
group by Country,
	case
		when age < 20 then '< 20 tahun'
		when age between 20 and 35 then '20-35 tahun'
		when age between 36 and 50 then '36-50 tahun'
		else '> 50 tahun'
	end
order by 1, 2
---------------------------------------------------------------
