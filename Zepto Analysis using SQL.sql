Create database Zepto;
use zepto;
Create table Zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar(150) not NULL,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer);

ALTER TABLE zepto_v2
ADD COLUMN sku_id serial primary key;
Select * from zepto_v2
limit 10;

Select * from zepto_v2
where name is null
or 
Category IS NULL
OR 
discountPercent IS Null
or 
availableQuantity is null
or 
discountedSellingPrice is null
or 
weightInGms is null
or 
outOfStock is null
or quantity is null;

-- Different product category
Select distinct category 
from zepto_v2
order by Category;

-- Products in stock Vs Out of stock
Select outOfStock , count(sku_id)
from zepto_v2
group by outOfStock;

-- product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto_v2
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Data Cleaning

-- Products with price = 0 
Select * from zepto_v2
where mrp = 0 
or discountedSellingPrice = 0;

Delete from zepto_v2
where mrp = 0;

-- Coonvert paise to ruppees
update zepto_v2
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

Select mrp, discountedSellingPrice from zepto_v2;

-- Business Questions
-- Q1.Find the top 10 best-value products based on the discount percentage.
Select Distinct name, mrp, discountPercent
from zepto_v2
order by discountPercent Desc
limit 10;

-- Q2.What are the products with high MRP but out of stock
SELECT distinct name,mrp
FROM zepto_v2
WHERE outofstock = True and mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate estimated revenue for each category
Select category,
sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto_v2
group by category
order by total_revenue;

-- Q4.Find all products where MRP is greater than 500 and discount is less than 100.
Select distinct name, mrp, discountPercent
from zepto_v2
where mrp > 500 and discountPercent < 10
order by mrp Desc, discountPercent desc;

-- Q5.Identify the top 5 categories offering the highest average discount percentage.
Select category,
round (avg(discountPercent) , 2) as avg_discount
from zepto_v2
group by category
order by avg_discount desc
limit 5;

-- Q6.Find the price per gram for products above 100g and sort by best values.
Select distinct name , weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto_v2
Where weightInGms >= 100
order by price_per_gram;

-- Q7.Group the products into categories like Low , medium, Bulk.
select distinct name, weightInGms,
case when weightIngms < 1000 then 'Low'
	 when weightInGms < 5000 then 'Medium'
     else 'Bulk'
     End as weight_category
from zepto_v2;

-- Q8.What is the Total Inventory Weight per Category
Select category ,
sum(weightInGms * availableQuantity) as total_weight
from zepto_v2
Group by category
order by total_weight;


