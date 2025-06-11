CREATE TABLE Pakistan_Ecommerce.Transactions5 (
	item_id BIGINT,
    `status` VARCHAR(50),
    created_at VARCHAR(20),
    sku VARCHAR(200),
    price INT,
    qty_ordered INT,
    grand_total INT,
    increment_id BIGINT,
    category_name_1 VARCHAR(50),
    sales_commission_code VARCHAR(25),
    discount_amount INT,
    payment_method VARCHAR(20),
    `Working Date` VARCHAR(20),
    `BI Status` VARCHAR(10),
     MV INT,
    `Year` INT,
    `Month` INT,
    `Customer Since` VARCHAR(20),
    `M-Y` VARCHAR(20),
    FY VARCHAR(10),
    `Customer ID` BIGINT
);


SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/rangasahasra/PycharmProjects/DAP/cleaned_dataset.csv'
INTO TABLE Pakistan_Ecommerce.Transactions5
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Pakistan_Ecommerce.Transactions5;
-- increment_id is invoice number
-- FY refers to fiscal year

-- ---------------------------------------- Data cleaning ----------------------------------------
CREATE TABLE Pakistan_Ecommerce.TransactionsNew
LIKE Pakistan_Ecommerce.Transactions5;

INSERT Pakistan_Ecommerce.TransactionsNew
SELECT * FROM Pakistan_Ecommerce.Transactions5;

-- --------------- CHECK FOR NULL VALUES
SELECT * FROM Pakistan_Ecommerce.TransactionsNew;

SELECT * FROM Pakistan_Ecommerce.TransactionsNew
WHERE item_id IS NULL or `status` IS NULL OR created_at IS NULL OR 
sku IS NULL OR price IS NULL OR qty_ordered IS NULL OR grand_total IS NULL
OR increment_id IS NULL OR category_name_1 IS NULL OR sales_commission_code IS NULL OR
discount_amount IS NULL OR payment_method IS NULL OR `BI Status` IS NULL OR MV IS NULL OR 
`Year` IS NULL OR `Month` IS NULL OR `Customer Since` IS NULL OR `M-Y` IS NULL OR FY IS NULL
OR `Customer ID` IS NULL;
-- --- no null values stored as nulls
-- but some values are stored as \N

-- item_id, there are some item_ids which are skipped
SELECT * FROM Pakistan_Ecommerce.TransactionsNew
WHERE item_id = "\\N";
-- No null values stored at \N

SELECT item_id FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- some item_ids are skipped, but it is difficult to obtain information abotut those

-- Let us see if there is any duplicate rows (by checking duplicate item_ids)
SELECT item_id, COUNT(item_id) FROM Pakistan_Ecommerce.TransactionsNew
GROUP BY item_id
HAVING COUNT(item_id) > 1;
-- no duplicate rows

-- Let us analyse the status
SET SQL_SAFE_UPDATES = 0;

SELECT DISTINCT status FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- There are 2 categories order_refunded and refund which are essentially the same, so let us make everything refund
UPDATE Pakistan_Ecommerce.TransactionsNew
SET `status` = 'refund'
WHERE `status` LIKE 'order_refunded%';

-- There is status where status = '', let us change that to unknown
UPDATE Pakistan_Ecommerce.TransactionsNew
SET `status` = 'unknown'
WHERE `status` = '';

-- No apparent errors or disrepancies are visible, no values stored as \N

-- ------------ created_at
SELECT DISTINCT created_at FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- NO \N or null values

SELECT * FROM Pakistan_Ecommerce.TransactionsNew
WHERE created_at != `Working Date`;
-- drop column Working Date since it is essentially the same as created_at
ALTER TABLE Pakistan_Ecommerce.TransactionsNew
DROP COLUMN `Working Date`;

-- First add a new datetime column
ALTER TABLE Pakistan_Ecommerce.TransactionsNew
ADD COLUMN new_datetime_col DATE;
-- Update with converted values
UPDATE Pakistan_Ecommerce.TransactionsNew
SET new_datetime_col = STR_TO_DATE(created_at, '%m/%d/%Y');

