
-- 1. BMW DATABASE SETUP / CONFIGURATION BASE BMW --

CREATE DATABASE bmw_db;
USE bmw_db;

SELECT count(*) FROM bmw_global_sales_2018_2025;

SELECT * FROM bmw_global_sales_2018_2025 LIMIT 5;


-- 2. DATA CLEANING / NETTOYAGE DONNÉES --

SET SQL_SAFE_UPDATES = 0;

-- 2.1  Fix negative BEV shares / Corriger BEV négatifs --

UPDATE bmw_global_sales_2018_2025
SET BEV_Share = 0
WHERE BEV_Share < 0;

-- 2.2 Check data quality issues / Vérifier qualité données 

SELECT *
FROM bmw_global_sales_2018_2025
WHERE Units_Sold < 0
	OR Revenue_EUR < 0;
    
SELECT count(*) AS raws_negative_premium
FROM bmw_global_sales_2018_2025
WHERE Premium_Share < 0; 

SELECT count(*)  AS rows_null_premium
FROM bmw_global_sales_2018_2025
WHERE Premium_Share is NULL;

SELECT count(*) AS raws_null_units
FROM bmw_global_sales_2018_2025
WHERE Units_Sold is NULL;

SELECT count(*) AS raws_null_units
FROM bmw_global_sales_2018_2025
WHERE Avg_Price_EUR is NULL;


-- 3. DATA STRUCTURE / STRUCTURE DONNÉES --

-- 3.1 Date coverage / Couverture temporelle

SELECT DISTINCT Year
FROM bmw_global_sales_2018_2025
ORDER by Year;

SELECT DISTINCT Month
FROM bmw_global_sales_2018_2025
ORDER BY Month;

-- 3.2 Data ranges / Plages de valeurs

SELECT
	min(BEV_Share)	AS min_bev,
    max(BEV_Share)	AS max_bev,
    min(Premium_Share) AS min_premium,
    max(Premium_Share) AS max_premum
FROM bmw_global_sales_2018_2025;
    
-- 3.3 Detect duplicates / Détecter doublons

SELECT
	Year,
    Month,
    Region,
    Model,
    count(*) AS nb_rows
FROM bmw_global_sales_2018_2025
GROUP BY
	Year,
    Month,
    Region,
    Model
HAVING nb_rows > 1
ORDER BY nb_rows DESC;


-- 4. EXPLORATORY ANALYSIS / ANALYSE EXPLORATOIRE --

-- 4.1 Sales by Region / Ventes par Région

SELECT
	Region,
    SUM(Units_Sold) AS total_units,
    SUM(Revenue_EUR) / 1000000000 as revenue_bn
FROM bmw_global_sales_2018_2025
GROUP BY Region
ORDER BY revenue_bn DESC;

-- 4.2 Sales by Year / Ventes par Année

SELECT
	Year,
    SUM(Units_Sold) AS total_units,
    SUM(Revenue_EUR) / 1000000000 as revenue_bn
FROM bmw_global_sales_2018_2025
GROUP BY Year
ORDER BY Year;

-- 4.3 BEV + Premium by Region / BEV + Premium par Région

SELECT
	Region,
    round(AVG(BEV_Share) * 100, 2) AS avg_bev_pct,
	round(AVG(Premium_Share), 2) AS avg_premium_index
FROM bmw_global_sales_2018_2025
GROUP BY Region
ORDER BY avg_bev_pct DESC;

-- 4.4 Top 5 Models / Top 5 Modèles

SELECT
	Model,
    SUM(Units_Sold) AS total_units,
    SUM(Revenue_EUR) / 1000000000 as revenue_bn
FROM bmw_global_sales_2018_2025
GROUP BY Model
ORDER BY revenue_bn DESC
Limit 5;

-- 4.5 BEV seasonality 2024 / Saisonnalité BEV 2024

SELECT
	Month,
    round(AVG(BEV_Share) * 100, 2) AS avg_bev_pct_2024
FROM bmw_global_sales_2018_2025
WHERE Year = 2024
GROUP BY Month
ORDER BY Month;


-- 5. GLOBAL KEY FIGURES / CHIFFRES CLÉS GLOBEAUX --

SELECT
	sum(Units_Sold) as total_units,
	sum(Revenue_EUR) / 1000000000 AS total_revenue_bn,
	round(AVG(BEV_Share) * 100, 2) AS avg_bev_pct,
	round(AVG(Premium_Share), 2) as avg_premium_index
FROM bmw_global_sales_2018_2025;


-- 6. PRICE ANALYSIS / ANALYSE PRIX --

SELECT
	Year,
    sum(Revenue_EUR) / sum(Units_Sold) AS revenue_per_unit
FROM bmw_global_sales_2018_2025   
GROUP BY Year
ORDER BY Year;
    
 
 -- Export --
 
 SELECT *
 FROM bmw_global_sales_2018_2025;
 
 
 SELECT COUNT(*) AS total_rows
FROM bmw_global_sales_2018_2025;
 



    