     ---------- CAR SALES PROJECT USING Dbeaver---------
                          
-- In this project I have used Dbeaver environment to import the whole csv file into the system and performed the SQL queries


--1
SELECT * FROM car_sales_customer csc;

--2
SELECT * FROM car_sales_customer csc WHERE "Car Make" = "Toyota";

--3
SELECT * FROM car_sales_customer csc WHERE substr(date, 7, 4) = '2022' ORDER BY date ASC;

--4
SELECT SUM("Sale Price") FROM car_sales_customer csc;

--5
SELECT COUNT("Sale Price") FROM car_sales_customer csc;

--6
SELECT AVG("Sale Price") FROM car_sales_customer csc;

--7
SELECT "Car Make",AVG("Sale Price") AS avg_price FROM car_sales_customer csc GROUP BY "Car Make";

--8
SELECT "Salesperson", COUNT("Sale Price") as sales_count FROM car_sales_customer csc GROUP BY "Salesperson" ORDER BY sales_count DESC LIMIT 5;

--9
SELECT   substr(date, 7, 4) || "-" || substr(date, 4, 2) AS year_month, SUM("Sale Price") AS monthly_sales FROM car_sales_customer csc WHERE "Date" IS NOT NULL GROUP BY year_month ORDER BY year_month;

--10
SELECT SUM("Commission Earned") FROM car_sales_customer csc; 

--11
SELECT substr(date, 7, 4) || "-" || substr(date, 4, 2) AS year_month, SUM("Sale Price") as monthly_sales FROM car_sales_customer csc GROUP BY year_month ORDER BY monthly_sales DESC LIMIT 1;

--12
SELECT "Car Model", COUNT("Car Model") as md FROM car_sales_customer csc  GROUP BY "Car Model" ORDER BY md  DESC LIMIT 1;

--13
SELECT Salesperson ,AVG("Commission Rate") AS avg_com_per FROM car_sales_customer csc GROUP BY Salesperson ORDER BY avg_com_per ASC;

--14
SELECT "Car Year", COUNT("Car Year") as sales_count FROM car_sales_customer csc GROUP BY "Car Year";

--15
SELECT "Salesperson", "Commission Rate" FROM car_sales_customer csc WHERE "Commission Rate" >(SELECT AVG("Commission Rate") FROM car_sales_customer csc) GROUP BY Salesperson ORDER BY "Commission Rate" ASC;

--16
SELECT "Salesperson", SUM("Sale Price") as sprice FROM car_sales_customer csc GROUP BY Salesperson ORDER BY sprice DESC;

--17
WITH ModelCounts AS (
    SELECT 
        "Car Make",
        "Car Model",
        COUNT("Car Model") AS count_model
    FROM car_sales_customer
    GROUP BY "Car Make", "Car Model"
),
RankedModels AS (
    SELECT 
        "Car Make",
        "Car Model",
        count_model,
        ROW_NUMBER() OVER (PARTITION BY "Car Make" ORDER BY count_model DESC) AS rn
    FROM ModelCounts
)
SELECT 
    "Car Make",
    "Car Model",
    count_model
FROM RankedModels
WHERE rn <= 3
ORDER BY "Car Make", rn DESC;

--18

SELECT substr(date, 7, 4) as year, "Car Make", AVG("Sale Price") as avg_sales_price FROM car_sales_customer csc GROUP BY year, "Car Make" ORDER BY "Car Make" DESC;

--19
SELECT "Customer Name", SUM("Sale Price") as total_spend FROM car_sales_customer csc GROUP BY "Customer Name" ORDER BY total_spend DESC LIMIT 5;

--20
-- Calculate the correlation between sale_price and commission earned

WITH Stats AS (
    SELECT
        COUNT(*) AS n,
        SUM("Sale Price") AS sum_x,
        SUM("Commission Earned") AS sum_y,
        SUM("Sale Price" * "Commission Earned") AS sum_xy,
        SUM("Sale Price" * "Sale Price") AS sum_xx,
        SUM("Commission Earned" * "Commission Earned") AS sum_yy
    FROM car_sales_customer csc
),

Correlation AS (
    SELECT
        n,
        sum_x,
        sum_y,
        sum_xy,
        sum_xx,
        sum_yy,
        (n * sum_xy - sum_x * sum_y) / 
        (sqrt((n * sum_xx - sum_x * sum_x) * (n * sum_yy - sum_y * sum_y))) AS correlation
    FROM Stats
)

SELECT correlation
FROM Correlation;

---------------------------------------- The End-------------------------------------------------