ALTER TABLE Pakistan_Ecommerce.TransactionsNew
RENAME COLUMN new_datetime_col TO `Date`;


-- ------- sku --------
SELECT * FROM Pakistan_Ecommerce.TransactionsNew
WHERE sku = "\\N" ;
-- no nulls stored as \N
SELECT DISTINCT sku FROM Pakistan_Ecommerce.TransactionsNew ORDER BY 1;
-- There are many inconsistencies with capitalisation, lets make all letters capital and remove spaces
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sku = (UPPER(REPLACE(sku, ' ', '')));

-- ----- Price -------
SELECT DISTINCT Price FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- no \N, however there are prices of 0 which may determine a closer look
SELECT `status`, COUNT(status) FROM Pakistan_Ecommerce.TransactionsNew
WHERE Price = 0
GROUP BY `status`;
-- Although there are many cancelled and refunded orders, there are many paid and received orders as well indicating that some are legitimate items

SELECT sku, `status`, COUNT(*) AS order_count
FROM Pakistan_Ecommerce.TransactionsNew
WHERE price = 0
GROUP BY sku, `status`
ORDER BY sku, `status`;

SELECT DISTINCT sku
FROM Pakistan_Ecommerce.TransactionsNew
WHERE price = 0
GROUP BY sku
HAVING COUNT(DISTINCT `status`) = 
       COUNT(DISTINCT CASE WHEN `status` IN ('refund', 'canceled') THEN `status` END);

-- These are the items which have prices of 0 and are always refunded or cancelled. However, let us not remove them from the dataset but rather keep it as a business improvement.

-- ---------------- quantity ordered -----
SELECT DISTINCT qty_ordered FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- The one anomaly detected is a quantity of 1000
SELECT * FROM Pakistan_Ecommerce.TransactionsNew
WHERE qty_ordered = 1000;
-- Only 6 transactions, out of which 4 are cancelled. We will keep these trasactions in the dataset

-- --------------

-- --------------- discount_amount----------
SELECT DISTINCT discount_amount FROM Pakistan_Ecommerce.TransactionsNew;
-- no nulls, stored as 0 instead

-- ------ grand_total ------
SELECT * FROM Pakistan_Ecommerce.TransactionsNew;

SELECT *
FROM Pakistan_Ecommerce.TransactionsNew
WHERE grand_total - (qty_ordered*price - discount_amount) != 0;

SELECT MV, grand_total, grand_total - (qty_ordered*price - discount_amount)
FROM Pakistan_Ecommerce.TransactionsNew
WHERE grand_total - (qty_ordered*price - discount_amount) != 0;

-- we can see for many rows, grand total has not been calculated correctly
-- Since earlier I was unclear on what MV was, I wanted to dig deeper to see if MV had anything to do with the incorrect values
-- Upon inspection, for some rows, MV is the value of the difference, and for some rows it is not, and for many consecutive rows the MV of the top row is the grand total difference of the bottom row or vice-versa
-- making me think if it was keyed in incorrectly
-- My solution is to leave the MV column undisturbed, and create a new grand_total column

ALTER TABLE Pakistan_Ecommerce.TransactionsNew
ADD COLUMN new_total INT;
UPDATE Pakistan_Ecommerce.TransactionsNew
SET new_total = qty_ordered*price - discount_amount;
-- Let's also add a column for the total without discount for future analysis
ALTER TABLE Pakistan_Ecommerce.TransactionsNew
ADD COLUMN `price*q` INT;
UPDATE Pakistan_Ecommerce.TransactionsNew
SET `price*q` = qty_ordered*price;
-- drop grand_total
ALTER TABLE Pakistan_Ecommerce.TransactionsNew
DROP COLUMN grand_total;

-- ------------------- increment_id ---------
SELECT increment_id FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- no disrepancies observed

-- --------- category_name_1 -----
SELECT DISTINCT category_name_1 FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- there are empty values, can create a new category called Unknown
SELECT DISTINCT sku FROM Pakistan_Ecommerce.TransactionsNew
WHERE category_name_1 = '';

