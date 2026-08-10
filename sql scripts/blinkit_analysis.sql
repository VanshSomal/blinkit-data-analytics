CREATE DATABASE IF NOT EXISTS blinkit_db;
SHOW DATABASES;

USE blinkit_db;



SELECT * FROM blinkit_data;


USE blinkit_db;

SELECT COUNT(*) AS total_rows
FROM blinkit_data;



SELECT * FROM blinkit_data LIMIT 20;
DESCRIBE blinkit_data;

SELECT * FROM blinkit_data;

--DATA CLEANING

UPDATE blinkit_data
SET Item_Fat_Content =
CASE 
    WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
    WHEN Item_Fat_Content ='reg' THEN 'Regular'
    ELSE  Item_Fat_Content
END;

SELECT DISTINCT (Item_Fat_Content) FROM blinkit_data;


--TOTAL SALES
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
 FROM blinkit_data;

--AVERAGE SALES (Rounded)
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales FROM blinkit_data;

--NUMBER OF ITEMS SOLD
SELECT COUNT(*) AS No_Of_Sales FROM blinkit_data;

-- TOTAL SALES FOR LOW FAT ITEMS
SELECT CAST(SUM(Total_sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Of_Low_Fat_Items FROM blinkit_data WHERE Item_Fat_Content='Low Fat';

--AVERAGE RATING
SELECT CAST(avg(Rating)AS DECIMAL(10,2)) as Avg_Rating FROM blinkit_data;

SELECT Item_Fat_Content,
    CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales,
    CAST (AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Sales,
    CAST(AVG(Rating) AS DECIMAL(10,2) ) AS Avg_Rating
from blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;


--TOP 5 ITEMS having the highest Sales 
-- For bottom 5 write ASC instead of DESC
SELECT Item_Type,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL (10,1)) AS Avg_Sales,
    CAST (COUNT(*) AS DECIMAL(10,0)) As No_Of_Sales,
    CAST(Avg(Rating)AS DECIMAL(10,2)) AS Avg_Rating
from blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC LIMIT 5;

-- 3rd highest selling item 
SELECT Item_Type,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL (10,1)) AS Avg_Sales,
    CAST (COUNT(*) AS DECIMAL(10,0)) As No_Of_Sales,
    CAST(Avg(Rating)AS DECIMAL(10,2)) AS Avg_Rating
from blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC LIMIT 1 OFFSET 2;

-- second highest selling item by using window function
with RankedItems AS(
    SELECT
        Item_Type,
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        DENSE_RANK() OVER(ORDER BY SUM(Total_Sales) DESC) as sales_rank
    FROM blinkit_data
    GROUP BY Item_Type
)
SELECT
    Item_Type,
    Total_Sales
FROM RankedItems
WHERE sales_rank=2

-- Fat Content by Outlet for Total Sales

SELECT Outlet_Location_Type, Item_Fat_Content,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL (10,1)) AS Avg_Sales,
    CAST (COUNT(*) AS DECIMAL(10,0)) As No_Of_Sales,
    CAST(Avg(Rating)AS DECIMAL(10,2)) AS Avg_Rating
from blinkit_data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_Sales DESC;

-- FAt Content by Outlet for Total Sales
SELECT 
    Outlet_Location_Type,
    CAST(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- find avg sales, rating and other metrics for tier 1,2,3 locations

SELECT Outlet_Establishment_Year,
    CAST (SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL (10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC;



SELECT Outlet_Size,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(SUM(Total_Sales)*100/SUM(SUM(Total_Sales)) OVER() AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--  Sales By Outlet Location
SELECT Outlet_Location_Type,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type ASC;


-- All Metrics by Outlet Type
SELECT Outlet_Type,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Average_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Outlet_Type;