SELECT DISTINCT category_name_1 FROM Pakistan_Ecommerce.TransactionsNew
WHERE sku IN (
SELECT DISTINCT sku FROM Pakistan_Ecommerce.TransactionsNew
WHERE category_name_1 = ''
);
-- this shows us that the category_name_1 can be inferred for some of the sku

SET SQL_SAFE_UPDATES = 0;

UPDATE Pakistan_Ecommerce.TransactionsNew t1
JOIN (
    SELECT sku, MAX(category_name_1) AS category_name_1
    FROM Pakistan_Ecommerce.TransactionsNew
    WHERE category_name_1 IS NOT NULL AND category_name_1 != ''
    GROUP BY sku
) t2 ON t1.sku = t2.sku
SET t1.category_name_1 = t2.category_name_1
WHERE t1.category_name_1 IS NULL OR t1.category_name_1 = '';

-- Still some category_name_1 which is blank
UPDATE Pakistan_Ecommerce.TransactionsNew
SET category_name_1 = 'Other'
WHERE category_name_1 = '' OR category_name IS NULL;

SELECT DISTINCT category_name_1 FROM Pakistan_Ecommerce.TransactionsNew;
-- ------------ Sales commission code ----
SELECT sales_commission_code, COUNT(sales_commission_code) FROM Pakistan_Ecommerce.TransactionsNew
GROUP BY sales_commission_code
ORDER BY 1;

-- First, we notice that there are inconsistencies in capitalisation, and use of spaces, dashes, dots e.t.c
-- Remove, _, -, /, ., ' ', and capitalise everything
-- Nullsare okay in this scenario
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '-', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '_', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, ' ', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '.', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '/', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '#', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '?', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, ',', '')));
UPDATE Pakistan_Ecommerce.TransactionsNew
SET sales_commission_code = TRIM(UPPER(REPLACE(sales_commission_code, '"', '')));

-- Now there are a few anomalies, such as 0, 'v', 001, 
SELECT DISTINCT sales_commission_code, COUNT(sales_commission_code) 
FROM Pakistan_Ecommerce.TransactionsNew
WHERE length(sales_commission_code) <= 2
GROUP BY sales_commission_code;
-- However, there are a lot of such values, hence it is unclear if these are typos or legitimate codes

SELECT DISTINCT length(sales_commission_code), COUNT(length(sales_commission_code))
FROM Pakistan_Ecommerce.TransactionsNew
GROUP BY length(sales_commission_code)
ORDER BY COUNT(length(sales_commission_code));
-- --------------- Hence, no change is made to this column

-- ----- PAYMENT METHOD ----
SELECT DISTINCT payment_method FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;

-- Capitalise everything to standardise
-- cashatdoorstep --> cod
-- all easypay variants to easypay
-- all jazz variants to jazz
UPDATE Pakistan_Ecommerce.TransactionsNew 
SET payment_method = UPPER(payment_method);

UPDATE Pakistan_Ecommerce.TransactionsNew 
SET payment_method = "EASYPAY"
WHERE payment_method LIKE "%EASYPAY%";

UPDATE Pakistan_Ecommerce.TransactionsNew 
SET payment_method = "JAZZ"
WHERE payment_method LIKE "%JAZZ%";
-- -------------

SELECT * FROM Pakistan_Ecommerce.TransactionsNew;
SELECT DISTINCT `Year` FROM Pakistan_Ecommerce.TransactionsNew;
SELECT DISTINCT `Month` FROM Pakistan_Ecommerce.TransactionsNew;
SELECT DISTINCT `Customer Since` FROM Pakistan_Ecommerce.TransactionsNew
ORDER BY 1;
-- Although there are nulls, there is no way of finding out the values, so we will leave the nulls unaltered
SELECT DISTINCT `M-Y` FROM Pakistan_Ecommerce.TransactionsNew ORDER BY 1;
SELECT DISTINCT `FY` FROM Pakistan_Ecommerce.TransactionsNew ORDER BY 1;
SELECT DISTINCT `Date` FROM Pakistan_Ecommerce.TransactionsNew ORDER BY 1;
-- --------------------------------------------------------------------------------------------------
SELECT payment_method FROM Pakistan_Ecommerce.TransactionsNew WHERE `status` = 'fraud';
-- ------------------------------ DATA EXPLORATION ------------------
-- We will only use rows where the BI Status is Valid for this exploration
CREATE TABLE Pakistan_Ecommerce.ValidTransactions AS
SELECT *
FROM Pakistan_Ecommerce.TransactionsNew
WHERE `BI Status` = 'Valid';

SELECT * FROM Pakistan_Ecommerce.ValidTransactions;

-- How can we improve the platform from a business perspective
-- 1) Analyse the customer base -> increase customer retention and spending
-- LET US ANALYSE THE MOST VALUABLE CUSTOMERS IN TERMS OF SALES VOLUME
-- SELECT ~TOP 10% OF CUSTOMERS BY TOTAL SPENT AND ~TOP 10% OF CUSTOMERS BY TOTAL NUMBER OF ORDERS

SELECT `Customer ID` FROM (
SELECT `Customer ID` FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY `Customer ID` 
ORDER BY SUM(`price*q`) DESC
LIMIT 4362
) AS t
UNION
SELECT `Customer ID` FROM (
SELECT `Customer ID` FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY `Customer ID` 
ORDER BY COUNT(increment_id) DESC
LIMIT 4362
) AS q;
-- These customers should be incentivised thriugh seasonal discounts and loyalty discounts, and perhaps marketing messages can be regularly sent to these customers
-- For customers who order particular items on a seasonal basis, reminders can be sent at the approximate date of purchase

-- CUSTOMER RETENTION
-- HOW MANY CUSTOMERS ONLY ORDERED ONCE?

SELECT `Customer ID` FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY `Customer ID`
HAVING COUNT(increment_id) = 1;

SELECT COUNT(DISTINCT `Customer ID`)
FROM Pakistan_Ecommerce.ValidTransactions;
-- Approximately half of customers (22188/46321) only ordered using the platform once. This indicates a low customer retention rate. Firstly, reviews aand surveys should be conducted, not only about the items but the user experience of the platform itself to gain insights into customer pain points.
-- Additionally, loyaltly points and benefits should be incorporated to encourage customers from using the platform again.



-- 2) Products --> Identify top-selling products, as well as poor performing products based on refunds 
-- Top-selling SKUs by quantity 
SELECT sku, SUM(qty_ordered) AS total_quantity
FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY sku
ORDER BY SUM(qty_ordered) DESC
LIMIT 5366;
-- This indicates that these are the top 10% of products are the most popular amongst customers. 
-- To capitalise on this, e-commerce platforms can be designed to suggest complimentary or less popular products at check out.
-- Additionally, volume discounts, such as "3 for $10" can encourage bulk purchase.
-- We can analyse the data to optimise inventory and stock so these items remain available for customers.
-- A review section can be added into these platforms, so good ratings can entice new customers to purchase these products.

-- Which products bring in the greatest revenue?
SELECT sku, SUM(`price*q`) AS Total_Revenue
FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY sku
ORDER BY Total_Revenue DESC
LIMIT 5366;
-- These are the top 10% of products which have the greatest ROI. 
-- These can be placed on the homepage, to gain further traction.
-- Moreover, the e-commerce platforms can conduct flash sales and VIP discounts to promote purchase.
-- The most important factor may be to add a review column, so positive reviews make it easier for customers to make a hefty spend.
-- These items should also have a greater warranty and easy refund process, to further encourage customers to make the purchase.

-- Top 10% SKUs with high return or refund rate 
SELECT sku, COUNT(`status` = 'refund') AS Refund_Count FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY sku
ORDER BY Refund_Count DESC
LIMIT 5366;
-- These items have the highest return rate, hence revenue is lost from a business perspective as time and resources go into packaging, sourcing and delivering these items.
-- Customer pain points must be identified. Since every customer may not give a review, it could be incorporated into the refund process, to identify the issues with the products.
-- Moroever, product description and images can be improved to reflect the item more accurately.

-- Now let us find the products with the least orders, and which bring in the least revenue
SELECT sku
FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY sku
ORDER BY SUM(qty_ordered)
LIMIT 5366;

SELECT sku
FROM Pakistan_Ecommerce.ValidTransactions
GROUP BY sku
ORDER BY SUM(`price*q`)
LIMIT 5366;
-- These are the bottom 10% of products in terms of revenue and quantity ordered. The e-commerce platform should consider removing these items from their platform; for example, all the items in the bottom 10% of quantity ordered were only ordered once in 3 years.
-- Instead of spending resources towards these SKUs, they can be diverted into marketing, product enhancement, and increasing inventory optimisation of more popular products.

-- 3) Categories
/*
Sales by category (category_name_1). -------
Category trends over time – what grows, what fades. (Tableau) -----
*/

-- 4) Trends over time
-- Seasonality: Are there months with higher or lower sales consistently? ---

-- 5) Payment methods
/*
Payment and Order Characteristics
Most used payment methods for complete orders. (Tableau) ---
Most used payment methods for fraud orders(Tableau) ----
Most used payment methods for refund orders (Tableau) -------
Does payment method affect the average transaction amount? (Tableau) ------
Sales by payment method to assess preferences or limitations. ---- (Tableau)

-- We can see there is a huge preference for cash on delivery. It could be due to customers feel a sense of assurance when they pay after receiving their products.
-- It could also indicate easy access to cash or limited cashless options
-- The e-commerce platform can venture into the latest popular financial systems, such as EasyPaisa and SadaPay
*/

-- 6) Discounts
-- Do discounts significantly increase the quantity ordered? (SQL)
SELECT SUM(qty_ordered)/COUNT(*) FROM Pakistan_Ecommerce.ValidTransactions
WHERE discount_amount != 0;
SELECT SUM(qty_ordered)/COUNT(*) FROM Pakistan_Ecommerce.ValidTransactions
WHERE discount_amount = 0;
-- Unsurprisingly, average quantity is slightly greater (1.38 vs 1.32) when a discount is present. Hence we can conclude that a discount may encourage a greater quantity ordered. However, it also leads to a lower revenue hence calculated discounts should be given.

-- 7) Refunds are a big loss of revenue, it indicates customer dissatisfaction and resources are wasted towards these orders which result in minimal or no revenue
-- Are return/refund rates higher in certain categories (Tableau)
-- Correlation between cancellation and price (SQL)

/*


Others

--  Find any hidden patterns that are counter-intuitive for a layman
-- Can we predict number of orders, or item category or number of customers/amount in advance?

*/



-- anomalies
SELECT * FROM Pakistan_Ecommerce.TransactionsNew WHERE sku LIKE '%test_tcsconnect%';
-- In the sku, these particular ones seem wrong
-- test_tcsconnect, test_tcsconnect1, sentiments_WRK1612
SELECT * FROM Pakistan_Ecommerce.Transactions2 WHERE 
sku LIKE '%test_tcsconnect%' ;
-- we can see that all these orders are either cancelled or refunded, without a category, hence it is safe to assume
-- that these are faulty or not useful transactions, and will be removed from the dataset

SELECT * FROM Pakistan_Ecommerce.Transactions2 WHERE 
sku = "sentiments_WRK1612";
-- For this sku, there are 6 orders, and 1 of them if completed however with no category_name_1
-- There is nothing particulary wrong so we will keep it in the dataset, but perhaps limit analysis dependent on it

DELETE FROM Pakistan_Ecommerce.Transactions2
WHERE sku LIKE '%test_tcsconnect%' ;
SET SQL_SAFE_UPDATES = 1;


SELECT * FROM Pakistan_Ecommerce.TransactionsNew
WHERE `BI Status` = 'Valid';

/*
Statistics
-- Tableau stuff
Does payment method affect average transaction value
*/